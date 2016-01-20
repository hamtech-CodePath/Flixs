//
//  MovieCollectionViewCell.swift
//  Flixs
//
//  Created by Hugh A. Miles II on 1/8/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit
import IBAnimatable

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Image: AnimatableImageView!
    @IBOutlet weak var Popularity: UILabel!
    @IBOutlet weak var Vote: UILabel!
    @IBOutlet weak var heart: AnimatableImageView!
    
    @IBOutlet weak var graph: AnimatableImageView!
}
