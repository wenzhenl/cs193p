//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Wenzheng Li on 9/19/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 3.0
        }
    }
    
    var alreadyTapped = false
    
    @IBAction func handleZoomIn(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            
            let pointView = gesture.locationInView(imageView)
            var newZoomScale = scrollView.zoomScale
            
            if alreadyTapped == false {
                newZoomScale = scrollView.zoomScale * 2.0
            } else {
                newZoomScale = scrollView.zoomScale / 2.0
            }
            
            alreadyTapped = !alreadyTapped
            
            newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
            
            let scrollViewSize = scrollView.bounds.size
            let w = scrollViewSize.width / newZoomScale
            let h = scrollViewSize.height / newZoomScale
            let x = pointView.x - (w / 2.0)
            let y = pointView.y - (h / 2.0)
            
            let rectToZoomTo = CGRectMake(x, y, w, h)
            
            scrollView.zoomToRect(rectToZoomTo, animated: true)
        default: break
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage()
    {
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url) // this blocks the thread it is on
                dispatch_async(dispatch_get_main_queue()) {
                    // only do something with this image
                    // if the url we fetched is the current imageURL we want
                    // (that might have changed while we were off fetching this one)
                    if url == self.imageURL { // the variable "url" is capture from above
                        if imageData != nil {
                            // this might be a waste of time if our MVC is out of action now
                            // which it might be if someone hit the Back button
                            // or otherwise removed us from split view or navigation controller
                            // while we were off fetching the image
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
