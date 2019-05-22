//
//  ViewController.swift
//  KomootChallenge
//
//  Created by Tornike Gomareli on 5/7/19.
//  Copyright © 2019 Tornike Gomareli. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController {
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        print(photoCollection)
    }
    var photoCollection:PhotoCollection?
    
    func functionHandler(_data:PhotoCollection){
        photoCollection = _data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        
        var currentLocation: CLLocation!

        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
          
        }
        
        currentLocation = locManager.location
        locManager.startUpdatingLocation()
        
        
        let flickrService = GetFlickrDataService()
        
        flickrService.getFlickrData(_lat: 41.7331625, _lon:44.7051501, completionHandler: functionHandler)
        
        
    }
}

