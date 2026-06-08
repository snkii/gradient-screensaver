PRODUCT = GradientScreenSaver.saver
BINARY  = $(PRODUCT)/Contents/MacOS/GradientScreenSaver
SDK     = $(shell xcrun --sdk macosx --show-sdk-path)
ARCH    = $(shell uname -m)
TARGET  = $(ARCH)-apple-macosx12.0

.PHONY: build install clean

build:
	mkdir -p $(PRODUCT)/Contents/MacOS
	swiftc \
		-target $(TARGET) \
		-sdk "$(SDK)" \
		-framework ScreenSaver \
		-framework AppKit \
		-Xlinker -bundle \
		-o $(BINARY) \
		GradientScreenSaver.swift
	cp Info.plist $(PRODUCT)/Contents/Info.plist
	codesign --force --deep --sign - $(PRODUCT)
	@echo "✓ Build complete: $(PRODUCT)"

install: build
	mkdir -p "$(HOME)/Library/Screen Savers"
	cp -r $(PRODUCT) "$(HOME)/Library/Screen Savers/"
	@echo "✓ Installed. System Settings → Screen Saver → GradientScreenSaver"

clean:
	rm -rf $(PRODUCT)
