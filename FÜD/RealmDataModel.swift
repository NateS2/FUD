//
//  RealmDataModel.swift
//  FÜD
//
//  Created by Nathan  on 4/29/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import Foundation
import RealmSwift

class RealmPlace: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var name = ""
    let price = RealmOptional<Int>()
    let rating = RealmOptional<Double>()
    @objc dynamic var address = ""
    @objc dynamic var imageData: Data? = nil
}
