//
//  DetailViewController.swift
//  TumblrFeed
//
//  Created by dinesh on 01/02/17.
//  Copyright © 2017 dinesh. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {


    
    @IBOutlet weak var detailImage: UIImageView!


    var index: String!
    var posts: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photos = posts.value(forKeyPath: "photos") as? [NSDictionary]{
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            let imageUrl = URL(string: imageUrlString!)!
            detailImage.setImageWith(imageUrl)
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
