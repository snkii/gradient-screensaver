BINARY  = GradientWallpaper
SDK     = $(shell xcrun --sdk macosx --show-sdk-path)
ARCH    = $(shell uname -m)
TARGET  = $(ARCH)-apple-macosx12.0

.PHONY: build run stop install-login clean

build:
	swiftc \
		-target $(TARGET) \
		-sdk "$(SDK)" \
		-framework AppKit \
		-framework WebKit \
		-framework CoreGraphics \
		-o $(BINARY) \
		GradientWallpaper.swift
	@echo "✓ Build complete"

run: build
	pkill -f GradientWallpaper 2>/dev/null || true
	nohup ./$(BINARY) > /dev/null 2>&1 &
	@echo "✓ Running in background (wallpaper active)"

stop:
	pkill -f GradientWallpaper 2>/dev/null && echo "✓ Stopped" || echo "Not running"

install-login: build
	cp $(BINARY) "$(HOME)/Library/Application Support/GradientWallpaper"
	osascript -e 'tell application "System Events" to make login item at end with properties {path:"$(HOME)/Library/Application Support/GradientWallpaper", hidden:true}'
	@echo "✓ Added to login items"

clean:
	rm -f $(BINARY)
