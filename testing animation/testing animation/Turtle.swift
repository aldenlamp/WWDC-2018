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
    public var animationTime = 0.0
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
    
    public func alignToPoint(point: CGPoint){
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
//                for i in path.cgPath.points(){
//                    print("Point: \(i)")
//                }
                
                path.cgPath.forEach { (element) in
                    print(element.points)
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
    
    public func moveInCurve(point: CGPoint, draw: Bool = true, autoAlign: Bool = true, animated: Bool = true){
        //        let newLine = CAShapeLayer()
        //
        //        // The animation
        //        let animation = CAKeyframeAnimation(keyPath: "position")
        //
        //        // Animation's path
        //        let path = UIBezierPath()
        //
        //        // Move the "cursor" to the start
        //        path.move(to: start)
        //
        //        // Calculate the control points
        //        let c1 = CGPoint(x: start.x + 64, y: start.y)
        //        let c2 = CGPoint(x: end.x,        y: end.y - 128)
        //
        //        // Draw a curve towards the end, using control points
        //
        //        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        //
        //        // Use this path as the animation's path (casted to CGPath)
        //        animation.path = path.cgPath;
        //
        //        // The other animations properties
        //        animation.fillMode              = kCAFillModeForwards
        //        animation.isRemovedOnCompletion = false
        //        animation.duration              = 1.0
        //        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        //
        //        // Apply it
        //        view.layer.add(animation, forKey:"trash")
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
    
}


extension CGPath {
    func points() -> [CGPoint]
    {
        var bezierPoints = [CGPoint]()
        self.forEach(body: { (element: CGPathElement) in
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
            for index in 0..<numberOfPoints {
                let point = element.points[index]
                bezierPoints.append(point)
            }
        })
        return bezierPoints
    }
    
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback as! CGPathApplierFunction)
    }
}
