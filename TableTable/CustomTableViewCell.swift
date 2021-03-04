//
//  CustomTableViewCell.swift
//  TableTable
//
//  Created by Surfa on 02.02.2021.
//

import UIKit
import Cosmos


class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height/2
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        } 
    }
    
}
