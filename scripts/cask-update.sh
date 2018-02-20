#!/usr/bin/env bash
set -e

# dependencies:
# brew install jq

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$DIR/.."
DIST_DIR="$ROOT_DIR/dist"
CASK_DIR="$ROOT_DIR/stores/homebrew-cask"
DIST_CASK_DIR="$DIST_DIR/homebrew-cask"

if [ -d "$DIST_CASK_DIR" ]
then
    rm -rf $DIST_CASK_DIR
fi

cp -r $CASK_DIR $DIST_DIR

SRC_PACKAGE="$ROOT_DIR/src/package.json";
SRC_PACAKGE_VERSION=$(jq -r '.version' $SRC_PACKAGE)

ZIP="$DIST_DIR/Bitwarden-$SRC_PACAKGE_VERSION-mac.zip"
CHECKSUM=($(shasum -a 256 $ZIP))
CHECKPOINT=$(brew cask _appcast_checkpoint --calculate "https://github.com/bitwarden/desktop/releases.atom")
RB="$DIST_CASK_DIR/bitwarden.rb"
RB_NEW="$DIST_CASK_DIR/bitwarden.rb.new"

sed -e 's/__version__/'"$SRC_PACAKGE_VERSION"'/g; s/__checksum__/'"$CHECKSUM"'/g; s/__checkpoint__/'"$CHECKPOINT"'/g' $RB > $RB_NEW
mv -f $RB_NEW $RB