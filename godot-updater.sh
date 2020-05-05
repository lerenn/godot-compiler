#!/bin/bash

# Variables
THREADS=$(nproc)

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

echo "# Get version"
COMPLETE_VERSION=$(${GODOT_PATH}/bin/godot.x11.tools.64 --version)
echo "Complete version is ${COMPLETE_VERSION}"
VERSION=$(echo "${COMPLETE_VERSION}" | sed 's|.custom.*||')
echo "Version is '${VERSION}'"

echo "# Compile Export templates for Linux 64bits"
scons -j${THREADS} platform=x11 tools=no target=release bits=64
scons -j${THREADS} platform=x11 tools=no target=release_debug bits=64

echo "# Install export templates into ${USER} home"
TEMPLATE_DIR="${HOME}/.local/share/godot/templates/${VERSION}/"
mkdir -p ${TEMPLATE_DIR}
cp ${GODOT_PATH}/bin/godot.x11.opt.64 ${TEMPLATE_DIR}/linux_x11_64_release
cp ${GODOT_PATH}/bin/godot.x11.opt.debug.64 ${TEMPLATE_DIR}/linux_x11_64_debug
