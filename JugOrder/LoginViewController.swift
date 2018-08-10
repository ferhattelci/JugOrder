//
//  TestViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 09.08.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == tfPassword) {
            logIN()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
   
        
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)

    }


    @IBAction func loginPressed(_ sender: Any) {
        logIN()
    }
    
    func logIN(){
        let user = UserModel()
        user.username = tfUsername.text!
        user.password = tfPassword.text!
        
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
                    self.tfPassword.layer.borderColor = UIColor.red.cgColor
                    self.tfPassword.layer.borderWidth = 1.0
                }
                
            }
        }
    }
}
