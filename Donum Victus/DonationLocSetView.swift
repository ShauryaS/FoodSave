//
//  DonationLocSetView.swift
//  Donum Victus
//
//  Created by Shaurya Srivastava on 1/2/18.
//  Copyright © 2018 Donum Victus. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import MapKit
import CoreLocation

class DonationLocSetView: UIViewController{
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var currentLoc: CLLocation!
    var place:String!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var texts:[String] = []
    
    var location = ""
    var placeInfo:GMSPlace!
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    let kMapStyle = "[" +
        "  {" +
        "    \"featureType\": \"all\"," +
        "    \"elementType\": \"geometry\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#242f3e\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"all\"," +
        "    \"elementType\": \"labels.text.stroke\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"lightness\": -80" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"administrative\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#746855\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"administrative.locality\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#d59563\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"poi\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#d59563\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"poi.park\"," +
        "    \"elementType\": \"geometry\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#263c3f\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"poi.park\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#6b9a76\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road\"," +
        "    \"elementType\": \"geometry.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#2b3544\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#9ca5b3\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.arterial\"," +
        "    \"elementType\": \"geometry.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#38414e\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.arterial\"," +
        "    \"elementType\": \"geometry.stroke\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#212a37\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.highway\"," +
        "    \"elementType\": \"geometry.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#746855\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.highway\"," +
        "    \"elementType\": \"geometry.stroke\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#1f2835\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.highway\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#f3d19c\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.local\"," +
        "    \"elementType\": \"geometry.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#38414e\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"road.local\"," +
        "    \"elementType\": \"geometry.stroke\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#212a37\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"transit\"," +
        "    \"elementType\": \"geometry\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#2f3948\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"transit.station\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#d59563\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"water\"," +
        "    \"elementType\": \"geometry\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#17263c\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"water\"," +
        "    \"elementType\": \"labels.text.fill\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"color\": \"#515c6d\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"water\"," +
        "    \"elementType\": \"labels.text.stroke\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"lightness\": -20" +
        "      }" +
        "    ]" +
        "  }" +
    "]"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        placesClient = GMSPlacesClient.shared()
        setLocManager()
        addMap()
        setSearchStuff()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    func setLocManager(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    func addMap(){
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        do {
            // Set the map style by passing a valid JSON string.
            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    
    func setSearchStuff(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        resultsViewController?.tableCellBackgroundColor = backgroundColor
        resultsViewController?.primaryTextColor = UIColor.lightGray
        resultsViewController?.secondaryTextColor = UIColor.lightGray
        resultsViewController?.primaryTextHighlightColor = UIColor.white
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DonLoctoDonScr") {
            let ds = segue.destination as! DonateScreen
            texts[5] = location
            ds.texts = texts
            ds.places = placeInfo
        }
    }
    
}

extension DonationLocSetView: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension DonationLocSetView: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        location = place.name
        placeInfo = place
        self.performSegue(withIdentifier: "DonLoctoDonScr", sender: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
