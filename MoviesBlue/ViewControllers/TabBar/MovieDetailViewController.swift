//
//  MovieDetailViewController.swift
//  MoviesBlue
//
//  Created by David Iriarte on 9/3/19.
//  Copyright © 2019 davidIriarte. All rights reserved.
//

import UIKit
import Alamofire

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var synopsisTextView: UITextView!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    let baseURL = "https://image.tmdb.org/t/p/w500/"
    
    var movie : Movie!
    
    var imageURL : String!{
        willSet{
            guard let url = newValue else {
                self.imageView.image = UIImage.init(named: "no_poster_available")
                return
            }
            
            self.imageView.image = UIImage.init(named: "image_downloading")
            
            let imageCompleteURL = baseURL + url
            Alamofire.request(imageCompleteURL).responseImage { response in
                
                if let image = response.result.value {
                    self.imageView.image = image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = movie.title
        imageURL = movie.poster_path
        synopsisTextView.text = movie.overview!.count > 0 ? movie.overview : "NO SYNOPSIS AVAILABLE"
        synopsisTextView.textAlignment = movie.overview!.count > 0 ? NSTextAlignment.left : NSTextAlignment.center
        rateLabel.text = String(movie.vote_average)
        
        guard let release_date = movie.release_date else {
            releaseDateLabel.text = "Release date: N/A"
            return
        }
        releaseDateLabel.text = "Release date: " + release_date
    }
}
