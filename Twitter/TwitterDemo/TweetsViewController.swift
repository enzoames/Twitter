//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/25/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import Foundation

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance!.homeTimeline(
        success:
        {
            (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapLogout(_ sender: Any)
    {
        TwitterClient.sharedInstance?.logout()
    }
    
}

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||TABLEVIEW EXTENSION - FROM TWEETSVIEWCONTROLLER||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.tableView = self.tableView
        cell.tweet = tweet
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.setIcons()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        
        return 0
    }
    
    
}



//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||TWEETCELLDELEGATE - FROM TWEETSVIEWCONTROLLER||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


extension TweetsViewController: TweetCellDelegate {
    
    func favoriteTapped(tweet: Tweet?, indexPath: IndexPath)
    {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweetIndex = self.tweets.index(of: tweet!)
        
        if (tweet?.isFavorited)!
        {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet?.id)!, success: { (tweet: Tweet) in
            //cell.tweet = tweet
            self.tweets[tweetIndex!] = tweet
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        },
            failure:
            {
                (error: Error) in
                print("ERROR: \(error.localizedDescription)")
            })
        }
        else
        {
            TwitterClient.sharedInstance?.favorite(id: (tweet?.id)!, success: { (tweet: Tweet) in
            //cell.tweet = tweet
            self.tweets[tweetIndex!] = tweet
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        },
            failure:
            {
                (error: Error) in
                print("ERROR: \(error.localizedDescription)")
            })
        }
        
    }
    
    func retweetTapped(tweet: Tweet?, indexPath: IndexPath)
    {
        
        // let cell = tableView.cellForRow(at: indexPath) as! TweetCell
        let tweetIndex = self.tweets.index(of: tweet!)
        
        if (tweet?.isRetweeted)!
        {
                TwitterClient.sharedInstance?.unretweet(tweet: tweet!, success: { (tweet: Tweet) in
                //cell.tweet = tweet
                self.tweets[tweetIndex!] = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            },
            failure:
            {
                (error: Error) in
                print("ERROR: \(error.localizedDescription)")
            })
        }
        else
        {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { (tweet: Tweet) in
            //cell.tweet = tweet
            self.tweets[tweetIndex!] = tweet
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            },
            failure:
            {
                (error: Error) in
                print("ERROR: \(error.localizedDescription)")
            })
        }
        
    }
    


}














