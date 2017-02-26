//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/22/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString) as NSDate?
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        
//        for dictionary in dictionaries
//        {
//            let tweet = Tweet(dictionary: dictionary)
//            
//            tweets.append(tweet)
//        }

        dictionaries.forEach { (dictionary) in tweets.append(Tweet(dictionary: dictionary)) }
        
    return tweets
        
    }
}
