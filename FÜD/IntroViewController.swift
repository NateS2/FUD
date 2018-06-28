//
//  ViewController.swift
//  FÜD
//
//  Created by Nathan  on 3/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
// https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates

import UIKit
import CoreLocation
import MapKit

class IntroViewController: BaseViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pickRestaurantButton: UIButton!
    @IBAction func pickRestaurantButton(_ sender: Any) {
        if network.reachability.connection != .none {
            performSegue(withIdentifier: "foodPickerSegue", sender: nil)
        } else {
            displayAlert()
        }
        
    }
    
    let locationManager = CLLocationManager()
    
    
    
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        backgroundImageView.image = UIImage(named: "backgroundImage")
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        pickRestaurantButton.setTitle("Pick Restaurant", for: .normal)
        pickRestaurantButton.setTitleColor(.white, for: .normal)
        pickRestaurantButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .light)
        pickRestaurantButton.backgroundColor = .clear
        pickRestaurantButton.layer.cornerRadius = 23
        pickRestaurantButton.layer.borderWidth = 3
        pickRestaurantButton.layer.borderColor = UIColor.white.cgColor
        addLayoutConstraints()
    }
    
    func addLayoutConstraints() {
        pickRestaurantButton.translatesAutoresizingMaskIntoConstraints = false
        pickRestaurantButton.widthAnchor.constraint(equalToConstant: 252).isActive = true
        pickRestaurantButton.heightAnchor.constraint(equalToConstant: 73).isActive = true
        pickRestaurantButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pickRestaurantButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let foodPickerVC = segue.destination as? FoodPickerViewController {
            foodPickerVC.currentLocation = currentLocation
        }
    }
    
}



extension IntroViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
}

