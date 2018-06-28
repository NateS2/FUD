//
//  FavoriteRestaurantsTableViewController.swift
//  FÜD
//
//  Created by Nathan  on 4/30/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteRestaurantsViewController: UIViewController {
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var restaurantTableView: UITableView!
    var places = [RealmPlace]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTableView.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let place = realm.objects(RealmPlace.self)
        places = Array(place)
        
    }

}
extension FavoriteRestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        
        cell.textLabel?.text = places[indexPath.row].name
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = places[indexPath.row].address
        cell.detailTextLabel?.textColor = .white
        if let imageData = places[indexPath.row].imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        
        return cell
    }
}
extension FavoriteRestaurantsViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
}
