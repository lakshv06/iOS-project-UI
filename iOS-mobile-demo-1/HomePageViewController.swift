//
//  HomePageViewController.swift
//  iOS-mobile-demo-1
//
//  Created by Lakshya Verma on 24/07/24.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    var responseData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Display the data in the UI
               if let data = responseData {
                   print("Received Data in Home Page: \(data)")
               }
        
                if let data = responseData, let message = data["message"] as? String {
                    messageLabel.text = message
                } else {
                    messageLabel.text = "No message available."
                }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
