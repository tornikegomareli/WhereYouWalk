//
//  StreamsViewController.swift
//  KomootChallenge
//
//  Created by Tornike Gomareli on 5/9/19.
//  Copyright © 2019 Tornike Gomareli. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StreamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   
    var photoCollection:PhotoCollection?
    var mainSourceOfUrls = [String]()
    var locationManager:CLLocationManager?
    var latestLocation:CLLocation?
    var timeScheduler:Timer?
    var isStopedStreaming:Bool? = false
    
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photosCountLabel: UILabel!
    
    
    @IBAction func onStopButton(_ sender: UIButton) {
        if(!isStopedStreaming!){
            stopTimer()
            isStopedStreaming = true
            
        }else{
            startTimer()
            isStopedStreaming = false
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       stopTimer()
    }
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
          initTableViewSettings()
          locationManager = configureLocationManager()
          locationManager!.startUpdatingLocation()
        
          UserDefaults.standard.set(Date(), forKey:"creationTime")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var firstTimeLocation: CLLocation!
        firstTimeLocation = locationManager?.location
        latestLocation = firstTimeLocation
        
        getLatestDataAndUpdateDataSource(currentUserLocation: firstTimeLocation)
        
        // on every five second, I'm checking the distance of the user, if the distance is more then or equal of 100 meters, we are requesting flickr for new pictures.
        startTimer()
    }
    
    fileprivate func startTimer(){
         controlButton.setTitle("Stop", for: .normal)
          timeScheduler = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkDistance), userInfo: nil, repeats: true)
    }
    
    fileprivate func stopTimer(){
        controlButton.setTitle("Start", for: .normal)
        timeScheduler?.invalidate()
        timeScheduler = nil
    }
    
    fileprivate func initTableViewSettings() {
        tableView.separatorStyle = .none
    }
    
    fileprivate func getLatestDataAndUpdateDataSource(currentUserLocation:CLLocation) {
        let imageUrl = callFlickrImageServiceAndGetUrl(userLocation: currentUserLocation)
        UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.mainSourceOfUrls.insert(imageUrl, at: 0)
            // Better than reload the whole tableview
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.tableView.endUpdates()
        }, completion: nil)
        
        photosCountLabel.text = String(mainSourceOfUrls.count)
    }
    
    fileprivate func callFlickrImageServiceAndGetUrl(userLocation:CLLocation) -> String {
        let flickrService = GetFlickrDataService()
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        
        photoCollection = flickrService.getFlickrData(_lat: lat, _lon:lon)
        let randomIndex = Int.random(in: 0..<250)
        guard let
            firstPhotoFromFlickr =
            photoCollection?.photos.photo[randomIndex]
            else { return " "}
        
        return generateFlickImageUrl(_singlePhoto: firstPhotoFromFlickr)
    }
    
    @objc fileprivate func checkDistance() {
        
        // if user is walking more then 1 hour, we are stoping the tracking.
        if let date = UserDefaults.standard.object(forKey: "creationTime") as? Date {
            if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 1 {
                stopTimer()
            }
        }
        
        let currentUserLocation = (locationManager?.location)!
        
        let distanceMeters = latestLocation!.distance(from: currentUserLocation)
      
        if(distanceMeters >= 100){
            getLatestDataAndUpdateDataSource(currentUserLocation: currentUserLocation)
            latestLocation = currentUserLocation
        }
    }
    
    private func generateFlickImageUrl(_singlePhoto:Photo) -> String {
        let imageUrlid = "https://farm\(_singlePhoto.farm).staticflickr.com/\(_singlePhoto.server)/\(_singlePhoto.id)_\(_singlePhoto.secret).jpg"
        
        return imageUrlid
    }
    
    private func configureLocationManager() -> CLLocationManager {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
    
        return locManager
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainSourceOfUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "streamCell") as! StreamsTableViewCell
        
        let currentImageUrl = mainSourceOfUrls[indexPath.row];
        
        cell.initTableViewCellData(_imageUrl: currentImageUrl)
        
        return cell
    }
}
