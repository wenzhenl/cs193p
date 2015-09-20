//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Wenzheng Li on 9/19/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    var hashtagColor = UIColor.blueColor()
    var urlColor = UIColor.redColor()
    var userMentionsColor = UIColor.greenColor()
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            var text = tweet.text

            for _ in tweet.media {
                text += " 📷"
            }
            
            let attributedText = NSMutableAttributedString(string: text)
            
            for hashtag in tweet.hashtags {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: hashtagColor, range: hashtag.nsrange)
            }
            
            for url in tweet.urls {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: urlColor, range: url.nsrange)
            }
            
            for userMention in tweet.userMentions {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: userMentionsColor, range: userMention.nsrange)
            }
            
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if profileImageURL == tweet.user.profileImageURL {
                            if imageData != nil {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                }
            }
        }
        
//            let formatter = NSDateFormatter()
//            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
//                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
//            } else {
//                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//            }
    }
    
}
