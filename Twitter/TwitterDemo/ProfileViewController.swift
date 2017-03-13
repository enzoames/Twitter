//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 3/13/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController
{
    //||||||||||||||||||||||||||||||||||||||||||||
    //||||||||OUTLETS AND VARIABLES|||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||||
    
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountsLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameLabel.text = user.name
        usernameLabel.text = "@\((user.screenname)!)"
        tweetsCountLabel.text = "\((user.tweetCount)!)"
        followingCountsLabel.text = "\((user.followingCount)!)"
        followersCountLabel.text = "\((user.followerCount)!)"
        
        if let url = user.profileUrl
        {
            profileImage.setImageWith(url)
        }
        else
        {
            profileImage.image = UIImage(named: "TwitterLogoBlue")//if there is no profile image, use default twitter logo
        }
        
        if let url = user.profileBackgroundURL
        {
            profileBackgroundImage.setImageWith(url)
        }
        
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
