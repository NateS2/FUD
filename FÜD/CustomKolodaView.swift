//
//  CustomKolodaView.swift
//  FÜD
//
//  Created by Nathan  on 3/22/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import Foundation
import UIKit
import Koloda
import Cosmos

class CustomKolodaView: KolodaView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var kolodaImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var priceRatingLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomKolodaView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 8
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        kolodaImageView.contentMode = .scaleAspectFill
        kolodaImageView.clipsToBounds = true
        kolodaImageView.layer.cornerRadius = 8
        kolodaImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
}
