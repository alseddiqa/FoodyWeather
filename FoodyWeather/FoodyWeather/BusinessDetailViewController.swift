//
//  BusinessDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import UIKit

class BusinessDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func handlePhoneNumClick(_ sender: UIButton) {
        
        if let phoneNum = sender.titleLabel?.text {
            phoneCall(to: phoneNum)
        }
        
    }
    func phoneCall(to phoneNumber:String) {

        if let callURL:URL = URL(string: "tel:\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared

            if (application.canOpenURL(callURL)) {
                let alert = UIAlertController(title: "Your Title", message: "Do you want call that number?", preferredStyle: .alert)
                let callAction = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    application.open(callURL, options: [:], completionHandler: nil)
                })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                    print("Canceled Call")
                })
                alert.addAction(callAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
