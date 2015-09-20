//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Wenzheng Li on 9/19/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Mentions(title: "Images", data: media.map{ MentionItem.Image($0.url, $0.aspectRatio)}))
                }
            }
            
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: "URLs", data: urls.map{ MentionItem.Keyword($0.keyword)}))
                }
            }
            
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: "Hashtags", data: hashtags.map{MentionItem.Keyword($0.keyword)}))
                }
            }
            
            if let users = tweet?.userMentions {
                if users.count > 0 {
                    mentions.append(Mentions(title: "UserMentions", data: users.map{MentionItem.Keyword($0.keyword)}))
                }
            }
        }
    }
    
    var mentions: [Mentions] = []
    
    struct Mentions: CustomStringConvertible {
        var title: String
        var data: [MentionItem]
        
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: CustomStringConvertible {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentions[section].data.count
    }

    
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "KeywordCell"
        static let ImageCellReuseIdentifier = "MentionImage"
        static let FromKeyWordSegueIdentifier = "Search Twitter"
        static let FromImageSegueIdentifier = "Show Image"
        static let WebSegueidentifier = "Show URL"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordCellReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            cell.imageURL = url
            return cell
        }
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
   
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.FromKeyWordSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        //UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        performSegueWithIdentifier(Storyboard.WebSegueidentifier, sender: sender)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.FromKeyWordSegueIdentifier:
                if let destination = segue.destinationViewController as? UITableViewController {
                    if let tweetCon = destination as? TweetTableViewController {
                        if let keywordCell = sender as? UITableViewCell {
                            tweetCon.searchText = keywordCell.textLabel?.text
                        }
                    }
                }
            case Storyboard.FromImageSegueIdentifier:
               let destination = segue.destinationViewController
               if let imageCon = destination as? ImageViewController {
                    if let imageCell = sender as? ImageTableViewCell {
                        imageCon.imageURL = imageCell.imageURL
                    }
               }
                
            case Storyboard.WebSegueidentifier:
                if let wv = segue.destinationViewController as? WebViewController {
                    if let webCell = sender as? UITableViewCell {
                        if let url = webCell.textLabel?.text {
                            wv.url = NSURL(string: url)
                        }
                    }
                }
            default: break
            }
        }
    }
}
