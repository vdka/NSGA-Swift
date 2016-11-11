#!/bin/bash

# Must have swiftenv installed here. Default for homebrew

export SDKROOT=$(xcrun --show-sdk-path --sdk macosx)

SWIFTC_FLAGS="-DDebug"

swift build -c release -Xswiftc $SWIFTC_FLAGS &&
  echo "Build Succeeded!" || echo "Build Failed!"

