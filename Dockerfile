FROM ubuntu:20.04
MAINTAINER Louis FRADIN <louis.fradin@gmail.com>

# Install dependencies
###############################################################################

# Update lists
RUN apt update

# Install dependencies for Editor
RUN DEBIAN_FRONTEND='noninteractive' apt install -y \
	build-essential scons pkg-config libx11-dev libxcursor-dev \
	libxinerama-dev libgl1-mesa-dev libglu-dev libasound2-dev \
	libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm

# Install dependencies for Web
RUN DEBIAN_FRONTEND='noninteractive' apt install -y git scons python3 && \
	git clone https://github.com/emscripten-core/emsdk.git /usr/src/emsdk && \
	cd /usr/src/emsdk && ./emsdk install latest && ./emsdk activate latest

# Get source code
###############################################################################

# Make the recipient a volume
VOLUME /godot

# Get Godot source code
RUN git clone https://github.com/godotengine/godot /godot

# Prepare branch number
ENV GODOT_BRANCH 3.2

# Volume for output results
VOLUME /output

# Copy scripts 
###############################################################################

# Copy docker specific scripts
COPY docker /docker

# Copy godot-compiler script 
COPY godot-compiler.sh /docker/scripts

# Command file 
CMD ["bash", "docker/scripts/entrypoint.sh"]