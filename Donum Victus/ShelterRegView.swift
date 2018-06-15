//
//  ShelterRegView.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 5/30/18.
//  Copyright © 2018 Donum Victus. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShelterRegView: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var paswdField: UITextField!
    @IBOutlet var confirmpswdField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
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
    
    @IBAction func register(_ sender: AnyObject) {
        let name = nameField.text!
        let email = emailField.text!
        let website = websiteField.text!
        let address = addressField.text!
        let pswd = paswdField.text!
        let conPswd = confirmpswdField.text!
        if name != "" && email != "" && pswd != "" && conPswd != ""{
            if pswd == conPswd{
                Auth.auth().createUser(withEmail: email, password: pswd) { (user, error) in
                    if error == nil
                    {
                        Auth.auth().signIn(withEmail: email, password: pswd) { (user, error) in
                            if error == nil{
                                let data1 = ["name": name, "website": website, "address": address] as [String : Any]
                                firebaseRef.child("shelters").child((user?.uid)!).updateChildValues(data1)
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
            let alert = UIAlertController(title: "Error", message: "Fill All Fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
