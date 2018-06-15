//
//  DonationInformationScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MapKit
import CoreLocation

class DonationInformationScreen: UIViewController, CLLocationManagerDelegate{
    
    var foodNameTF: UITextView!
    var foodDescriptionTF: UITextView!
    var foodIngredientsTF: UITextView!
    var foodContainmentTypeTF: UITextView!
    var foodQuantityTF:UITextView!
    var setLocationButton: UIButton!
    
    var scrWidth = 0
    var scrHeight = 0
    
    var info:[String]! = []
    
    var donor = ""
    var food = ""
    var descr = ""
    var ingredients = ""
    var containment = ""
    var location = ""
    var quantity = ""
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Donation Details"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        scrWidth = Int(mainView.bounds.width)
        scrHeight = Int(mainView.bounds.height)
        setView()
        getInfo()
    }
    
    func setView(){//-50
        foodNameTF = UITextView(frame: CGRect(x: 0, y: 10, width: scrWidth, height: (scrHeight-70)/10))
        specifyTFs(textView: foodNameTF)
        mainView.addSubview(foodNameTF)
        foodDescriptionTF = UITextView(frame: CGRect(x: 0, y: 20+(scrHeight-70)/10, width: scrWidth, height: (scrHeight-70)*3/10))
        specifyTFs(textView: foodDescriptionTF)
        mainView.addSubview(foodDescriptionTF)
        foodIngredientsTF = UITextView(frame: CGRect(x: 0, y: 30+(scrHeight-70)*4/10, width: scrWidth, height: (scrHeight-70)*3/10))
        specifyTFs(textView: foodIngredientsTF)
        mainView.addSubview(foodIngredientsTF)
        foodQuantityTF = UITextView(frame: CGRect(x: 0, y: 40+(scrHeight-70)*7/10, width: scrWidth, height: (scrHeight-70)/10))
        specifyTFs(textView: foodQuantityTF)
        mainView.addSubview(foodQuantityTF)
        foodContainmentTypeTF = UITextView(frame: CGRect(x: 0, y: 50+(scrHeight-70)*8/10, width: scrWidth, height: (scrHeight-70)/10))
        specifyTFs(textView: foodContainmentTypeTF)
        mainView.addSubview(foodContainmentTypeTF)
        setLocationButton = UIButton(frame: CGRect(x: 0,y: 60+(scrHeight-70)*9/10, width: scrWidth, height: (scrHeight-70)/10))
        specifyButtons(button: setLocationButton)
        mainView.addSubview(setLocationButton)
    }
    
    func specifyTFs(textView: UITextView){
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 2.0
        textView.textColor = UIColor.white
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.backgroundColor = UIColor.clear
    }
    
    func specifyButtons(button: UIButton){
        button.layer.cornerRadius = 10.0
        button.titleLabel!.font = button.titleLabel!.font.withSize(15)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = getColor(color: "Royal Blue").cgColor
        button.isEnabled = true
        button.layer.borderWidth = 2.0
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(DonationInformationScreen.locationPressed(_:)),
                         for: UIControlEvents.touchUpInside)
    }
    
    func getInfo(){
    firebaseRef.child("Donations/"+info[0]+"/"+info[1]+"/"+info[2]+"/"+info[3]+"/"+info[4]+"/"+info[5]+"/"+info[6]).observeSingleEvent(of: .value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            self.donor = value?["Donor"] as? String ?? ""
            self.food = value?["food"] as? String ?? ""
            self.descr = value?["description"] as? String ?? ""
            self.containment = value?["containment"] as? String ?? ""
            self.ingredients = value?["ingredients"] as? String ?? ""
            self.location = value?["location"] as? String ?? ""
            self.quantity = value?["quantity"] as? String ?? ""
            self.fillInfo()
        })
    }
    
    func fillInfo(){
        foodNameTF.text = food
        foodDescriptionTF.text = descr
        foodIngredientsTF.text = ingredients
        foodContainmentTypeTF.text = containment
        foodQuantityTF.text = quantity
        setLocationButton.setTitle(location, for: UIControlState())
    }
    
    @objc func locationPressed(_ sender:UIButton){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
