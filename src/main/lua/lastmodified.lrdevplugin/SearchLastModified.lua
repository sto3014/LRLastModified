--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrLogger = import 'LrLogger'
local LrApplication = import 'LrApplication'
local LrProgressScope = import("LrProgressScope")
local LrPrefs = import("LrPrefs")


-- Logger
local log = LrLogger('LastModifiedLogger') -- the log file name
log:enable("logfile")


--[[---------------------------------------------------------------------------
Utilities
-----------------------------------------------------------------------------]]
function setContains(set, key)
    return set[key] ~= nil
end

function addToSet(set, key)
    if not setContains(set, key) then
        set[key] = true
    end
end

function removeFromSet(set, key)
    set[key] = nil
end

function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)   
    local catalog = LrApplication.activeCatalog()
    log:trace("Catalog: " .. catalog:getPath())

    -- progressbar
    local Progress = LrProgressScope({
        title = LOC "$$$/LRLastModified/Progress/Get last modified photos=Get last modified photos",
        functionContext = context
    })

    -- getting all Photoshop photos because EXIF property dateTime is not indexed.
    local photosPSD
    photosPSD = catalog:findPhotos {
        searchDesc = {
            criteria = "fileFormat",
            operation = "==",
            value = "PSD",
        }
    }
    local srcCountPSD = #photosPSD
    log:trace("Found " .. srcCountPSD .. " Photoshop photo(s) in total.")


    -- getting raw metadate dateTime for all Photoshop photos
    log:trace("Get meta data for Photoshop photos.")
    local photoKeyTable
    photoKeyTable = catalog:batchGetRawMetadata(photosPSD, { "dateTime" })
    if photoKeyTable == nil then
        return nil
    end


    -- filter Photoshop photos via dateTime
    local prefs = LrPrefs.prefsForPlugin()

    local secs = os.time() - (prefs.numOfDays * 24 * 3600)
    log:trace("Last modified after date is: " .. os.date("%Y-%m-%d %H:%M:%S", secs))
    local resultPhotoSet = {}

    for p, s in pairs(photoKeyTable) do
        if s.dateTime ~= nil then
            local t = s.dateTime + 978307200
            if secs < t then
                addToSet(resultPhotoSet, p)
            end
        end
    end
    log:trace("Found " .. tablelength(resultPhotoSet) .. " Photoshop photo(s) where dateTime matches.")

    -- get all photos by property touchTime
    local photosAny
    photosAny = catalog:findPhotos {
        searchDesc = {
            criteria = "touchTime",
            operation = "inLast",
            value = prefs.numOfDays,
            value2 = 1,
            value_units = "days",
        }
    }
    local srcCountAny = #photosAny
    log:trace("Found " .. srcCountAny .. " photo(s) in global where touchTime matches.")

    -- append to result array
    for _, p in ipairs(photosAny) do
        addToSet(resultPhotoSet, p)
    end

    Progress:done()
    -- create collections
    local numOfPhotos = tablelength(resultPhotoSet)

    if numOfPhotos > 0 then
        -- Prog:setCaption("Create collection")
        catalog:withWriteAccessDo("Create collections", function()
            log:trace("Create collection.")
            local myColl = catalog:createCollection(LOC "$$$/LRLastModified/Collection/Last Modified=Last Modified", nil, true)

            if myColl ~= nil then
                Progress = LrProgressScope({
                    -- title = LOC "$$$/LRLastModified/Progress/Get last modified photos=Get last modified photos",
                    title = LOC("$$$/LRLastModified/Progress/Add ^1 photos to collection=Add ^1 photos to collection", numOfPhotos)
                ,
                    functionContext = context
                })

                Progress:setPortionComplete(0, numOfPhotos)
                if prefs.clearCollection then
                    log:trace("Remove existing photos.")
                    myColl:removeAllPhotos()
                end
                log:trace("Add " .. numOfPhotos .. " new photos.")
                local index = 0
                for p in pairs(resultPhotoSet) do
                    index = index + 1
                    Progress:setPortionComplete(index, numOfPhotos)

                    local array = {}
                    array[1] = p
                    myColl:addPhotos(array)

                end
            end
        end) -- create collections
    else
        LrDialogs.message(LOC "$$$/LRLastModified/Dialog/Info/No photos found=No photos found.", nil, "info")
    end
    Progress:done()
end -- end TaskFunc

--[[---------------------------------------------------------------------------
stringToNumber function
-----------------------------------------------------------------------------]]
function stringToNumber (theView, theString)
    return tonumber(theString)
end
--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("showSearchLastModified", function(context)
    -- Create dialog
    local factory = LrView.osFactory()
    -- Create a bindable table.  Whenever a field in this table changes
    -- then notifications will be sent.
    local props = LrBinding.makePropertyTable(context)
    props.numOfDays = 5
    props.clearCollection = false

    -- Create the contents for the dialog.
    local content = factory:column {
        spacing = factory:control_spacing(),
        bind_to_object = props,
        factory:row {
            -- Bind the table to the view.  This enables controls to be bound
            -- to the named field of the 'props' table.


            -- Add a checkbox and an edit_field.

            factory:static_text {
                title = LOC "$$$/LRLastModified/Dialog/Search/Text1=Last modified before",
            },

            factory:edit_field {
                value = LrView.bind("numOfDays"),
                min = 1,
                max = 100,
                width_in_digits = 3,
                string_to_value = stringToNumber
            },

            factory:static_text {
                title = LOC "$$$/LRLastModified/Dialog/Search/Text2=day(s)",
            },
        },
        factory:row {
            factory:checkbox {
                title = LOC "$$$/LRLastModified/Dialog/Search/Checkbox1=Clear collection",
                value = LrView.bind("clearCollection")
            }
        }
    } -- content

    -- Display dialog
    local r = LrDialogs.presentModalDialog {
        title = LOC "$$$/LRLastModified/Dialog/Search/Title=Search Last Modified",
        contents = content
    }

    -- Result handling
    log:trace("Result of dialog: " .. r)
    log:trace("Num of days: " .. props.numOfDays)
    if (r == "ok") then
        local prefs = LrPrefs.prefsForPlugin()
        prefs.numOfDays = props.numOfDays
        prefs.clearCollection = props.clearCollection
        log:trace("Search for last modified photos")
        LrFunctionContext.postAsyncTaskWithContext("Get Last Modified", TaskFunc)
    end
end) -- end main function



