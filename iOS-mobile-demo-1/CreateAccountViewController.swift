//
//  CreateAccountViewController.swift
//  iOS-mobile-demo-1
//
//  Created by Lakshya Verma on 23/07/24.
//

import UIKit
// TODO: Integrate key chain access when basic things are done
// import KeychainAccess

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        
        print("Email: \(email)")
        print("Password: \(password)")
        print("Confirm Password: \(confirmPassword)")
        
        if password == confirmPassword {
            // Passwords match, show a success toast
            showToast(message: "Trying Sign up", duration: 2.0)
                let deviceName = UIDevice.current.name
                let deviceModel = UIDevice.current.model
                let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString
            
                print("Device Name: \(deviceName)")
                print("Device Model: \(deviceModel)")
                print("Device Identifier: \(String(describing: deviceIdentifier))")
            
            // Send the UUID and email to your backend server here
            if deviceIdentifier != nil {
                            sendToBackend(email: email, password: password, confirmPassword: confirmPassword, deviceName: deviceName, deviceModel: deviceModel, deviceIdentifier: deviceIdentifier!)
                        }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                       if let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? ViewController {
                           self.navigationController?.pushViewController(mainViewController, animated: true)
                       }
                   }
        } else {
            // Passwords do not match, show an error toast
            showToast(message: "Passwords do not match", duration: 2.0)
        }
    }

//    // Function to generate and store a new UUID
//        func generateAndStoreDeviceUUID() -> String {
//            let deviceUUID = UUID().uuidString
//            keychain["deviceUUID"] = deviceUUID
//            // Optionally send the UUID to the backend server
//            // sendToBackend(email: email, deviceUUID: deviceUUID)
//            return deviceUUID
//        }
//        
//        // Function to retrieve the UUID from Keychain
//        func retrieveDeviceUUID() -> String? {
//            return keychain["deviceUUID"]
//        }
    
    // Function to display a toast-like message
    func showToast(message: String, duration: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        // Duration for how long the toast should appear
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    // backend data
    func sendToBackend(email: String, password: String, confirmPassword: String, deviceName: String, deviceModel: String, deviceIdentifier: String) {
        // Define the URL for your API endpoint
        guard let url = URL(string: "http://localhost:8000/sign-up") else {
            print("Invalid URL")
            return
        }
        
        // Create a URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
            "confirm_password": confirmPassword,
            "device_name": deviceName,
            "device_model": deviceModel,
            "device_identifier": deviceIdentifier
        ]
        
        // Convert the request body to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch let error {
            print("Error serializing request body: \(error)")
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making POST request: \(error)")
                return
            }
            
            // Check for successful response
            if let httpResponse = response as? HTTPURLResponse {
                print("Sign up route response status code: \(httpResponse.statusCode)")
                
                // Print the body of the response
                if let data = data {
                    do {
                        if let responseBody = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Response Body: \(responseBody)")
                        } else if let responseString = String(data: data, encoding: .utf8) {
                            print("Response String: \(responseString)")
                        }
                    } catch let error {
                        print("Error parsing response body: \(error)")
                    }
                }
                
                // Show success message on the main thread
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 201 {
                        self.showToast(message: "Signup successful", duration: 2.0)
                    } else {
                        self.showToast(message: "Signup failed", duration: 2.0)
                    }
                }
            }
        }
        
        task.resume()
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
