//
//  User.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/22/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//


// Models in other frameworks is where you keep your application business logic. But in IOS developemnt that is not true.
// Your API / Server contains all your logic. Your Model is only responsable for echoing and capturing the data types
// that are on your server. Most Models have desirialization (taking a dictionary and then selectively populating individual
// properties). Models also save to disk (Persistance)
//

import UIKit

class User: NSObject {
    
    //All of these variables are optional (?) because there might be a change that nothing might be found in them (nil)
    var name: NSString?
    var screenname: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    
    //This proccess is called Desirialization. Everything that we get back from the internet, initialize it to these variables
    //Also called constructor
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        
        let profileURLString = dictionary["profile_image_url_https"] as? NSString
        
        if let profileURLString = profileURLString
        {
            profileURL = NSURL(string: profileURLString as String)
        }
        
        tagline = dictionary["description"] as? NSString
    }
}
