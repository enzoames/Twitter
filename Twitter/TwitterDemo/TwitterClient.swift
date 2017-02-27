//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/22/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager
{
    
    //||||||||||||||||||||||||||||||||||||||
    //||||||||||||||||VARIABLES|||||||||||||
    //||||||||||||||||||||||||||||||||||||||
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "rrQ5MI42qKKWkgwyYND4TRoO7", consumerSecret: "cLww0LwlUODcQiSihPevwGw5y7rIrs1EIb5dV62mD0hhYAm4U0")
    
    var loginSuccess: ( () -> () )?
    var loginFailure: ( (Error) -> () )?
    
    //||||||||||||||||||||||||||||||||||||||
    //|||||||||||||||||||LOGIN||||||||||||||
    //||||||||||||||||||||||||||||||||||||||
    
    func login(success: @escaping () -> () , failure: @escaping (Error) -> () )
    {
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize() //logs out from any previous sessions
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "TwitterDemo://oauth") as URL!, scope: nil,
        success:
        {
            (requestToken: BDBOAuth1Credential?) -> Void in
            print("got token")
            //Added as a quary parameterw
            if let request = requestToken?.token
            {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request)")!
                //This next line is to open other applications. ex: when cliking on a link and it open safari to view the contents
                //of the link. to switch out of your application to something else
                //UIApplication.shared.canOpenURL(url as URL!)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        },
        
        failure:
        {
            (error: Error?) -> Void in
            self.loginFailure?(error!)
            print("error")
        })
    
    }
    
    
    //||||||||||||||||||||||||||||||||||||||
    //|||||||||||||||||||LOGOUT|||||||||||||
    //||||||||||||||||||||||||||||||||||||||
    
    func logout()
    {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        
    }
    
    
    //||||||||||||||||||||||||||||||||||||||
    //||||||||||HANDLE OPEN URL|||||||||||||
    //||||||||||||||||||||||||||||||||||||||
    
    func handleOpenURL(url: NSURL)
    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        //ACCESS TOKEN
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
                                 
        success:
        {
            (accessToken:BDBOAuth1Credential?) -> Void in
            print("got access token")
            self.loginSuccess?()
            
            //One more network call to get account
            self.currentAccount(
            success:
            {
                (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            },
            failure:
            {
                (error: Error) in
                self.loginFailure?(error)
            })
            
        },
        
        failure:
        {
            (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    
    
    
    //||||||||||||||||||||||||||||||||||||||
    //|||||||||||||||||||TIMELINE|||||||||||
    //||||||||||||||||||||||||||||||||||||||
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () )
    {
    
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
        
        success:
        {
            (task: URLSessionDataTask, response: Any? ) in
            //codehere
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
        },
        
        failure:
        {
            (task: URLSessionDataTask?, error: Error) in
            //code here
            failure(error)
        })
    
    }
    
    //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    //||||||||||||||||VERIFY CREDENTIALS : CURRENT ACCOUNT||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ())
    {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
        
        success:
        {
            (task: URLSessionDataTask, response: Any? ) in
            //code here
            //print("account: \(response)")
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
//            print("name: \(user.name)")
//            print("screenname: \(user.screenname)")
//            print("profile URL: \(user.profileURL)")
//            print("description: \(user.tagline)")
            
        },
        
        failure:
        {
            (task:URLSessionDataTask?, error:Error) in
            //code here
            failure(error)
        })
    
    }
    
    func tweetFromTimeline(withID: Int, success: @escaping (Tweet) -> (Void), failure: @escaping (Error) -> (Void)) {
        
        get("1.1/statuses/home_timeline.json",
            parameters: ["max_id": withID, "count": 1],
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
                let dictionary = (response as! [NSDictionary]).first
                let tweet = Tweet(dictionary: dictionary!)
                success(tweet)
                
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
            
        }
    }
    
    
    func favorite(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
    func unfavorite(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
    func retweet(id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetDict = response as! NSDictionary
            
            let tweet = Tweet(dictionary: tweetDict)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            // call did not succeed
            failure(error)
        }
        
    }
    
    func unretweet(tweet: Tweet, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
        
        let id = tweet.isRetweeted! ? tweet.originalTweetID : tweet.id
        print("isRetweeted: \(tweet.isRetweeted!)")
        print("originalTweetID: \(tweet.originalTweetID!)")
        print("tweetID: \(tweet.id!)")
        print("ID: \(id!)")
        
        get("1.1/statuses/show.json?id=\(id!)", parameters: ["include_my_retweet": true], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionary = response as! NSDictionary
            if let currentUserRetweetID = dictionary.value(forKeyPath: "current_user_retweet.id") {
                
                self.post("1.1/statuses/destroy/\(currentUserRetweetID).json",
                    parameters: nil,
                    progress: nil,
                    success: { (task: URLSessionDataTask, response: Any?) in
                        
                        self.tweetFromTimeline(withID: tweet.id!, success: success, failure: failure)
                        
                },
                    failure: { (task: URLSessionDataTask?, error: Error) in
                        
                        // code did not succeed
                        failure(error)
                })
                
            } else {
                preconditionFailure("Error: couldn't get current_user_retweet.id")
            }
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        }
    }


    
    
    
}





