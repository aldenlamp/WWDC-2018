import Foundation
import UIKit

public class Turtle {
    public var position: CGPoint = CGPoint.zero{
        willSet{
            turtleImageView.center = newValue
        }
    }
    
    public var drawing = true
    
    public var orientation:Double = Double.pi / 2.0{
        willSet{
            self.turtleImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-(newValue - Double.pi / 2.0)))
        }
    }
    public var drawingWidth:CGFloat = 2
    public var size:CGFloat = 30
    private var animationTime = 0.0
    public var duration: Double = 1.0
    public var durationPerUnit: Double = 1.0/120.0
    public var turningFactor: Double = 2.0
    public var turtleImage = UIImage(named: "turtle.jpg")
    public var drawColor = UIColor.blue
    public var turtleImageView = UIImageView()
    public var drawView = UIView()
    
    var drawVC:DrawViewController?
    
    public init(){
        turtleImageView = UIImageView(image: turtleImage)
        turtleImageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
//        turtleImageView.frame = CGRect(origin: CGPoint(x: CGPoint.zero.x, y: CGPoint.zero.y + 120), size: CGSize(width: size, height: size))
        self.position = CGPoint(x: CGPoint.zero.x, y: CGPoint.zero.y + 60)
    }
    
    public func disapear(){
        UIView.animate(withDuration: 0.2, delay: animationTime, options: .curveEaseInOut, animations: {
            self.turtleImageView.alpha = 0
        })
    }
    
    
    public func drawShape(distance:Double, sides: Int,  right:Bool = true){
        for _ in 0..<sides{
            moveForward(distance: distance, draw: true)
            if right {
                turnRight(degrees: 360.0 / Double(sides))
            }else{
                turnLeft(degrees: 360.0 / Double(sides))
            }
        }
    }
    
    public func drawShape(distance:Double, sides: Int, startPossition: CGPoint, right:Bool = true){
        self.moveToPoint(point: startPossition, draw: false)
        drawShape(distance: distance, sides: sides)
    }
    
    
    public func moveForward(distance:Double, draw: Bool, animated:Bool = true){
        let diff = CGPoint(x: CGFloat(cos(self.orientation) * distance) + self.position.x, y: self.position.y - CGFloat(sin(self.orientation) * distance))
        
        return moveToPoint(point: diff, draw: draw)
    }
    
    private func alignToPoint(point: CGPoint){
        let deltaPossition = CGPoint(x: point.x - self.position.x, y: point.y - self.position.y )
        let degrees = atan2(deltaPossition.y, deltaPossition.x)// + 90//CGFloat(Double.pi / 2.0)
        turnToOrientation(orientation:  Double(-degrees))
    }
    
    public func drawCurve(point: CGPoint, control1: CGPoint, control2: CGPoint){
        let newLine = UIBezierPath()
        newLine.move(to: self.position)
        newLine.addCurve(to: point, controlPoint1: control1, controlPoint2: control2)
        moveToPoint(point: point, draw: true, path: newLine, autoAlign: true, animated: true, curve: true)
    }
    
    public func moveToPoint(point: CGPoint, draw: Bool, path: UIBezierPath = UIBezierPath(), autoAlign: Bool = true, animated: Bool = true, curve: Bool = false){
        let newLine = CAShapeLayer()
        
        if autoAlign{ alignToPoint(point: point) }
        
        if self.drawing && draw{
            var linePath = UIBezierPath()
            if curve{
                linePath = path
            }else{
                linePath.move(to: self.position)
                linePath.addLine(to: CGPoint(x: point.x, y: point.y))
            }
            
            newLine.path = linePath.cgPath
            newLine.lineWidth = self.drawingWidth
            newLine.fillColor = nil
            newLine.strokeColor = self.drawColor.cgColor
            newLine.strokeEnd = 0
            newLine.cornerRadius = self.drawingWidth / 2.0
            self.drawView.layer.addSublayer(newLine)
        }
        
        if self.drawing && animated{
            
            
            if curve{
                generateLookupTable(path: path)

                for i in 0...50{
                    UIView.animate(withDuration: self.duration / 50, delay: animationTime + (self.duration * Double(i) / 50.0), options: .curveEaseInOut, animations: {
                        
                        self.position.y = self.lookupTable[i].y
                        self.position.x = self.lookupTable[i].x
                    })
                }
            }else{
                UIView.animate(withDuration: self.duration, delay: animationTime, options: .curveEaseInOut, animations: {
                    
                    self.position.y = point.y
                    self.position.x = point.x
                }, completion: { (finished) in
                })
            }
            
            UIView.animate(withDuration: 0.01, delay: animationTime, options: .curveEaseInOut, animations: {
                self.drawView.center.y += 0.000000001  // Hack to make the timing correct
            }, completion: { (finished) in
                if draw{
                    let animation = CABasicAnimation(keyPath: "strokeEnd")
                    animation.duration = self.duration
                    animation.fromValue = 0.0
                    animation.toValue = 1.0
                    animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
                    newLine.strokeEnd = 1
                    newLine.add(animation, forKey: "Stroke animation")
                }
                
            })
            animationTime += self.duration
        }else{
            self.position.y = point.y
            self.position.x = point.x
        }
        
        return
    }
    
    
    private func radiansFrom(degrees: Double) -> Double{
        return degrees * Double.pi / 180.0
    }
    
    public func turnRight(degrees:Double, animated:Bool = true){
        if animated{
            UIView.animate(withDuration: self.duration / self.turningFactor, delay: animationTime, options: .curveEaseInOut, animations: {
                self.orientation  -= self.radiansFrom(degrees: degrees)
            }, completion: nil)
            animationTime += self.duration / self.turningFactor
        }else{
            self.orientation  -= radiansFrom(degrees: degrees)
        }
    }
    
    public func turnLeft(degrees:Double, animated:Bool = true){
        if animated{
            UIView.animate(withDuration: self.duration / self.turningFactor, delay: animationTime, options: .curveEaseInOut, animations: {
                self.orientation  += self.radiansFrom(degrees: degrees)
            }, completion: nil)
            animationTime += self.duration / self.turningFactor
        }else{
            self.orientation  += radiansFrom(degrees: degrees)
        }
    }
    
    public func turnToOrientation(orientation: Double, animated: Bool = true){
        //        print("Orientation: \(orientation)\tanimationTime: \(animationTime)")
        if animated{
            UIView.animate(withDuration: self.duration / self.turningFactor, delay: animationTime, options: .curveEaseInOut, animations: {
                self.orientation = orientation
            }, completion: nil)
        }else{
            self.orientation = orientation
        }
        animationTime += self.duration / self.turningFactor
    }
    
    
    private var lookupTable = [CGPoint]()
    
    private func generateLookupTable(path: UIBezierPath) {
        let points = path.cgPath.points()
        var previousPoint: CGPoint?
        let lookupTableCapacity = 100
        let piecesCount = points.count
        guard piecesCount > 0 else {
            return
        }
        let capacityPerPiece = lookupTableCapacity / piecesCount
        for command in points {
            let endPoint = command.point
            guard let startPoint = previousPoint else {
                previousPoint = endPoint
                continue
            }
    
//                 Cube curve
            for i in 0...capacityPerPiece {
                let t = CGFloat(i) / CGFloat(capacityPerPiece)
                let point = calculateCube(t: t, p1: startPoint, p2: command.controlPoints[0], p3: command.controlPoints[1], p4: endPoint)
                lookupTable.append(point)
            }
            previousPoint = endPoint
        }
    }
   
    /// Calculates a point at given t value, where t in 0.0...1.0
    private func calculateCube(t: CGFloat, p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> CGPoint {
        let mt = 1 - t
        let mt2 = mt*mt
        let t2 = t*t
        
        let a = mt2*mt
        let b = mt2*t*3
        let c = mt*t2*3
        let d = t*t2
        
        let x = a*p1.x + b*p2.x + c*p3.x + d*p4.x
        let y = a*p1.y + b*p2.y + c*p3.y + d*p4.y
        return CGPoint(x: x, y: y)
    }
}


struct PathCommand {
    let type: CGPathElementType
    let point: CGPoint
    let controlPoints: [CGPoint]
}

extension CGPath {
    func points() -> [PathCommand] {
        var bezierPoints = [PathCommand]()
        self.forEach(body: { (element: CGPathElement) in
            guard element.type != .closeSubpath else {
                return
            }
            let numberOfPoints: Int = {
                switch element.type {
                case .moveToPoint, .addLineToPoint: // contains 1 point
                    return 1
                case .addQuadCurveToPoint: // contains 2 points
                    return 2
                case .addCurveToPoint: // contains 3 points
                    return 3
                case .closeSubpath:
                    return 0
                }
            }()
            var points = [CGPoint]()
            for index in 0..<(numberOfPoints - 1) {
                let point = element.points[index]
                points.append(point)
            }
            let command = PathCommand(type: element.type, point: element.points[numberOfPoints - 1], controlPoints: points)
            bezierPoints.append(command)
        })
        return bezierPoints
    }
    
    func forEach(body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(_ info: UnsafeMutableRawPointer?, _ element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback as CGPathApplierFunction)
    }
}
