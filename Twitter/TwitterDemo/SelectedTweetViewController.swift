//
//  SelectedTweetViewController.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 3/13/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class SelectedTweetViewController: UIViewController
{
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var tweetTxt: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!

    var tweet: Tweet!
    
    var indexPath: IndexPath!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        update()
    }
    
    
    @IBAction func onTapFavorite(_ sender: Any)
    {
        if tweet.isFavorited == false {
            TwitterClient.sharedInstance?.favorite(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.update()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        else{
            TwitterClient.sharedInstance?.unfavorite(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.update()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    
    
    }
    
    
    @IBAction func onTapRetweet(_ sender: Any)
    {
        if tweet.isRetweeted == false {
            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.update()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
        else{
            TwitterClient.sharedInstance?.unretweet(tweet: tweet, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.update()
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    
    }
    
    
    @IBAction func onTapReply(_ sender: Any)
    {
        performSegue(withIdentifier: "replySegue", sender: nil)
    }
    
    
    
    func update(){
        tweetTxt.text = tweet.text
        timeLabel.text = "\(DateFormatter.localizedString(from: tweet.timestamp!, dateStyle: .short, timeStyle: .short))"
        usernameLabel.text = tweet.user.name
        usernameLabel.text = "@\((tweet.user.screenname)!)"
        if tweet.isFavorited! {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        }
        else{
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        if tweet.isRetweeted!{
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        }
        else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        
        favoriteCountLabel.text = "\(tweet.favorites_count)"
        retweetCountLabel.text = "\(tweet.retweet_count)"
        
        if let url = tweet.user?.profileUrl {
            profileImage.setImageWith(url)
        }
        else{
            profileImage.image = UIImage(named: "TwitterLogoBlue")
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let navigationController = segue.destination as? UINavigationController{
            let replyViewController = navigationController.topViewController as! SingleTweetViewController
            replyViewController.tweet = tweet
        }
    }
    
    
}





