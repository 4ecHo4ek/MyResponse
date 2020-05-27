//
//  ColorsSelection.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 27.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit
import RealmSwift

class ColorsSelection: UIViewController {
    
    var color: Results<Colors>!
    var id = 0
    
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var markControl: UISegmentedControl!
    @IBOutlet weak var blueSlider: UISlider! {
        didSet {
            blueSlider.transform = CGAffineTransform(rotationAngle: -.pi/2)
            blueSlider.tintColor = UIColor.red
        }
    }
    @IBOutlet weak var greenSlider: UISlider! {
        didSet {
            greenSlider.transform = CGAffineTransform(rotationAngle: -.pi/2)
            greenSlider.tintColor = UIColor.green
        }
    }
    @IBOutlet weak var redSlider: UISlider! {
        didSet {
            redSlider.transform = CGAffineTransform(rotationAngle: -.pi/2)
            redSlider.tintColor = UIColor.blue
        }
    }
    @IBOutlet weak var alphaSlider: UISlider!
    
    
    
    @IBAction func changeMark(_ sender: UISegmentedControl) {
        findMark()
        redSlider.value = Float(color[id].red)
        greenSlider.value = Float(color[id].green)
        blueSlider.value = Float(color[id].blue)
        alphaSlider.value = Float(color[id].alpha)
        changeColor()
    }
    
    @IBAction func changeColor(_ sender: UISlider) {
        setColor()
        changeColor()
    }
    
    @IBAction func setStandart(_ sender: UIBarButtonItem) {
        var (r,g,b): (Float, Float, Float) = (0,0,0)
               switch id {
               case 0:
                   (r,g,b) = (1,0,0)
               case 1:
                   (r,g,b) = (1,0.5,0)
               case 2:
                   (r,g,b) = (1,1,0.5)
               case 3:
                   (r,g,b) = (0.5,1,0.5)
               case 4:
                   (r,g,b) = (0,1,0)
               default:
                   break
               }
               redSlider.value = r
               greenSlider.value = g
               blueSlider.value = b
               alphaSlider.value = 0.5
               
               changeColor()
        
               setColor()
    }
    
    
    private  func findMark() {
        switch markControl.selectedSegmentIndex {
        case 0:
            id = 0
        case 1:
            id = 1
        case 2:
            id = 2
        case 3:
            id = 3
        case 4:
            id = 4
        default:
            break
        }
    }
    
    
    
    private func setColor() {
        try! realm.write{
            color[id].red = Double(redSlider.value)
            color[id].green = Double(greenSlider.value)
            color[id].blue = Double(blueSlider.value)
            color[id].alpha = Double(alphaSlider.value)
        }
    }
    
    private func start() {
        redSlider.value = Float(color[0].red)
        greenSlider.value = Float(color[0].green)
        blueSlider.value = Float(color[0].blue)
        alphaSlider.value = Float(color[0].alpha)
        markControl.selectedSegmentIndex = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color = realm.objects(Colors.self)
        
        start()
        changeColor()
    }
    
    private func changeColor() {
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                            green: CGFloat(greenSlider.value),
                                            blue: CGFloat(blueSlider.value),
                                            alpha: CGFloat(alphaSlider.value))
    }
    
}
