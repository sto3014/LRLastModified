#!/usr/bin/env bash
cd "$(dirname "$0")" 
export SCRIPT_DIR="$(pwd)"
export VERSION=1.1.1.1

cd $SCRIPT_DIR/target
echo Extract files to ~:
unzip -o LRLastModified$VERSION"_mac.zip" -d ~
echo done
