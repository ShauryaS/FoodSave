//
//  DonateScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GooglePlaces

class DonateScreen: UIViewController, UITextViewDelegate{
    
    //make textfields text views and follow steps online
    var foodNameTF: UITextView!
    var foodDescriptionTF: UITextView!
    var foodIngredientsTF: UITextView!
    var foodContainmentTypeTF: UITextView!
    var foodQuantityTF:UITextView!
    var setLocationButton: UIButton!
    
    var texts:[String] = []
    
    var scrWidth = 0
    var scrHeight = 0
    
    var places:GMSPlace!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DonateScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationItem.title = "Set Food Donation"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(texts.count>0 && texts[5] != "Set Location Pick-Up"){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addDonation(_:)))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        scrWidth = Int(UIScreen.main.bounds.width)
        scrHeight = Int(UIScreen.main.bounds.height)-Int((self.navigationController?.navigationBar.bounds.height)!)-10
        setView()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView(){//-50
        foodNameTF = UITextView(frame: CGRect(x: 0, y: Int((self.navigationController?.navigationBar.bounds.height)!)+20, width: scrWidth, height: (scrHeight-70)/10))
        specifyTFs(textView: foodNameTF)
        self.view.addSubview(foodNameTF)
        foodDescriptionTF = UITextView(frame: CGRect(x: 0, y: Int((self.navigationController?.navigationBar.bounds.height)!)+30+(scrHeight-70)/10, width: scrWidth, height: (scrHeight-70)*3/10))
        specifyTFs(textView: foodDescriptionTF)
        self.view.addSubview(foodDescriptionTF)
        foodIngredientsTF = UITextView(frame: CGRect(x: 0, y: Int((self.navigationController?.navigationBar.bounds.height)!)+40+(scrHeight-70)*4/10, width: scrWidth, height: (scrHeight-70)*3/10))
        specifyTFs(textView: foodIngredientsTF)
        self.view.addSubview(foodIngredientsTF)
        foodQuantityTF = UITextView(frame: CGRect(x: 0, y: Int((self.navigationController?.navigationBar.bounds.height)!)+50+(scrHeight-70)*7/10, width: scrWidth, height: (scrHeight-70)/10))
        specifyTFs(textView: foodQuantityTF)
        self.view.addSubview(foodQuantityTF)
        foodContainmentTypeTF = UITextView(frame: CGRect(x: 0, y: Int((self.navigationController?.navigationBar.bounds.height)!)+60+(scrHeight-70)*8/10, width: scrWidth, height: (scrHeight-70)/10))
        specifyTFs(textView: foodContainmentTypeTF)
        self.view.addSubview(foodContainmentTypeTF)
        setLocationButton = UIButton(frame: CGRect(x: 0,y: Int((self.navigationController?.navigationBar.bounds.height)!)+70+(scrHeight-70)*9/10, width: scrWidth, height: (scrHeight-70)/10))
        specifyButtons(button: setLocationButton)
        self.view.addSubview(setLocationButton)
    }
    
    func specifyTFs(textView: UITextView){
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 2.0
        textView.isEditable = true
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.backgroundColor = UIColor.clear
        var str = ""
        if(texts.count>0){
            str = getTextViewText(textView: textView)
        }
        if(str != "" && str != getPlaceholder(textView: textView)){
            textView.textColor = UIColor.white
            textView.text = str
        }
        else{
            textView.textColor = UIColor.lightGray
            textView.text = getPlaceholder(textView: textView)
        }
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.keyboardAppearance = UIKeyboardAppearance.dark
        textView.delegate = self
    }
    
    func specifyButtons(button: UIButton){
        button.layer.cornerRadius = 10.0
        button.titleLabel!.font = button.titleLabel!.font.withSize(15)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.clear
        var str = ""
        if(texts.count>0){
            str = getButtonText()
        }
        if(str != "" && str != "Set Location Pick-Up"){
            button.layer.borderColor = UIColor.black.cgColor
            button.isEnabled = false
            button.setTitle(str, for: UIControlState())
        }
        else{
            button.layer.borderColor = getColor(color: "Royal Blue").cgColor
            button.isEnabled = true
            button.setTitle("Set Location Pick-Up", for: UIControlState())
        }
        button.layer.borderWidth = 2.0
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(DonateScreen.buttonPressed(_:)),
                               for: UIControlEvents.touchUpInside)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = getPlaceholder(textView: textView)
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton){
         texts = [foodNameTF.text!, foodDescriptionTF.text!, foodIngredientsTF.text!, foodQuantityTF.text!, foodContainmentTypeTF.text!, (setLocationButton.titleLabel?.text!)!]
        self.performSegue(withIdentifier: "DonateToLocSelect", sender: nil)
    }
    
    func getPlaceholder(textView: UITextView)->String{
        switch(textView){
            case foodNameTF:
                return "Food Name (i.e. Sandwiches, Pasta, Soup, etc.)"
            case foodDescriptionTF:
                return "Description of Food (i.e. Shell pasta sauce with tomato sauce, etc.)"
            case foodIngredientsTF:
                return "Ingredients of Food (i.e. Eggs, Nuts, Milk, etc.)"
            case foodQuantityTF:
                return "Amount of Food (i.e. 10 Sandwiches)"
            case foodContainmentTypeTF:
                return "Type of Food Containment (e.g. Boxes, Bags, Aluminum Foil, etc.)"
            default:
                return ""
        }
    }
    
    func getField(textView: UITextView)->UITextView{
        switch(textView){
            case foodNameTF:
                return foodNameTF
            case foodDescriptionTF:
                return foodDescriptionTF
            case foodIngredientsTF:
                return foodIngredientsTF
            case foodQuantityTF:
                return foodQuantityTF
            case foodContainmentTypeTF:
                return foodContainmentTypeTF
            default:
                return textView
        }
    }
    
    func getTextViewText(textView: UITextView)->String{
        switch(textView){
            case foodNameTF:
                return texts[0]
            case foodDescriptionTF:
                return texts[1]
            case foodIngredientsTF:
                return texts[2]
            case foodQuantityTF:
                return texts[3]
            case foodContainmentTypeTF:
                return texts[4]
            default:
                return ""
        }
    }
    
    func getButtonText()->String{
        return texts[5]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DonateToLocSelect") {
            let dlsw = segue.destination as! DonationLocSetView
            dlsw.texts = texts
            print(texts)
        }
    }
    
    @objc func addDonation(_ sender: Any) {
        let food = foodNameTF.text!
        let description = foodDescriptionTF.text!
        let ingredients = foodIngredientsTF.text!
        let quantity = foodQuantityTF.text!
        let containment = foodContainmentTypeTF.text!
        let location = (setLocationButton.titleLabel?.text!)!
        var country = ""
        var state = ""
        var city = ""
        var county = ""
        for components in places.addressComponents!{
            if components.type == "country"{
                country = components.name
            }
            if components.type == "administrative_area_level_1"{
                state = components.name
            }
            if components.type == "locality"{
                city = components.name
            }
            if components.type == "administrative_area_level_2"{
                county = components.name
            }
        }
        let data = ["food": food, "description": description, "ingredients": ingredients, "quantity": quantity, "containment": containment, "location": location + ", " + city + ", " + state  + ", " + country, "Donor": username]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateStr = formatter.string(from: date)
        var ref = firebaseRef.child("Donations")
        if(country.count>0){
            ref = ref.child(country)
        }
        if(state.count>0){
            ref = ref.child(state)
        }
        if(city.count>0){
            ref = ref.child(city)
        }
        if(county.count>0){
            ref = ref.child(county)
        }
        
        ref = ref.child(dateStr).child(uid).child(username+"'s "+food+" donation")
        ref.updateChildValues(data)
        self.performSegue(withIdentifier: "DonToMainSeg", sender: nil)
    }
}
