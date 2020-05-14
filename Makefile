SHORTCUT_NAME=org.godotengine.Godot.desktop
SHORTCUT_PATH=./code/misc/dist/linux/$(SHORTCUT_NAME)
SHORTCUT_INSTALL_PATH=${HOME}/.local/share/applications

TEMPLATES_PATH=output/templates
TEMPLATES_INSTALL_PATH=${HOME}/.local/share/godot/templates

ICON_NAME=icon.png
ICON_PATH=code
ICON_INSTALL_PATH=${HOME}/.local/share/godot

EDITOR_NAME=godot.x11.tools.64
EDITOR_PATH=output/$(EDITOR_NAME)
EDITOR_INSTALL_PATH=${HOME}/.local/bin

all: build compile install

build:
	sudo docker-compose build

compile:
	mkdir -p code output
	sudo docker-compose up

install:
	# Install editor
	mkdir -p $(EDITOR_INSTALL_PATH)
	cp $(EDITOR_PATH) $(EDITOR_INSTALL_PATH)
	# Install templates
	mkdir -p $(TEMPLATES_INSTALL_PATH)
	cp -r $(TEMPLATES_PATH)/* $(TEMPLATES_INSTALL_PATH)
	# Install icon
	mkdir -p $(ICON_INSTALL_PATH)
	cp -r $(ICON_PATH)/$(ICON_NAME) $(ICON_INSTALL_PATH)
	# Install shortcut
	cp $(SHORTCUT_PATH) output
	sed -i "s|Exec=.*|Exec=$(EDITOR_INSTALL_PATH)/$(EDITOR_NAME) %f|" output/$(SHORTCUT_NAME)
	sed -i "s|Icon=.*|Icon=$(ICON_INSTALL_PATH)/$(ICON_NAME)|" output/$(SHORTCUT_NAME)
	cp output/$(SHORTCUT_NAME) $(SHORTCUT_INSTALL_PATH)


