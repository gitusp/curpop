import Cocoa
import QuartzCore

let canvasSize: CGFloat = 280
let lineCount = 256
let innerRadius: CGFloat = 22
let lineBaseWidth: CGFloat = 2
let frameInterval: TimeInterval = 0.12
let frameCount = 16

let accentColor = NSColor.black

let totalLifetime: TimeInterval = frameInterval * Double(frameCount) + 0.02

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let pos = NSEvent.mouseLocation

let window = NSWindow(
    contentRect: NSRect(
        x: pos.x - canvasSize / 2,
        y: pos.y - canvasSize / 2,
        width: canvasSize,
        height: canvasSize
    ),
    styleMask: .borderless,
    backing: .buffered,
    defer: false
)
window.isOpaque = false
window.backgroundColor = .clear
window.level = .screenSaver
window.ignoresMouseEvents = true
window.hasShadow = false
window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

let view = NSView(frame: NSRect(x: 0, y: 0, width: canvasSize, height: canvasSize))
view.wantsLayer = true
view.layer?.shouldRasterize = false

let centerPoint = CGPoint(x: canvasSize / 2, y: canvasSize / 2)
let outerRadius = canvasSize / 2

func addFocusLine(angle: CGFloat) {
    let lengthRatio = CGFloat.random(in: 0.78...1.0)
    let innerJitter = CGFloat.random(in: 0...32)
    let widthRatio = CGFloat.random(in: 0.55...1.25)
    let midBias = CGFloat.random(in: 0.4...0.6)

    let actualInner = innerRadius + innerJitter
    let actualOuter = outerRadius * lengthRatio
    let halfWidth = (lineBaseWidth * widthRatio) / 2

    let cosA = cos(angle)
    let sinA = sin(angle)
    let perpX = -sinA
    let perpY = cosA
    let mid = actualInner + (actualOuter - actualInner) * midBias

    let innerPoint = CGPoint(
        x: centerPoint.x + cosA * actualInner,
        y: centerPoint.y + sinA * actualInner
    )
    let outerPoint = CGPoint(
        x: centerPoint.x + cosA * actualOuter,
        y: centerPoint.y + sinA * actualOuter
    )
    let midCenter = CGPoint(
        x: centerPoint.x + cosA * mid,
        y: centerPoint.y + sinA * mid
    )
    let midLeft = CGPoint(
        x: midCenter.x + perpX * halfWidth,
        y: midCenter.y + perpY * halfWidth
    )
    let midRight = CGPoint(
        x: midCenter.x - perpX * halfWidth,
        y: midCenter.y - perpY * halfWidth
    )

    let path = CGMutablePath()
    path.move(to: innerPoint)
    path.addLine(to: midLeft)
    path.addLine(to: outerPoint)
    path.addLine(to: midRight)
    path.closeSubpath()

    let line = CAShapeLayer()
    line.path = path
    line.fillColor = accentColor.cgColor
    line.strokeColor = NSColor.clear.cgColor

    view.layer?.addSublayer(line)
}

func drawFrame() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    view.layer?.sublayers?.forEach { $0.removeFromSuperlayer() }
    let angleStep = .pi * 2 / CGFloat(lineCount)
    for i in 0..<lineCount {
        let baseAngle = CGFloat(i) * angleStep
        let jitter = CGFloat.random(in: -angleStep...angleStep) * 0.6
        addFocusLine(angle: baseAngle + jitter)
    }
    CATransaction.commit()
}

window.contentView = view
window.orderFrontRegardless()

drawFrame()
for f in 1..<frameCount {
    DispatchQueue.main.asyncAfter(deadline: .now() + frameInterval * Double(f)) {
        drawFrame()
    }
}

DispatchQueue.main.asyncAfter(deadline: .now() + totalLifetime) {
    exit(0)
}

app.run()
