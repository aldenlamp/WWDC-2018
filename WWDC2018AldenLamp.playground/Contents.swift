
//: A UIKit based Playground for presenting user interface
//import WWDC2018Playground_2_Sources
import UIKit
import Foundation
import PlaygroundSupport

var width:CGFloat = 500
var height:CGFloat = 500

var mainVC = DrawViewController()
mainVC.setupView()
mainVC.setSize(width: width, height: height)
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = mainVC.view



var turtles = [Turtle]()
let turtle = Turtle()

for _ in 0...7{
    let i = Turtle()
    turtles.append(i)
    i.drawColor = UIColor.black
    mainVC.addTurtle(turtle: i)
    i.drawing = true
    i.drawingWidth = 5
}

for i in 4...7{
    turtles[i].duration = 0.6
    turtles[i].moveToPoint(point: CGPoint(x: mainVC.view.frame.midX, y: mainVC.view.frame.midY + 60), draw: false, path: UIBezierPath(), autoAlign: false, animated: false, curve: false)
}



//WWDC Drawing
// W
turtles[0].moveToPoint(point: CGPoint(x: 100 , y: 75), draw: false)
turtles[0].moveToPoint(point: CGPoint(x: 120 , y: 135), draw: true)
turtles[0].moveToPoint(point: CGPoint(x: 140 , y: 75), draw: true)
turtles[0].moveToPoint(point: CGPoint(x: 160 , y: 135), draw: true)
turtles[0].moveToPoint(point: CGPoint(x: 180 , y: 75), draw: true)
turtles[0].disapear()

// W
turtles[1].moveToPoint(point: CGPoint(x: 190 , y: 75), draw: false)
turtles[1].moveToPoint(point: CGPoint(x: 210 , y: 135), draw: true)
turtles[1].moveToPoint(point: CGPoint(x: 230 , y: 75), draw: true)
turtles[1].moveToPoint(point: CGPoint(x: 250 , y: 135), draw: true)
turtles[1].moveToPoint(point: CGPoint(x: 270 , y: 75), draw: true)
turtles[1].disapear()

// D
turtles[2].moveToPoint(point: CGPoint(x: 280 , y: 75), draw: false)
turtles[2].moveToPoint(point: CGPoint(x: 280 , y: 135), draw: true)
turtles[2].moveToPoint(point: CGPoint(x: 310 , y: 135), draw: true)
var controlDValue = 27
turtles[2].drawCurve(point: CGPoint(x: 310 , y: 75), control1: CGPoint(x: 310  + controlDValue, y: 125), control2: CGPoint(x: 310  + controlDValue, y: 85))
turtles[2].moveToPoint(point: CGPoint(x: 280 , y: 75), draw: true)
turtles[2].disapear()

// C
turtles[3].moveToPoint(point: CGPoint(x: 390 , y: 75), draw: false)
turtles[3].moveToPoint(point: CGPoint(x: 380 , y: 75), draw: true)
var controlCValue = -45
turtles[3].drawCurve(point: CGPoint(x: 380 , y: 135), control1: CGPoint(x: 380  + controlCValue, y: 75), control2: CGPoint(x: 380  + controlCValue, y: 135))
turtles[3].moveToPoint(point: CGPoint(x: 390 , y: 135), draw: true)
turtles[3].disapear()


//Drawing Shapes

turtles[4].drawColor = UIColor.blue
turtles[4].turnRight(degrees: 0)
turtles[4].drawShape(distance: 120, sides: 4)
turtles[4].drawShape(distance: 40, sides: 4)
turtles[4].disapear()


turtles[5].drawColor = UIColor.red
turtles[5].turnRight(degrees: 0)
turtles[5].drawShape(distance: 120, sides: 4, right: false)
turtles[5].drawShape(distance: 40, sides: 4, right: false)
turtles[5].disapear()

turtles[6].drawColor = UIColor.cyan
turtles[6].turnRight(degrees: 180)
turtles[6].drawShape(distance: 120, sides: 4)
turtles[6].drawShape(distance: 40, sides: 4)
turtles[6].disapear()


turtles[7].drawColor = UIColor.purple
turtles[7].turnLeft(degrees: 180)
turtles[7].drawShape(distance: 120, sides: 4, right: false)
turtles[7].drawShape(distance: 40, sides: 4, right: false)
turtles[7].disapear()


