//
//  SettingsScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SettingsScreen: UIViewController{
    
    @IBOutlet var foodDonorButton: UIButton!
    @IBOutlet var foodTransporterButton: UIButton!
    @IBOutlet var sunButton: UIButton!
    @IBOutlet var monButton: UIButton!
    @IBOutlet var tuesButton: UIButton!
    @IBOutlet var wedButton: UIButton!
    @IBOutlet var thursButton: UIButton!
    @IBOutlet var friButton: UIButton!
    @IBOutlet var satButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var daysTransLab: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    var buttons:[UIButton]!
    var selected:[Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationItem.title = "Settings"
        buttons = [foodDonorButton,foodTransporterButton,sunButton,monButton,tuesButton,wedButton,thursButton,friButton,satButton]
        selected = [false,false,false,false,false,false,false,false,false]
        pullInfo()
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
    
    @IBAction func logout(_ sender: Any) {
        username = ""
        email = ""
        pswd = ""
        uid = ""
        let filePath = getDocumentsDirectory().appending("/savedData.txt")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            }
            catch let error as NSError {
                print("Error: "+"\(error)")
            }
        }
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "backToLogInSegue", sender: sender)
    }
    
    @IBAction func selectCheck(_ sender:UIButton){//add code so that if transporter off, days disappear
        for button in buttons{
            if sender == button{
                let index = buttons.index(of: button)!
                if selected[index] == false{
                    sender.setImage(UIImage(named: "lightcheckfilled"), for: .normal)
                    selected[index] = true
                    break
                }
                else{
                    sender.setImage(UIImage(named: "lighcheckunfilled"), for: .normal)
                    selected[index] = false
                    break
                }
            }
        }
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        let data1 = ["isDonor": selected[0], "isTransporter": selected[1]] as [String : Any]
        firebaseRef.child("users").child(uid).updateChildValues(data1)
        let data2 = ["Sun": selected[2], "Mon": selected[3], "Tue": selected[4], "Wed": selected[5]] as [String : Any]
        let data3 = ["Thurs": selected[6], "Fri": selected[7], "Sat": selected[8]] as [String : Any]
        firebaseRef.child("users").child(uid).child("days available").updateChildValues(data2)
        firebaseRef.child("users").child(uid).child("days available").updateChildValues(data3)
        self.performSegue(withIdentifier: "settingtomainseg", sender: nil)
    }
    
    func fillCheck(index: Int, selecter: Bool){
        if selecter == true{
            buttons[index].setImage(UIImage(named: "lightcheckfilled"), for: .normal)
        }
        else{
            buttons[index].setImage(UIImage(named: "lighcheckunfilled"), for: .normal)
        }
    }
    
    func pullInfo(){
        firebaseRef.child("users").child(uid).child("isDonor").observeSingleEvent(of: .value, with: {
            snapshot in
            isDonor = snapshot.value as! Bool
            self.selected[0] = isDonor
            self.fillCheck(index: 0, selecter: self.selected[0])
        })
        firebaseRef.child("users").child(uid).child("isTransporter").observeSingleEvent(of: .value, with: {
            snapshot in
            isTransporter = snapshot.value as! Bool
            self.selected[1] = isTransporter
            self.fillCheck(index: 1, selecter: self.selected[1])
        })
        handleTransportInfo()
    }
    
    func handleTransportInfo(){
        if(isTransporter==true){
            daysTransLab.isHidden = false
            monButton.isHidden = false
            tuesButton.isHidden = false
            wedButton.isHidden = false
            thursButton.isHidden = false
            friButton.isHidden = false
            satButton.isHidden = false
            sunButton.isHidden = false
            sunLabel.isHidden = false
            monLabel.isHidden = false
            tuesLabel.isHidden = false
            wedLabel.isHidden = false
            thursLabel.isHidden = false
            friLabel.isHidden = false
            satLabel.isHidden = false
            pullDayInfo()
        }
        else{
            daysTransLab.isHidden = true
            monButton.isHidden = true
            tuesButton.isHidden = true
            wedButton.isHidden = true
            thursButton.isHidden = true
            friButton.isHidden = true
            satButton.isHidden = true
            sunButton.isHidden = true
            sunLabel.isHidden = true
            monLabel.isHidden = true
            tuesLabel.isHidden = true
            wedLabel.isHidden = true
            thursLabel.isHidden = true
            friLabel.isHidden = true
            satLabel.isHidden = true
        }
    }
    
    func pullDayInfo(){
        firebaseRef.child("users").child(uid).child("days available").child("Sun").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[2] = snapshot.value as! Bool
            self.fillCheck(index: 2, selecter: self.selected[2])
        })
        firebaseRef.child("users").child(uid).child("days available").child("Mon").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[3] = snapshot.value as! Bool
            self.fillCheck(index: 3, selecter: self.selected[3])
        })
        firebaseRef.child("users").child(uid).child("days available").child("Tue").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[4] = snapshot.value as! Bool
            self.fillCheck(index: 4, selecter: self.selected[4])
        })
        firebaseRef.child("users").child(uid).child("days available").child("Wed").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[5] = snapshot.value as! Bool
            self.fillCheck(index: 5, selecter: self.selected[5])
        })
        firebaseRef.child("users").child(uid).child("days available").child("Thurs").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[6] = snapshot.value as! Bool
            self.fillCheck(index: 6, selecter: self.selected[6])
        })
        firebaseRef.child("users").child(uid).child("days available").child("Fri").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[7] = snapshot.value as! Bool
            self.fillCheck(index: 7, selecter: self.selected[7])
        })
        firebaseRef.child("users").child(uid).child("days available").child("Sat").observeSingleEvent(of: .value, with: {
            snapshot in
            self.selected[8] = snapshot.value as! Bool
            self.fillCheck(index: 8, selecter: self.selected[8])
        })
    }
    
}

