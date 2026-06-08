import AppKit
import CoreGraphics

private struct MeshRGB {
    var r, g, b: CGFloat
}

private struct MeshBlob {
    var x, y, vx, vy, vr, radius, sx, sy, rot, colorElapsed: CGFloat
    var current, start, target: MeshRGB
}

private let meshPalette: [MeshRGB] = [
    MeshRGB(r: 250/255, g: 189/255, b:  47/255),
    MeshRGB(r: 215/255, g: 153/255, b:  33/255),
    MeshRGB(r: 254/255, g: 128/255, b:  25/255),
    MeshRGB(r: 251/255, g:  73/255, b:  52/255),
    MeshRGB(r: 184/255, g: 187/255, b:  38/255),
    MeshRGB(r: 142/255, g: 192/255, b: 124/255),
    MeshRGB(r: 131/255, g: 165/255, b: 152/255),
    MeshRGB(r:  69/255, g: 133/255, b: 136/255),
    MeshRGB(r: 211/255, g: 134/255, b: 155/255),
    MeshRGB(r: 146/255, g: 131/255, b: 116/255),
]

final class GradientWallpaperView: NSView {
    private let blobSizeFactor: CGFloat = 0.90
    private let blurFactor: CGFloat = 0.22

    private var blobs: [MeshBlob] = []
    private var frameTimer: Timer?
    private var colorTimer: Timer?
    private var lastFrameTime: TimeInterval?
    private var paused = false

    private var reduceMotion: Bool {
        NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    }

    private var frameInterval: TimeInterval {
        reduceMotion ? 0.5 : 1.0 / 15.0
    }

    private var colorInterval: TimeInterval {
        reduceMotion ? 16.0 : 7.0
    }

    private var colorTransitionSeconds: CGFloat {
        reduceMotion ? 14.0 : 6.5
    }

    override var isOpaque: Bool { true }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = CGColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        initBlobs()
        startTimers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        layer?.backgroundColor = CGColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        initBlobs()
        startTimers()
    }

    deinit {
        stopTimers()
    }

    func setPaused(_ shouldPause: Bool) {
        guard paused != shouldPause else { return }
        paused = shouldPause
        if shouldPause {
            stopTimers()
        } else {
            lastFrameTime = Date.timeIntervalSinceReferenceDate
            startTimers()
            needsDisplay = true
        }
    }

    private func initBlobs() {
        blobs = (0..<3).map { _ in
            let color = randomColor()
            let velocity = randomVelocity()
            return MeshBlob(
                x: randomBetween(-0.12, 1.12),
                y: randomBetween(-0.10, 1.10),
                vx: velocity.vx,
                vy: velocity.vy,
                vr: randomBetween(-0.8, 0.8),
                radius: randomBetween(0.86, 1.08),
                sx: randomBetween(0.85, 1.38),
                sy: randomBetween(0.78, 1.28),
                rot: randomBetween(0, 360),
                colorElapsed: colorTransitionSeconds,
                current: color,
                start: color,
                target: color
            )
        }
    }

    private func startTimers() {
        guard frameTimer == nil, colorTimer == nil else { return }

        lastFrameTime = Date.timeIntervalSinceReferenceDate

        let frame = Timer(timeInterval: frameInterval, repeats: true) { [weak self] _ in
            self?.animateFrame()
        }
        RunLoop.main.add(frame, forMode: .common)
        frameTimer = frame

        let color = Timer(timeInterval: colorInterval, repeats: true) { [weak self] _ in
            self?.randomizeTargets()
        }
        RunLoop.main.add(color, forMode: .common)
        colorTimer = color
    }

    private func stopTimers() {
        frameTimer?.invalidate()
        colorTimer?.invalidate()
        frameTimer = nil
        colorTimer = nil
        lastFrameTime = nil
    }

    private func animateFrame() {
        guard !paused else { return }

        let now = Date.timeIntervalSinceReferenceDate
        let dt = CGFloat(min(now - (lastFrameTime ?? now), 0.25))
        lastFrameTime = now

        for i in 0..<blobs.count {
            blobs[i].x += blobs[i].vx * dt
            blobs[i].y += blobs[i].vy * dt
            blobs[i].rot += blobs[i].vr * dt
            if blobs[i].x < -0.2 || blobs[i].x > 1.2 { blobs[i].vx = -blobs[i].vx }
            if blobs[i].y < -0.2 || blobs[i].y > 1.2 { blobs[i].vy = -blobs[i].vy }
            if blobs[i].colorElapsed < colorTransitionSeconds {
                blobs[i].colorElapsed += dt
                blobs[i].current = lerp(blobs[i].start, blobs[i].target,
                                        easeInOut(blobs[i].colorElapsed / colorTransitionSeconds))
            }
        }

        needsDisplay = true
    }

    private func randomizeTargets() {
        guard !paused else { return }
        for i in 0..<blobs.count {
            blobs[i].start = blobs[i].current
            blobs[i].target = randomColor()
            blobs[i].colorElapsed = 0
        }
    }

    private func randomColor() -> MeshRGB {
        meshPalette[Int.random(in: 0..<meshPalette.count)]
    }

    private func randomBetween(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        min + CGFloat.random(in: 0...1) * (max - min)
    }

    private func randomVelocity() -> (vx: CGFloat, vy: CGFloat) {
        let angle = randomBetween(0, CGFloat.pi * 2)
        let speed = randomBetween(0.0026, 0.0054)
        return (cos(angle) * speed, sin(angle) * speed)
    }

    private func easeInOut(_ t: CGFloat) -> CGFloat {
        let x = min(max(t, 0), 1)
        return x * x * (3 - 2 * x)
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }

    private func lerp(_ a: MeshRGB, _ b: MeshRGB, _ t: CGFloat) -> MeshRGB {
        MeshRGB(r: lerp(a.r, b.r, t), g: lerp(a.g, b.g, t), b: lerp(a.b, b.b, t))
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        ctx.setFillColor(CGColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1))
        ctx.fill(bounds)

        let minDim = min(bounds.width, bounds.height)
        guard minDim > 0 else { return }

        for blob in blobs {
            let size = blob.radius * blobSizeFactor * minDim
            drawBlob(ctx: ctx,
                     cx: blob.x * bounds.width,
                     cy: blob.y * bounds.height,
                     size: size,
                     blur: blurFactor * minDim,
                     sx: blob.sx,
                     sy: blob.sy,
                     rot: blob.rot,
                     color: blob.current)
        }
    }

    private func drawBlob(ctx: CGContext, cx: CGFloat, cy: CGFloat, size: CGFloat,
                          blur: CGFloat, sx: CGFloat, sy: CGFloat, rot: CGFloat,
                          color: MeshRGB) {
        let radius = size / 2 + blur * 2
        let colors = [
            CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.70),
            CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.52),
            CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.18),
            CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.0),
        ] as CFArray
        let locations: [CGFloat] = [0, 0.34, 0.72, 1]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors,
                                        locations: locations) else { return }

        ctx.saveGState()
        ctx.translateBy(x: cx, y: cy)
        ctx.rotate(by: rot * CGFloat.pi / 180)
        ctx.scaleBy(x: sx, y: sy)
        ctx.drawRadialGradient(gradient,
                               startCenter: .zero,
                               startRadius: 0,
                               endCenter: .zero,
                               endRadius: radius,
                               options: [.drawsAfterEndLocation])
        ctx.restoreGState()
    }
}

