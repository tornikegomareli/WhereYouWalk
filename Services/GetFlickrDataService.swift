//
//  GetFlickrDataService.swift
//  KomootChallenge
//
//  Created by Tornike Gomareli on 5/8/19.
//  Copyright © 2019 Tornike Gomareli. All rights reserved.
//

import Foundation


class GetFlickrDataService {
    var modelJson: String
    let url : String
    let apiKey : String
    let content_type:String
    let format: String
    let jsonCallBackParameter: String
    
    public init(){
        url =  "https://api.flickr.com/services/rest/?&method=flickr.photos.search"
        apiKey = "&api_key=bb490d47c47a2fc5d1338f1c281dd1c0"
        content_type = "&content_type=6"
        format = "&format=json"
        jsonCallBackParameter = "&nojsoncallback=1"
        modelJson = ""
    }
    

    func getFlickrData( _lat:Double, _lon:Double) -> PhotoCollection
    {
        var photoCollectionData: PhotoCollection?
        let requestUrl = url + apiKey + format
            + content_type + jsonCallBackParameter
        
        let requestUrlWithLatLon = requestUrl + "&lat=\(_lat)"
            + "&lon=\(_lon)";
        
        
        let flickrApiUrl = URL(string: requestUrlWithLatLon)
        
       
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: flickrApiUrl!, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let photoCollections = try
                    JSONDecoder().decode(PhotoCollection.self, from : data)
                
                photoCollectionData = photoCollections
                
                semaphore.signal()
                
            } catch let error {
                print(error.localizedDescription)
            }
         }
        ).resume()
        
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return photoCollectionData!
    }
}
