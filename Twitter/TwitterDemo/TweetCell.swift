//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Enzo Ames on 2/26/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit


protocol TweetCellDelegate {
    func retweetTapped(tweet: Tweet?, indexPath: IndexPath)
    func favoriteTapped(tweet: Tweet?, indexPath: IndexPath)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    @IBOutlet weak var retweetCountsLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!

    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!

//    @IBOutlet weak var topConstraintToRetweetImage: NSLayoutConstraint!
    
    var tableView: UITableView!
    
    var delegate: TweetCellDelegate?
    var indexPath: IndexPath?

    var tweet: Tweet!
    {
        didSet
        {
            userNameLabel.text = tweet.name!
            
            userScreenNameLabel.text = "@\(tweet.ownerHandle!)"

            if let imageURL = tweet.ownerAvatarURL {
                avatarImageView.setImageWith(imageURL)
            }
        
            tweetDescriptionLabel.text = tweet.text!
            timeStampLabel.text = tweet.format(timestamp: tweet.timestamp!)
            retweetCountsLabel.text = tweet.format(count: tweet.retweet_count)
        
            if tweet.isFavorited! && tweet.favorites_count == 0
            {
                favoritesLabel.text = tweet.format(count: tweet.favorites_count + 1)
            } else
            {
                favoritesLabel.text = tweet.format(count: tweet.favorites_count)
            }
            
            if tweet.isRetweetStatus
            {
                retweetLabel.isHidden = false
                retweetedImageView.isHidden = false
                retweetLabel.text = "Retweeted by \(tweet.retweetedBy!)"
                //topConstraintToRetweetImage.priority = 999
                
            }
            else
            {
                retweetLabel.isHidden = true
                retweetedImageView.isHidden = true
                //topConstraintToRetweetImage.priority = 1
            }
            
            setIcons()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = 5
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setIcons() {
        
        if tweet.isFavorited! {
            favoritesLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            favoriteButton.imageView?.image = UIImage(named: "favor-icon-red")
        } else {
            favoritesLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            favoriteButton.imageView?.image = UIImage(named: "favor-icon")
        }
        
        if tweet.isRetweeted! {
            retweetCountsLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            retweetButton.imageView?.image = UIImage(named: "retweet-icon-green")
            
        } else {
            retweetCountsLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            retweetButton.imageView?.image = UIImage(named: "retweet-icon")
        }
    }
    
    
    //Button Actions
    @IBAction func onFavorite(_ sender: Any)
    {
        delegate?.favoriteTapped(tweet: self.tweet, indexPath: self.indexPath!)
    }
    
    
    @IBAction func onRetweet(_ sender: Any)
    {
        delegate?.retweetTapped(tweet: self.tweet, indexPath: self.indexPath!)
    }
    

    
}



















