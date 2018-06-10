//
//  LoginViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 05.06.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPasswod: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfUsername.delegate = self
        tfPasswod.delegate = self


        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func btnLogin(_ sender: Any) {
        
        let user = UserModel()
        user.username = tfUsername.text!
        user.password = tfPasswod.text!
        
        user.getData { (newUser) in
            if newUser.id != 0 && newUser.id != nil {
                print("login success")
                activeUser = newUser
                activeUser.createStartWork()

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationNavigationController = storyboard.instantiateViewController(withIdentifier: "LoadViewController") as! LoadViewController
                DispatchQueue.main.async {
                
                    self.present(destinationNavigationController, animated: true, completion: nil)
                }
            } else {
                //login failed
                DispatchQueue.main.async {

                    self.tfUsername.layer.borderColor = UIColor.red.cgColor
                    self.tfUsername.layer.borderWidth = 1.0
                    self.tfPasswod.layer.borderColor = UIColor.red.cgColor
                    self.tfPasswod.layer.borderWidth = 1.0
                }
                
            }
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
