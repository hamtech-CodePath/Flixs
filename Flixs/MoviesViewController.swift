//
//  MoviesViewController.swift
//  Flixs
//
//  Created by Hugh A. Miles II on 1/8/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit
import AFNetworking
import SWActivityIndicatorView

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var moviesTimeline: UICollectionView!
    
    var movies: [NSDictionary]?
    var loader: SWActivityIndicatorView?
    var refresh: UIRefreshControl!
    var endpoint: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.moviesTimeline.delegate = self
        self.moviesTimeline.dataSource = self
        
        
        //setup refresh to reload
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTimeline.insertSubview(refresh, atIndex: 0)
        
        //hide timeline intiallly for loadingState
        self.moviesTimeline.alpha = 0 //present moviesTimeline

        
        self.startLoader()
        self.getMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getMovies()
    }
    
    //UICollectionView - Delegates and DataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        //set background
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blackColor()
        cell.selectedBackgroundView = backgroundView
        
        let movie = movies![indexPath.row]
        if let posterPath = movie["poster_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/original"
            let imageURL = NSURL(string: baseURL + posterPath)
            cell.Image.setImageWithURL(imageURL!)
            cell.Popularity.text = String(movie["popularity"] as! Int)
            print("TESTINGNKLFJJLF")
            print(movie["vote_count"] as? Int)
            cell.Vote.text = String(movie["vote_count"] as! Int)
            
            cell.heart.animationType = "SqueezeInRight"
            cell.graph.animationType = "SqueezeInLeft"
            cell.graph.animate()
            cell.heart.animate()
            
            //apply shadow to cell
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.blackColor().CGColor
            cell.layer.shadowOffset = CGSizeMake(0,4)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies { //if movies isnt nil
            return movies.count
        } else {    //return 0
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Use a red color when the user selects the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.redColor()
        cell.selectedBackgroundView = backgroundView
    }
    
    func getMovies() {
        //self.loader.startAnimating()
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.moviesTimeline.reloadData() 
                            self.delay(5, closure: { () -> () in
                                self.loader?.stopAnimating()
                                self.moviesTimeline.alpha = 1 //present moviesTimeline
                            })
                    }
                }
                    
                else if (error != nil) {
                    //make warning message
                    print("API call not working")
                }
        });
        task.resume()
    }
    
    func startLoader() {
        //init and startLoader
        loader = SWActivityIndicatorView(frame: CGRect(x: 135, y: 260, width: 50, height: 50))

        self.view.addSubview(loader!)
        loader!.hidesWhenStopped = true
        loader!.startAnimating()
    }
    
    //UIRefreshControl Methods
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refresh.endRefreshing()
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieCollectionViewCell //cast sender >> UICollectionCell
        let index = moviesTimeline.indexPathForCell(cell) //GetIndex that was selected
        let selectedMovie = movies![index!.row] // getMovie from dictionary
        
        let detail = segue.destinationViewController as! DetailViewController
        detail.movie = selectedMovie
        
        
        
    }
}

