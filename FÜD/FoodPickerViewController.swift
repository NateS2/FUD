//
//  FoodPickerViewController.swift
//  FÜD
//
//  Created by Nathan  on 3/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit
import Koloda
import CoreLocation
import MapKit
import RealmSwift


class FoodPickerViewController: BaseViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var heartButton: UIButton!
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var googleClient: GoogleClientRequest = GoogleClient()
    var currentLocation: CLLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    var locationName : String = "restaurants"
    var searchRadius : Float = 10000
    
    var placeObjects = [PlaceData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRadius = UserDefaults.standard.float(forKey: "slider_value")
        
        LoadingOverlay.shared.showOverlay(view: self.view)
        // Do any additional setup after loading the view.
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.layer.cornerRadius = 8
        kolodaView.countOfVisibleCards = 2
        print("called")
        NetworkManager.isReachable { _ in
            self.fetchGoogleData(forLocation: self.currentLocation, locationName: self.locationName, searchRadius: self.searchRadius )
        }
        NetworkManager.isUnreachable { _ in
            
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        let origImage = UIImage(named: "heart")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        heartButton.setImage(tintedImage, for: .normal)
        heartButton.tintColor = .white
    }
}

extension FoodPickerViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        koloda.reloadData()
        koloda.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // https://stackoverflow.com/questions/36217710/how-to-launch-maps-app-and-start-navigation
        let coordinates = CLLocationCoordinate2DMake(placeObjects[index].place.geometry.location.latitude, placeObjects[index].place.geometry.location.longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        mapitem.name = placeObjects[index].place.name
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapitem.openInMaps(launchOptions: options)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let favRestaurant = RealmPlace()
            favRestaurant.latitude = placeObjects[index].place.geometry.location.latitude
            favRestaurant.longitude = placeObjects[index].place.geometry.location.longitude
            favRestaurant.address = placeObjects[index].place.address
            favRestaurant.name = placeObjects[index].place.name
            if let image = placeObjects[index].image {
                favRestaurant.imageData = UIImagePNGRepresentation(image)
            }
            let realm = try! Realm()
            try! realm.write {
                realm.add(favRestaurant)
            }
        }
    }
}

extension FoodPickerViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return placeObjects.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = CustomKolodaView()
        view.kolodaImageView.image = placeObjects[index].image
        view.restaurantNameLabel.text = placeObjects[index].place.name
        if let priceRating = placeObjects[index].place.priceLevel {
            view.priceRatingLabel.text = returnDollarSign(priceRating: priceRating)
        }
        if let storeRating = placeObjects[index].place.rating {
            view.starRating.rating = storeRating
        }
        return view
    }
}
extension FoodPickerViewController {
    func fetchGoogleData(forLocation: CLLocation, locationName: String, searchRadius: Float) {
        print("called")
        googleClient.getGooglePlacesData(keyword: locationName, location: currentLocation, radius: searchRadius, success: { (response) in
            self.downloadImages(places: response.results.shuffled(), completionHandler: {
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                }
            })
        }) { (error) in
            if error != nil {
                print(error)
            }
            self.displayAlert()
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    func returnDollarSign(priceRating: Int) -> String {
        switch priceRating {
            case 0:
                return "free"
            case 1:
                return "$"
            case 2:
                return "$$"
            case 3:
                return "$$$"
            case 4:
                return "$$$$"
            default:
                print("unexpected input")
                return "fail"
            
        }
    }
    
    func downloadImages(places: [Place], completionHandler: @escaping () -> ()) {
        for place in places {
            var newPlace = PlaceData(place: place, image: nil)
            if let photoLink = place.photos {
                googleClient.getPhotoData(photoReference: photoLink[0].photoReference, maxWidth: "400", using: { (data) in
                    newPlace.image = (UIImage(data: data)!)
                    self.placeObjects.append(newPlace)
                    print("done")
                    DispatchQueue.main.async {
                        self.kolodaView.resetCurrentCardIndex()
                        completionHandler()
                    }
                })
            } else {
                newPlace.image = UIImage(named: "placeholderImage")
                self.placeObjects.append(newPlace)
            }
           
        }
    }
}