func makeStaticWallpaperURL(for screen: NSScreen, index: Int) -> URL? {
    let scale = screen.backingScaleFactor
    let pointSize = screen.frame.size
    let pixelWidth = max(2, Int(pointSize.width * scale))
    let pixelHeight = max(2, Int(pointSize.height * scale))
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(data: nil,
                              width: pixelWidth,
                              height: pixelHeight,
                              bitsPerComponent: 8,
                              bytesPerRow: 0,
                              space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
    else { return nil }

    let width = CGFloat(pixelWidth)
    let height = CGFloat(pixelHeight)
    let minDim = min(width, height)

    ctx.setFillColor(CGColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1))
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))

    for _ in 0..<4 {
        let color = meshPalette[Int.random(in: 0..<meshPalette.count)]
        drawStaticBlob(ctx: ctx,
                       cx: randomBetween(-0.08, 1.08) * width,
                       cy: randomBetween(-0.08, 1.08) * height,
                       size: randomBetween(0.86, 1.10) * 0.90 * minDim,
                       blur: 0.22 * minDim,
                       sx: randomBetween(0.85, 1.38),
                       sy: randomBetween(0.78, 1.28),
                       rot: randomBetween(0, 360),
                       color: color)
    }

    guard let cgImage = ctx.makeImage() else { return nil }
    let rep = NSBitmapImageRep(cgImage: cgImage)
    guard let png = rep.representation(using: .png, properties: [:]) else { return nil }

    let filename = "gradient_wallpaper_lock_\(index)_\(UUID().uuidString).png"
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
    try? png.write(to: url)
    return url
}

private func randomBetween(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
    min + CGFloat.random(in: 0...1) * (max - min)
}

