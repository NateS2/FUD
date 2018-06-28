//
//  SettingsViewController.swift
//  FÜD
//
//  Created by Nathan  on 3/24/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func dismissButton(_ sender: Any) {
        UserDefaults.standard.set(rangeSlider.value, forKey: "slider_value")
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBAction func valueChanged(_ sender: Any) {
        rangeLabel.text = "\(((rangeSlider.value * milesPerMeter)*10).rounded() / 10) miles"

    }
    let milesPerMeter: Float = (125/201168)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSlider.maximumValue = 48280.3
        rangeSlider.minimumValue = 1609.34
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        rangeSlider.value = UserDefaults.standard.float(forKey: "slider_value")
        rangeLabel.text = "\(((rangeSlider.value * milesPerMeter)*10).rounded() / 10) miles"
    }

}
