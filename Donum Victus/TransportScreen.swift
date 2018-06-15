//
//  TransportScreen.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/14/17.
//  Copyright © 2017 Donum Victus. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class TransportScreen: UIViewController{
    
    @IBOutlet weak var donationsView: UIScrollView!
    var placeClient:GMSPlacesClient!
    var currentPlace:GMSPlace!
    var country = ""
    var state = ""
    var city = ""
    var county = ""
    var dateStr = ""
    var donationKeys:[String]! = []
    var donationNames:[String]! = []
    var info:[String]! = []
    var scrWidth = 0
    var scrHeight = 0.0
    var buttonHeight = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Set Food Transport"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        placeClient = GMSPlacesClient()
        getCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        scrWidth = Int(donationsView.bounds.width)
        scrHeight = Double(donationsView.bounds.height)
        buttonHeight = Int(scrHeight/10.68)
        donationsView.isScrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentLocation(){
        placeClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            self.currentPlace = placeLikelihoodList?.likelihoods[0].place
            for components in self.currentPlace.addressComponents!{
                if components.type == "country"{
                    self.country = components.name
                }
                if components.type == "administrative_area_level_1"{
                    self.state = components.name
                }
                if components.type == "locality"{
                    self.city = components.name
                }
                if components.type == "administrative_area_level_2"{
                    self.county = components.name
                }
            }
            self.getDate()
        })
    }
    
    func getDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        dateStr = formatter.string(from: date)
        getInfo()
    }
    
    func getInfo(){
        getKeys()
    }
    
    func getKeys(){
    firebaseRef.child("Donations/"+country+"/"+state+"/"+city+"/"+county+"/"+dateStr).observeSingleEvent(of: .value, with: {
            snapshot in
            if ( snapshot.value is NSNull ) {
                print("Skillet was not found")
            } else {
                for child in snapshot.children {   //in case there are several skillets
                    let key = (child as AnyObject).key as String
                    self.donationKeys.append(key)
                }
            }
            self.getDonationNames()
        })
    }
    
    func getDonationNames(){
        for key in donationKeys{
        firebaseRef.child("Donations/"+country+"/"+state+"/"+city+"/"+county+"/"+dateStr+"/"+key).observeSingleEvent(of: .value, with: {
                snapshot in
                if ( snapshot.value is NSNull ) {
                    print("Skillet was not found")
                } else {
                    for child in snapshot.children {   //in case there are several skillets
                        let name = (child as AnyObject).key as String
                        self.donationNames.append(name)
                        print(name)
                    }
                }
                self.displayDonations()
            })
        }
    }
    
    func displayDonations(){
        for i in 1...donationNames.count{
            let button = UIButton(frame: CGRect(x: 0,y: (i-1)*buttonHeight, width: scrWidth, height: buttonHeight))
            button.titleLabel!.font = button.titleLabel!.font.withSize(20)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.setTitle(donationNames[i-1], for: UIControlState())
            button.addTarget(self, action: #selector(TransportScreen.donationPressed(_:)),
                             for: UIControlEvents.touchUpInside)
            button.layer.cornerRadius = 10.0
            button.backgroundColor = UIColor.clear
            button.layer.borderWidth = 2.0
            button.layer.borderColor = getColor(color: "Royal Blue").cgColor
            donationsView.addSubview(button)
        }
    }
    
    @objc func donationPressed(_ sender: UIButton){
        let buttonName = sender.titleLabel?.text!
        var pos = -1
        for i in 1...donationNames.count{
            if(donationNames[i-1]==buttonName){
                pos = i
            }
        }
        info = [country, state, city, county, dateStr, donationKeys[pos-1], buttonName!]
        self.performSegue(withIdentifier: "TrantoDonInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TrantoDonInfo") {
            let dis = segue.destination as! DonationInformationScreen
            dis.info = info
        }
    }
    
}
