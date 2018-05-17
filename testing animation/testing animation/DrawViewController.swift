import Foundation
import UIKit

public class DrawViewController : UIViewController {
    
    var animationDuration:Double = 0.5
    var width:CGFloat = 500
    var height:CGFloat = 500
    var turtle = [Turtle]()
    
    var lines = [CAShapeLayer]()
    
    public func setupView(){
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        view.backgroundColor = .white
        
        self.view = view
    }
    
    
    public func setSize(width: CGFloat, height:CGFloat){
        self.view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        self.width = width
        self.height = height
    }
    
    public func addTurtle(turtle:Turtle){
        turtle.drawView = self.view
        turtle.position = self.view.center
        turtle.drawVC = self
        self.view.addSubview(turtle.turtleImageView)
    }
    
    public func addLine(line: CAShapeLayer){
        self.lines.append(line)
    }
}
