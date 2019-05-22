//
//  StreamsTableViewCell.swift
//  KomootChallenge
//
//  Created by Tornike Gomareli on 5/9/19.
//  Copyright © 2019 Tornike Gomareli. All rights reserved.
//

import UIKit

class StreamsTableViewCell: UITableViewCell {
    @IBOutlet weak var currentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    public func initTableViewCellData(_imageUrl:String){
        let url = URL(string: _imageUrl)
       
        currentImageView.downloadAndSetImageAsync(from: url!)
    }
}


