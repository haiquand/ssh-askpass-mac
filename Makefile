APP_NAME = ssh-askpass-mac
CONFIG = Release
BUILD_DIR = build
PROJECT = $(APP_NAME).xcodeproj

ifndef XCODEBUILD
XCODEBUILD := $(shell which xcodebuild)
endif

ifeq ($(XCODEBUILD),)
$(error ❌ xcodebuild not found! Please install Xcode or set PATH correctly.)
endif

.PHONY: all clean debug release run run-debug

all: release

debug:
	@echo "Building Debug with ASKPASS_DEBUG..."
	@$(XCODEBUILD) \
		-project $(PROJECT) \
		-scheme $(APP_NAME) \
		-configuration Debug \
		-derivedDataPath $(BUILD_DIR) \
		OTHER_SWIFT_FLAGS="-D ASKPASS_DEBUG" \
		| tee build_debug.log

release:
	@echo "Building Release..."
	@$(XCODEBUILD) \
		-project $(PROJECT) \
		-scheme $(APP_NAME) \
		-configuration Release \
		-derivedDataPath $(BUILD_DIR) \
		| tee build_release.log

run:
	@echo "Running $(APP_NAME) (Release)"
	@./$(BUILD_DIR)/Build/Products/$(CONFIG)/$(APP_NAME).app/Contents/MacOS/$(APP_NAME) test-run

run-debug:
	@echo "Runing $(APP_NAME) (Debug)"
	@./$(BUILD_DIR)/Build/Products/Debug/$(APP_NAME).app/Contents/MacOS/$(APP_NAME) test-run

clean:
	@echo "Cleaning"
	@$(XCODEBUILD) clean -project $(PROJECT) -scheme $(APP_NAME)
	@rm -rf $(BUILD_DIR) build_*.log