//
//  MainScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class MainScreen: UIViewController{
    
    @IBOutlet var donateButton: UIBarButtonItem!
    @IBOutlet var transportButton: UIBarButtonItem!
    @IBOutlet weak var buttonScrollView: UIScrollView!
    
    var locationManager = CLLocationManager()
    
    let scrWidth = Int(UIScreen.main.bounds.width)
    var scrHeight = 0.0
    var buttonWidth = 0
    var buttonHeight = 0
    
    var buttons:[UIButton] = []
    let buttonNames:[String] = ["Current Donations","Current Transports","Past Donations","Past Transports","Rewards","Community Hrs"]
    var alreadyEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = self.view.backgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        setWelLab()
        getType()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrHeight = Double(buttonScrollView.bounds.height)
        buttonWidth = scrWidth
        buttonHeight = Int(scrHeight/3.68)
        buttonScrollView.contentSize.height = CGFloat(buttonHeight*buttonNames.count)
        buttonScrollView.isScrollEnabled = true
        if alreadyEntered == false{
            addButtons()
            alreadyEntered = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWelLab(){
        firebaseRef.child("users").child(uid).child("username").observeSingleEvent(of: .value, with: {
            snapshot in
            username = snapshot.value as! String
            let button = UIButton(frame: CGRect(x:0, y:0, width:100, height: 40))
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.setTitle(username, for: .normal)
            button.addTarget(self, action: #selector(MainScreen.goToSettings(_:)),
                             for: UIControlEvents.touchUpInside)
            self.navigationItem.titleView = button
        })
    }
    
    func getType(){
        firebaseRef.child("users").child(uid).child("isDonor").observeSingleEvent(of: .value, with: {
            snapshot in
            isDonor = snapshot.value as! Bool
            if(isDonor == true){
                self.donateButton.isEnabled = true
                self.donateButton.title = "Donate"
                
            }
            else{
                self.donateButton.isEnabled = false
                self.donateButton.title = ""
            }
        })
        firebaseRef.child("users").child(uid).child("isTransporter").observeSingleEvent(of: .value, with: {
            snapshot in
            isTransporter = snapshot.value as! Bool
            if(isTransporter == true){
                self.transportButton.isEnabled = true
                self.transportButton.title = "Transport"
            }
            else{
                self.transportButton.isEnabled = false
                self.transportButton.title = ""
            }
        })
    }
    
    func addButtons(){
        for i in 1...buttonNames.count{
            let button = UIButton(frame: CGRect(x: 0,y: (i-1)*buttonHeight, width: buttonWidth, height: buttonHeight))
            buttons.append(button)
        }
        for b in 1...buttons.count{
            buttons[b-1].titleLabel!.font = buttons[b-1].titleLabel!.font.withSize(20)
            buttons[b-1].contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            buttons[b-1].contentVerticalAlignment = UIControlContentVerticalAlignment.center
            buttons[b-1].setTitleColor(UIColor.white, for: UIControlState())
            buttons[b-1].setTitle(buttonNames[b-1], for: UIControlState())
            buttons[b-1].layer.cornerRadius = 10.0
            buttons[b-1].backgroundColor = UIColor.clear
            buttons[b-1].layer.borderWidth = 2.0
            buttons[b-1].layer.borderColor = getColor(color: "Royal Blue").cgColor
            buttons[b-1].titleLabel?.textColor = UIColor.white
            buttons[b-1].addTarget(self, action: #selector(MainScreen.buttonPressed(_:)),
                                   for: UIControlEvents.touchUpInside)
            buttonScrollView.addSubview(buttons[b-1])
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton){
        
    }
    
    @objc func goToSettings(_ sender:UIButton){
        self.performSegue(withIdentifier: "maintosettingsegue", sender: nil)
    }
    
}
