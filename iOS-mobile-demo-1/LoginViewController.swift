//
//  LoginViewController.swift
//  iOS-mobile-demo-1
//
//  Created by Lakshya Verma on 23/07/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        print("Email: \(email)")
        print("Password: \(password)")
        
        showToast(message: "Trying Sign in", duration: 2.0)
            let deviceName = UIDevice.current.name
            let deviceModel = UIDevice.current.model
            let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString
        
            print("Device Name: \(deviceName)")
            print("Device Model: \(deviceModel)")
            print("Device Identifier: \(String(describing: deviceIdentifier))")
        
        // Send the UUID and email to your backend server here
        if deviceIdentifier != nil {
                sendToBackend(email: email, password: password, deviceName: deviceName, deviceModel: deviceModel, deviceIdentifier: deviceIdentifier!)
                }
        
    }
    
    // backend data
    func sendToBackend(email: String, password: String, deviceName: String, deviceModel: String, deviceIdentifier: String) {
        guard let url = URL(string: "http://localhost:8000/sign-in") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
            "device_name": deviceName,
            "device_model": deviceModel,
            "device_identifier": deviceIdentifier
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch let error {
            print("Error serializing request body: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making POST request: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Sign in route response status code: \(httpResponse.statusCode)")

                if let data = data {
                    do {
                        if let responseBody = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Response Body: \(responseBody)")
                            
                            DispatchQueue.main.async {
                                if httpResponse.statusCode == 200 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        if let homePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
                                            homePageViewController.responseData = responseBody // Pass the data
                                            self.navigationController?.pushViewController(homePageViewController, animated: true)
                                        }
                                    }
                                } else {
                                    self.showToast(message: "Signin failed", duration: 2.0)
                                }
                            }
                        } else if let responseString = String(data: data, encoding: .utf8) {
                            print("Response String: \(responseString)")
                        }
                    } catch let error {
                        print("Error parsing response body: \(error)")
                    }
                }
            }
        }

        task.resume()
    }

    
    // Function to display a toast-like message
    func showToast(message: String, duration: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        // Duration for how long the toast should appear
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
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
