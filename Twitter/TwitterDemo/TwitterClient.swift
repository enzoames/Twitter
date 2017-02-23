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
        
        TwitterClient.sharedInstance?.deauthorize() //logs out from any previous sessions
        
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "TwitterDemo://oauth") as URL!, scope: nil,
        
        success:
        {
            (requestToken: BDBOAuth1Credential?) -> Void in
            print("got token")
            //Added as a quary parameterw
            if let request = requestToken?.token
            {
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request)")!
                //This next line is to open other applications. ex: when cliking on a link and it open safari to view the contents
                //of the link. to switch out of your application to something else
                UIApplication.shared.openURL(url as URL!)
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
    //||||||||||HNDLE OPEN URL||||||||||||||
    //||||||||||||||||||||||||||||||||||||||
    
    func handleOpenURL()
    {
        
    
    
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
    
    //||||||||||||||||||||||||||||||||||||||||||||||||||
    //||||||||||||||||VERIFY CREDENTIALS||||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||||||||||
    
    func currentAccount()
    {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
        
        success:
        {
            (task: URLSessionDataTask, response: Any? ) in
            //code here
            //print("account: \(response)")
            let userDictionary = response as? NSDictionary
            
            let user = User(dictionary: userDictionary!)
                
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile URL: \(user.profileURL)")
            print("description: \(user.tagline)")
                
        },
        
        failure:
        {
            (task:URLSessionDataTask?, error:Error) in
            //code here
        })
    
    }
    
    
}





