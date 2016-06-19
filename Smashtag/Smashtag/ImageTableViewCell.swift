//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Wenzheng Li on 9/19/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell
{
    @IBOutlet weak var mentionImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        mentionImage?.image = nil
        if let url = imageURL {
            spinner.startAnimating()
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.mentionImage?.image = UIImage(data: imageData!)
                        } else {
                            self.mentionImage?.image = nil
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
}
