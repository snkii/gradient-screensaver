import ScreenSaver
import AppKit
import CoreGraphics

public class GradientScreenSaverView: ScreenSaverView {

    private struct RGB {
        var r, g, b: CGFloat
    }

    private struct Blob {
        var x, y, vx, vy, vr, radius, sx, sy, rot, colorElapsed: CGFloat
        var current, start, target: RGB
    }

    private let palette: [RGB] = [
        RGB(r: 250/255, g: 189/255, b:  47/255),
        RGB(r: 215/255, g: 153/255, b:  33/255),
        RGB(r: 254/255, g: 128/255, b:  25/255),
        RGB(r: 251/255, g:  73/255, b:  52/255),
        RGB(r: 184/255, g: 187/255, b:  38/255),
        RGB(r: 142/255, g: 192/255, b: 124/255),
        RGB(r: 131/255, g: 165/255, b: 152/255),
        RGB(r:  69/255, g: 133/255, b: 136/255),
        RGB(r: 211/255, g: 134/255, b: 155/255),
        RGB(r: 146/255, g: 131/255, b: 116/255),
    ]

    private let blobSizeFactor: CGFloat = 0.90
    private let blurFactor: CGFloat = 0.22
    private let colorTransitionSeconds: CGFloat = 6.5

    private var blobs: [Blob] = []
    private var colorTimer: Timer?
    private var lastFrameTime: TimeInterval?

    public override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        animationTimeInterval = 1.0 / 15.0

        for _ in 0..<3 {
            let color = randomColor()
            let velocity = randomVelocity()
            blobs.append(Blob(
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
            ))
        }

        colorTimer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { [weak self] _ in
            self?.randomizeTargets()
        }
    }

    deinit {
        colorTimer?.invalidate()
    }

    private func randomizeTargets() {
        for i in 0..<blobs.count {
            blobs[i].start = blobs[i].current
            blobs[i].target = randomColor()
            blobs[i].colorElapsed = 0
        }
    }

    private func randomColor() -> RGB {
        palette[Int.random(in: 0..<palette.count)]
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

    private func lerp(_ a: RGB, _ b: RGB, _ t: CGFloat) -> RGB {
        RGB(r: lerp(a.r, b.r, t), g: lerp(a.g, b.g, t), b: lerp(a.b, b.b, t))
    }

    public override func animateOneFrame() {
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
        setNeedsDisplay(bounds)
    }

    public override func draw(_ rect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        ctx.setFillColor(CGColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1))
        ctx.fill(bounds)

        let minDim = min(bounds.width, bounds.height)
        for b in blobs {
            let size = b.radius * blobSizeFactor * minDim
            drawBlob(ctx: ctx,
                     cx: b.x * bounds.width,
                     cy: b.y * bounds.height,
                     size: size,
                     blur: blurFactor * minDim,
                     sx: b.sx,
                     sy: b.sy,
                     rot: b.rot,
                     color: b.current)
        }
    }

    private func drawBlob(ctx: CGContext, cx: CGFloat, cy: CGFloat, size: CGFloat,
                          blur: CGFloat, sx: CGFloat, sy: CGFloat, rot: CGFloat,
                          color: RGB) {
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
