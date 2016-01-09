//
//  MoviesViewController.swift
//  Flixs
//
//  Created by Hugh A. Miles II on 1/8/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var moviesTimeline: UICollectionView!
    
    var movies: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.moviesTimeline.delegate = self
        self.moviesTimeline.dataSource = self
        
        self.getMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionView - Delegates and DataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        
        cell.Image.setImageWithURL(imageURL!)
        cell.Title.text = title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies { //if movies isnt nil
            return movies.count
        } else {    //return 0
            return 0
        }
    }
    
    func getMovies() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
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
                    }
                }
        });
        task.resume()
    }

}

