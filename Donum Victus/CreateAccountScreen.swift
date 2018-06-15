//
//  CreateAccountScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateAccountScreen: UIViewController{
    
    @IBOutlet var titleLab: UILabel!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var paswdField: UITextField!
    @IBOutlet var confirmpswdField: UITextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var foodDonorButton: UIButton!
    @IBOutlet var foodTransporterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    @IBAction func create(_ sender: AnyObject) {
        let username = usernameField.text!
        let email = emailField.text!
        let pswd = paswdField.text!
        let conPswd = confirmpswdField.text!
        var isDonor = false
        var isTransporter = false
        if(foodDonorButton.isSelected){
            isDonor = true
        }
        if(foodTransporterButton.isSelected){
            isTransporter = true
        }
        if username != "" && email != "" && pswd != "" && conPswd != ""{
            if pswd == conPswd{
                Auth.auth().createUser(withEmail: email, password: pswd) { (user, error) in
                    if error == nil
                    {
                        Auth.auth().signIn(withEmail: email, password: pswd) { (user, error) in
                            if error == nil{
                                let data1 = ["username": username, "isDonor": isDonor, "isTransporter": isTransporter] as [String : Any]
                                firebaseRef.child("users").child((user?.uid)!).updateChildValues(data1)
                                let data2 = ["Sun": false, "Mon": false, "Tue": false, "Wed": false, "Thurs": false, "Fri": false, "Sat": false] as [String : Any]
                                firebaseRef.child("users").child((user?.uid)!).child("days available").updateChildValues(data2)
                                self.performSegue(withIdentifier: "createtologseg", sender: nil)
                            }
                            else{
                                print(error!)
                            }
                        }
                    }
                    else
                    {
                        print(error!)
                    }
                    
                }
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Make sure passwords match.", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Enter All Credentials.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func typeSelected(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            sender.setImage(UIImage(named: "lightcheckfilled"), for: .normal)
        }
        if sender.isSelected == false{
            sender.setImage(UIImage(named: "lighcheckunfilled"), for: .normal)
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        usernameField.text = ""
        emailField.text = ""
        paswdField.text = ""
        confirmpswdField.text = ""
        self.performSegue(withIdentifier: "createtologseg", sender: nil)
    }
    
}
