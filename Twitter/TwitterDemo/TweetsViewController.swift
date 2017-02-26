//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/25/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TwitterClient.sharedInstance?.homeTimeline(success:
        {
            (tweets: [Tweet]) in
            
            for tweet in tweets
            {
                print(tweet.text!)
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapLogoutButton(_ sender: Any)
    {
        TwitterClient.sharedInstance?.logout()
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
