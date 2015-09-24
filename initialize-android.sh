#!/bin/bash
# stolen from https://docs.snap-ci.com/the-ci-environment/languages/android/

# raise an error if any command fails!
set -e

# existance of this file indicates that all dependencies were previously installed, and any changes to this file will use a different filename.
INITIALIZATION_FILE="$ANDROID_HOME/.initialized-dependencies-$(git log -n 1 --format=%h -- $0)"

if [ ! -e ${INITIALIZATION_FILE} ]; then
  # fetch and initialize $ANDROID_HOME
  download-android
  # Use the latest android sdk tools
  echo y | android update sdk --no-ui --all --filter platform-tools,tools,build-tools-23.0.1 > /dev/null

  # The SDK version used to compile your project
  echo y | android update sdk --no-ui --all --filter android-22,addon-google_apis-google-22 > /dev/null

  # uncomment these if you are using maven/gradle to build your android project
  echo y | android update sdk --no-ui --all --filter extra-google-m2repository > /dev/null
  echo y | android update sdk --no-ui --all --filter extra-android-m2repository  > /dev/null
  echo y | android update sdk --no-ui --all --filter extra-android-support,extra-google-gcm,extra-google-google_play_services,extra-google-webdriver > /dev/null

  # Specify at least one system image if you want to run emulator tests
  # echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-19 > /dev/null
  echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-addon-google_apis-google-22 > /dev/null
  echo y | android update sdk --no-ui --all --filter sys-img-x86_64-addon-google_apis-google-22 > /dev/null

  touch ${INITIALIZATION_FILE}
fi

# to start the emulator, we need Open GL in 32 bits which is not
# installed by default on Snap CI
echo "Install OpenGL 32 bits"
sudo yum install mesa-libGL.i686
echo "ldconfig"
sudo ldconfig
