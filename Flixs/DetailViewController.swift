//
//  DetailViewController.swift
//  Flixs
//
//  Created by Hugh A. Miles II on 1/12/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var Overview: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(movie)
        // Do any additional setup after loading the
        movieTitle.text = movie["title"] as? String
        Overview.text = movie["overview"]as! String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
