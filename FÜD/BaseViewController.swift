//
//  BaseViewController.swift
//  FÜD
//
//  Created by Nathan  on 4/27/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let network: NetworkManager = NetworkManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays Alert View when connection fails
        network.reachability.whenUnreachable = { _ in
            self.displayAlert()
        }
    }
    
    func displayAlert() {
        let alert = UIAlertController(title: "Oops", message: "You are currently offline, please check your network availability and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
