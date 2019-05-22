//
//  ApplicationExtensions.swift
//  KomootChallenge
//
//  Created by Tornike Gomareli on 5/8/19.
//  Copyright © 2019 Tornike Gomareli. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func parse<D>(to type: D.Type) -> D? where D: Decodable {
        
        let data: Data = self.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        do {
            let _object = try decoder.decode(type, from: data)
            return _object
            
        } catch {
            return nil
        }
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadAndSetImageAsync(from url: URL) {
        self.image = nil
        
        if (imageCache.object(forKey: url as AnyObject) as? UIImage) != nil
        {
            self.image = imageCache.object(forKey: url as AnyObject) as? UIImage
            return
        }
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            DispatchQueue.main.async() {
                let imageToCache = UIImage(data: data)
                
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                
                self.image = imageToCache
            }
        }
    }
}
