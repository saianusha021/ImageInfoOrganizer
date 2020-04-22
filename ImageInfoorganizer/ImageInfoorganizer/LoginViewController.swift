//
//  LoginViewController.swift
//  ImageInfoorganizer
//
//  Created by Anusha Meda on 2/26/20.
//  Copyright © 2020 Anusha Meda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
           super.viewDidLoad()
       // Do any additional setup after loading the view.
       }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        UserDefaults.standard.set( "YES", forKey: "isLoggedIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let maintab = storyboard.instantiateViewController(withIdentifier: "mainTab")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = maintab
    }
    
    
    
    
    @IBAction func registerButtonClicked(_ sender: Any) {
    }
   


}
