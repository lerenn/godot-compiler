#!/bin/bash

# Variables
THREADS=$(nproc)
if [ -z "$TEMPLATE_BASE_DIR" ]; then TEMPLATE_BASE_DIR="${HOME}/.local/share/godot/templates"; fi
if [ -z "$GODOT_EDITOR" ]; then GODOT_EDITOR=godot.x11.tools.64; fi

# Get godot path and go
GODOT_PATH=$1
if [ "${GODOT_PATH}" == "" ]; then
	echo "Please put the path to Godot source code as argument"
	exit 1
fi 
cd "${GODOT_PATH}"

echo "# Update project"
git pull

echo "# Compile Editor for Linux"
scons -j${THREADS} platform=x11
cp ${GODOT_PATH}/bin/godot.x11.tools.64 ${OUTPUT_DIR}/

echo "# Get informations from compiled editor"
COMPLETE_VERSION=$(${GODOT_PATH}/bin/${GODOT_EDITOR} --version)
echo "Complete version is ${COMPLETE_VERSION}"
VERSION=$(echo "${COMPLETE_VERSION}" | sed 's|.custom.*||')
echo "Version is '${VERSION}'"

echo "# Create Template directory"
TEMPLATE_DIR="${TEMPLATE_BASE_DIR}/${VERSION}"
mkdir -p ${TEMPLATE_DIR}
echo "Template directory is '${TEMPLATE_DIR}'"

echo "# Compile and install export templates for Linux 64bits"
scons -j${THREADS} platform=x11 tools=no target=release bits=64
cp ${GODOT_PATH}/bin/godot.x11.opt.64 ${TEMPLATE_DIR}/linux_x11_64_release
scons -j${THREADS} platform=x11 tools=no target=release_debug bits=64
cp ${GODOT_PATH}/bin/godot.x11.opt.debug.64 ${TEMPLATE_DIR}/linux_x11_64_debug

echo "# Compile and install export templates for Android"
# Release mode
scons -j${THREADS} platform=android target=release android_arch=armv7
scons -j${THREADS} platform=android target=release android_arch=arm64v8
scons -j${THREADS} platform=android target=release android_arch=x86
scons -j${THREADS} platform=android target=release android_arch=x86_64
# Debug mode
scons -j${THREADS} platform=android target=release_debug android_arch=armv7
scons -j${THREADS} platform=android target=release_debug android_arch=arm64v8
scons -j${THREADS} platform=android target=release_debug android_arch=x86
scons -j${THREADS} platform=android target=release_debug android_arch=x86_64
# Building the APK
cd platform/android/java
./gradlew generateGodotTemplates
cd ../../..
# Copy file to templates directory
cp ${GODOT_PATH}/bin/android_release.apk ${TEMPLATE_DIR}/
cp ${GODOT_PATH}/bin/android_debug.apk ${TEMPLATE_DIR}/

echo "# Compile and install export templates for Windows"
echo "TODO"

echo "# Compile and install export templates for Web"
scons -j${THREADS} platform=javascript tools=no target=release javascript_eval=no
cp ${GODOT_PATH}/bin/godot.javascript.opt.zip ${TEMPLATE_DIR}/webassembly_release.zip
scons -j${THREADS} platform=javascript tools=no target=release_debug javascript_eval=no
cp ${GODOT_PATH}/bin/godot.javascript.opt.debug.zip ${TEMPLATE_DIR}/webassembly_debug.zip
