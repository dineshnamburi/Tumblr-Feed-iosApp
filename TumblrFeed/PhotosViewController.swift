////
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by dinesh on 01/02/17.
//  Copyright © 2017 dinesh. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var posts : [NSDictionary] = []
    
    
    @IBOutlet weak var picsTableView: UITableView!
    @IBOutlet weak var PhotoCell: UITableView!
    var postOffSet = 21
    var loadingMoreView: InfiniteScrollActivityView?
    var isMoreDataLoading = false
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if (!isMoreDataLoading) {
            let scrollViewHeight = picsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewHeight - picsTableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && picsTableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: picsTableView.contentSize.height, width: picsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreData()
                // ... Code to load more results ...
            }
            
        }
    }
    
    func loadMoreData() {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(postOffSet)")
        let request = URLRequest(url: url!)
        // Configure session so that completion handler is executed on main UI thread
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
                        
                        
                        //self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        //print("responseDictionary: \(self.posts)")
                        
                        let newPosts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.posts = self.posts + newPosts
                        self.postOffSet = self.postOffSet + 20
                        self.isMoreDataLoading = false
                        self.loadingMoreView!.stopAnimating()
                        self.picsTableView.reloadData()
                        
                    }
                }
        });
        task.resume()
        
    }
    
    override func viewDidLoad() {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
         let frame = CGRect(x: 0, y: picsTableView.contentSize.height, width: picsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        picsTableView.addSubview(loadingMoreView!)
        var insets = picsTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        picsTableView.contentInset = insets
        
        
        
        picsTableView.insertSubview(refreshControl, at: 0)
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


    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
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
                         refreshControl.endRefreshing()
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


class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}
