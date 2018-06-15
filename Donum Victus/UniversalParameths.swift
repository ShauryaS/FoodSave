//
//  UniversalParameths.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var username = ""
var email = ""
var pswd = ""
var uid = ""
var phoneNumber = ""
var remembered:Bool! = false
var isDonor:Bool!
var isTransporter:Bool!
let firebaseRef = Database.database().reference()
var showMainStuff = false
var backgroundColor:UIColor!

func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory as NSString
}

func getColor(color:String) -> UIColor{
    switch(color){
    case "Red":
        return UIColor.red
    case "Orange":
        return UIColor.orange
    case "Yellow":
        return UIColor.yellow
    case "Green":
        return UIColor.green
    case "Blue":
        return UIColor.blue
    case "Purple":
        return UIColor.purple
    case "Brown":
        return UIColor.brown
    case "Gray":
        return UIColor.gray
    case "Indigo":
        return UIColor.init(displayP3Red: 75.0/255.0, green: 0.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    case "Violet":
        return UIColor.init(displayP3Red: 238.0/255.0, green: 130.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    case "Black":
        return UIColor.black
    case "Cyan":
        return UIColor.cyan
    case "Royal Blue":
        return UIColor.init(displayP3Red: 65.0/255.0, green: 105.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    case "Navy Blue":
        return UIColor.init(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    case "Magenta":
        return UIColor.magenta
    case "Peach":
        return UIColor.init(displayP3Red: 255.0/255.0, green: 218.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    case "Tan":
        return UIColor.init(displayP3Red: 210.0/255.0, green: 180.0/255.0, blue: 140.0/255.0, alpha: 1.0)
    case "Turquoise":
        return UIColor.init(displayP3Red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)
    default:
        return UIColor.white
    }
}

