//
//  LoginScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class LoginScreen: UIViewController{
    
    @IBOutlet var titleLab: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var useremailField: UITextField!
    @IBOutlet var pswdField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    var selected:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sharedApp = UIApplication.shared
        sharedApp.delegate?.window??.tintColor = getColor(color: "Royal Blue")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
        readAuthFile()
        if username != "" && pswd != ""{
            login(useremail: username, pswd: pswd)
        }
        showMainStuff = false
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        //self.view.backgroundColor = UIColor.init(displayP3Red: 20.0/255.0, green: 26.0/255.0, blue: 36.0/255.0, alpha: 1.0)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readAuthFile()
    }

    @IBAction func logIn(_ sender: AnyObject) {
        let useremail = useremailField.text!
        let pswd = pswdField.text!
        login(useremail: useremail, pswd: pswd)
    }
    
    @IBAction func remembermeTriggered(_ sender: AnyObject) {
        selected = !selected
        if selected == true{
            rememberMeButton.setImage(UIImage(named: "lightcheckfilled"), for: .normal)
            remembered = true
        }
        else{
            rememberMeButton.setImage(UIImage(named: "lighcheckunfilled"), for: .normal)
            remembered = false
        }
    }
    
    func login(useremail:String, pswd:String){
        if useremail != "" && pswd != ""{
            Auth.auth().signIn(withEmail: useremail, password: pswd) { (user, error) in
                if error == nil{
                    if remembered != nil && remembered == true{
                        self.saveAuth(username: useremail, password: pswd)
                    }
                    uid = (user?.uid)!
                    self.performSegue(withIdentifier: "logtomainseg", sender: nil)
                }
                else{
                    let alert = UIAlertController(title: "Error", message: "Sign In Failed.", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Enter All Credentials.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func readAuthFile(){
        let filePath = getDocumentsDirectory().appending("/savedData.txt")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            var savedContents = ""
            do {
                savedContents = try NSString(contentsOf: URL(fileURLWithPath: filePath), encoding: String.Encoding.utf8.rawValue) as String
                let contents = savedContents.characters.split(separator: " ").map(String.init)
                username = contents[0]
                pswd = contents[1]
            }
            catch {
                print("Error: "+"\(error)")
            }
        }
    }
    
    func saveAuth(username: String, password: String){
        if remembered == true{
            let filePath = getDocumentsDirectory().appending("/savedData.txt")
            let fileurl = URL(fileURLWithPath: filePath)
            let savedString = username+" "+password
            do{
                try savedString.write(to: fileurl, atomically: false, encoding: String.Encoding.utf8)
            }
            catch{
                print("Error: "+"\(error)")
            }
        }
    }


}
