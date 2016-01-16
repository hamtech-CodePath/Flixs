//
//  DetailViewController.swift
//  Flixs
//
//  Created by Hugh A. Miles II on 1/12/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var Overview: UILabel!
    var movie: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        // Do any additional setup after loading the
        movieTitle.text = movie["title"] as? String
        Overview.text = movie["overview"]as? String
        if let posterPath = movie["poster_path"] as? String {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let imageURL = NSURL(string: baseURL + posterPath)
            poster.setImageWithURL(imageURL!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {}
}
