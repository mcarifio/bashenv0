# apt.install android-sdk

u.have.command adb || return 0
export ANDROID_HOME=usr/lib/android-sdk
path.add ${ANDROID_HOME}/tools ${ANDROID_HOME}/platform-tools
