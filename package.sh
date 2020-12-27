#!/usr/bin/env bash
export SCRIPT_DIR="$(dirname "$0")"
export PACKAGE_NAME=lastmodified
export TARGET_DIR=$SCRIPT_DIR/target/$PACKAGE_NAME.lrplugin
# cleanup
if [ -d  "$TARGET_DIR" ]; then
   rm -d -f -r $TARGET_DIR
fi
mkdir $TARGET_DIR
# copy dev
export SOURCE_DIR=$SCRIPT_DIR/src/main/lua/$PACKAGE_NAME.lrdevplugin
cp -R $SOURCE_DIR/* $TARGET_DIR
# compile
cd $TARGET_DIR
for f in *.lua
do
 luac5.1 -o $f $f
done