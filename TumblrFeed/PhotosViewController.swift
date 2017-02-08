////
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by dinesh on 01/02/17.
//  Copyright © 2017 dinesh. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var posts : [NSDictionary] = []
    @IBOutlet weak var picsTableView: UITableView!
    @IBOutlet weak var PhotoCell: UITableView!
    
    override func viewDidLoad() {
        picsTableView.rowHeight = 240;
        super.viewDidLoad()
        picsTableView.dataSource = self
        picsTableView.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                   
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                      
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        //print("responseDictionary: \(self.posts)")
                        self.picsTableView.reloadData()
                    }
                }
        });
        task.resume()
        
        
    }


    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("first sucsss")
        picsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print ("\(self.posts.count)")
            return self.posts.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = picsTableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        
        
        let post = self.posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]{
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            let imageUrl = URL(string: imageUrlString!)!
            cell.tumblrImage.setImageWith(imageUrl)
        }

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = picsTableView.indexPath(for: cell)
        let post = self.posts[(indexPath?.row)!]
        let detalViewController = segue.destination as! DetailViewController
        detalViewController.posts = post
        
        
    }
    

}
