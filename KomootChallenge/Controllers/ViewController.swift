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
       
        let streamViewController = self.storyboard!.instantiateViewController(withIdentifier: "streamViewControllerId") as! StreamsViewController
        
        self.navigationController!.pushViewController(streamViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}

