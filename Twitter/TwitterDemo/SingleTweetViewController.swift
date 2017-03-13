//
//  SingleTweetViewController.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 3/13/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController, UITextViewDelegate
{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var tweetReplyText: UITextView!
    
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var tweet: Tweet!
    var user: User!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tweetReplyText.delegate = self
        
        if tweet != nil
        {
            tweetLabel.text = tweet.text
            timeStampLabel.text = "\(DateFormatter.localizedString(from: tweet.timestamp!, dateStyle: .short, timeStyle: .none))"
            
            nameLabel.text = tweet.user.name!
            
            usernameLabel.text = "@\((tweet.ownerHandle)!)"
            
            tweetReplyText.text = "\(usernameLabel.text) "
            
            if let url = tweet.user.profileUrl
            {
                profileImage.setImageWith(url)
            }
            else
            {
                profileImage.image = UIImage(named: "TwitterLogoBlue")
            }
        }
        else
        {
            timeStampLabel.text = "now"
            nameLabel.text = user.name
            tweetLabel.text = ""
            usernameLabel.text = "@\((user.screenname)!)"
            tweetReplyText.text = " "
            
            if let url = user.profileUrl {
                profileImage.setImageWith(url)
            }
            else{
                profileImage.image = UIImage(named: "TwitterLogoBlue")
            }
        }
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func onTapCancel(_ sender: Any)
    {
         self.dismiss(animated: true)
    }
    
    
    @IBAction func onTapOutside(_ sender: Any)
    {
        view.endEditing(true)
    }
    
    
    
    @IBAction func onTapTweetIt(_ sender: Any)
    {
        if tweet != nil {
            TwitterClient.sharedInstance?.tweet(tweetTxt: tweetReplyText.text, inReplyTo: tweet.idAsString,
            success:
            {
                (tweet: Tweet) in
                self.tweet = tweet
            },
            failure:
            {
                (error: Error) in
                print(error.localizedDescription)
            })
        }
        else{
            TwitterClient.sharedInstance?.tweet(tweetTxt: tweetReplyText.text,
            success:
            {
                (tweet: Tweet) in
                self.tweet = tweet
            },
                failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        self.dismiss(animated: true)
    }


}