private func drawStaticBlob(ctx: CGContext, cx: CGFloat, cy: CGFloat, size: CGFloat,
                            blur: CGFloat, sx: CGFloat, sy: CGFloat, rot: CGFloat,
                            color: MeshRGB) {
    let radius = size / 2 + blur * 2
    let colors = [
        CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.70),
        CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.52),
        CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.18),
        CGColor(red: color.r, green: color.g, blue: color.b, alpha: 0.0),
    ] as CFArray
    let locations: [CGFloat] = [0, 0.34, 0.72, 1]
    guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors,
                                    locations: locations) else { return }

    ctx.saveGState()
    ctx.translateBy(x: cx, y: cy)
    ctx.rotate(by: rot * CGFloat.pi / 180)
    ctx.scaleBy(x: sx, y: sy)
    ctx.drawRadialGradient(gradient,
                           startCenter: .zero,
                           startRadius: 0,
                           endCenter: .zero,
                           endRadius: radius,
                           options: [.drawsAfterEndLocation])
    ctx.restoreGState()
}

class WallpaperDelegate: NSObject, NSApplicationDelegate {
    var windows: [NSWindow] = []
    var statusItem: NSStatusItem?
    var originalWallpapers: [NSScreen: URL] = [:]
    var pausedForSystem = false
    var pausedForActivity = false
    var animationPaused = false

    func applicationDidFinishLaunching(_ n: Notification) {
        replaceSystemWallpaper()
        NSScreen.screens.forEach { windows.append(makeWindow($0)) }
        setupMenuBar()
        setupSleepObservers()
        setupActivityObservers()
        updateActivityPause(force: true)
    }

    func applicationWillTerminate(_ n: Notification) {
        restoreSystemWallpaper()
    }

    // MARK: - System wallpaper replacement

    func replaceSystemWallpaper() {
        for (index, screen) in NSScreen.screens.enumerated() {
            if let original = NSWorkspace.shared.desktopImageURL(for: screen) {
                originalWallpapers[screen] = original
            }
            if let meshURL = makeStaticWallpaperURL(for: screen, index: index) {
                try? NSWorkspace.shared.setDesktopImageURL(meshURL, for: screen, options: [:])
            }
        }
    }

    func refreshLockScreenWallpaper() {
        for (index, screen) in NSScreen.screens.enumerated() {
            if let meshURL = makeStaticWallpaperURL(for: screen, index: index) {
                try? NSWorkspace.shared.setDesktopImageURL(meshURL, for: screen, options: [:])
            }
        }
    }

    func restoreSystemWallpaper() {
        for (screen, url) in originalWallpapers {
            try? NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
        }
    }

    // MARK: - Sleep / lock observers

    func setupSleepObservers() {
        let ws = NSWorkspace.shared.notificationCenter
        ws.addObserver(self, selector: #selector(pauseForSystem),
                       name: NSWorkspace.screensDidSleepNotification, object: nil)
        ws.addObserver(self, selector: #selector(pauseForSystem),
                       name: NSWorkspace.sessionDidResignActiveNotification, object: nil)
        ws.addObserver(self, selector: #selector(resumeFromSystem),
                       name: NSWorkspace.screensDidWakeNotification, object: nil)
        ws.addObserver(self, selector: #selector(resumeFromSystem),
                       name: NSWorkspace.sessionDidBecomeActiveNotification, object: nil)
    }

    func setupActivityObservers() {
        let ws = NSWorkspace.shared.notificationCenter
        ws.addObserver(self, selector: #selector(activeApplicationDidChange),
                       name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }

    @objc func pauseForSystem() {
        refreshLockScreenWallpaper()
        pausedForSystem = true
        refreshAnimationState()
    }

    @objc func resumeFromSystem() {
        pausedForSystem = false
        updateActivityPause()
    }

    @objc func activeApplicationDidChange() {
        updateActivityPause()
    }

    func updateActivityPause(force: Bool = false) {
        let bundleID = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        pausedForActivity = bundleID != nil && bundleID != "com.apple.finder"
        refreshAnimationState(force: force)
    }

    func refreshAnimationState(force: Bool = false) {
        let shouldPause = pausedForSystem || pausedForActivity
        guard force || shouldPause != animationPaused else { return }
        animationPaused = shouldPause
        gradientViews().forEach { $0.setPaused(shouldPause) }
    }

    func gradientViews() -> [GradientWallpaperView] {
        windows.compactMap { $0.contentView as? GradientWallpaperView }
    }

    // MARK: - Menu bar

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Gradient Wallpaper")
        }
        let menu = NSMenu()
        let header = NSMenuItem(title: "Gradient Wallpaper", action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu
    }

    // MARK: - Window

    func makeWindow(_ screen: NSScreen) -> NSWindow {
        let win = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false,
            screen: screen
        )
        win.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        win.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        win.isOpaque = true
        win.hasShadow = false
        win.ignoresMouseEvents = true
        win.backgroundColor = NSColor(deviceRed: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        win.setFrame(screen.frame, display: true)

        let view = GradientWallpaperView(frame: CGRect(origin: .zero, size: screen.frame.size))
        view.autoresizingMask = [.width, .height]
        win.contentView = view

        win.orderFrontRegardless()
        return win
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = WallpaperDelegate()
app.delegate = delegate
app.run()
