//
//  ViewController.swift
//  testing animation
//
//  Created by alden lamp on 3/30/18.
//  Copyright © 2018 alden lamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var width:CGFloat = 500
        var height:CGFloat = 500
        
        
        var mainVC = DrawViewController()
        mainVC.setupView()
        mainVC.setSize(width: width, height: height)
        
        self.view.addSubview(mainVC.view)
        
        var turtles = [Turtle]()
        
        
        for _ in 0...3{
            let i = Turtle()
            turtles.append(i)
            i.drawColor = UIColor.black
            mainVC.addTurtle(turtle: i)
            i.drawing = true
            i.drawingWidth = 5
        }
        
        
        //let turtle2 = Turtle()
        //turtle2.drawColor = UIColor.black
        //mainVC.addTurtle(turtle: turtle2)
        //turtle2.drawing = true
        //turtle2.drawingWidth = 5
        
        
        // W
        // 130, 75
        // 150, 135
        // 170, 75
        // 190, 135
        // 210, 75
        turtles[0].moveToPoint(point: CGPoint(x: 130, y: 75), draw: false)
        turtles[0].moveToPoint(point: CGPoint(x: 150, y: 135), draw: true)
        turtles[0].moveToPoint(point: CGPoint(x: 170, y: 75), draw: true)
        turtles[0].moveToPoint(point: CGPoint(x: 190, y: 135), draw: true)
        turtles[0].moveToPoint(point: CGPoint(x: 210, y: 75), draw: true)
        
        
        // W
        // 220, 75
        // 240, 135
        // 260, 75
        // 280, 135
        // 300, 75
        turtles[1].moveToPoint(point: CGPoint(x: 220, y: 75), draw: false)
        turtles[1].moveToPoint(point: CGPoint(x: 240, y: 135), draw: true)
        turtles[1].moveToPoint(point: CGPoint(x: 260, y: 75), draw: true)
        turtles[1].moveToPoint(point: CGPoint(x: 280, y: 135), draw: true)
        turtles[1].moveToPoint(point: CGPoint(x: 300, y: 75), draw: true)
        
        
        // D
        // 320, 75
        // 320, 135
        // 340, 135
        // 370, 105
        // 340, 75
        // 320, 75
        //turtles[2].moveToPoint(point: CGPoint(x: 320, y: 75), draw: false)
        //turtles[2].moveToPoint(point: CGPoint(x: 320, y: 135), draw: true)
        //turtles[2].moveToPoint(point: CGPoint(x: 340, y: 135), draw: true)
        //turtles[2].drawShape(distance: 1, sides: 100, right: false)
        //turtle.moveToPoint(point: CGPoint(x: 370, y: 105), draw: true, autoAlign: true)
        //turtle.moveToPoint(point: CGPoint(x: 340, y: 75), draw: true, autoAlign: true)
        //turtle.moveToPoint(point: CGPoint(x: 320, y: 75), draw: true, autoAlign: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

