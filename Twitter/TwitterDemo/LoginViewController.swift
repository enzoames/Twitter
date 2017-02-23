//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/21/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLoginButton(_ sender: Any)
    {
        let client = TwitterClient.sharedInstance
        
        client?.login(success: { 
            print("success login")
            
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })

    }
    
//    {
//    (error: NSError) -> Void in
//    print("error \(error.localizedDescription)")
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
