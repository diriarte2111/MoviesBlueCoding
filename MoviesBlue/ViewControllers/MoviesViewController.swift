//
//  MoviesViewController.swift
//  MoviesBlue
//
//  Created by David Iriarte on 9/3/19.
//  Copyright © 2019 davidIriarte. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    var movies : [Movie] = []
    
    var hideFavorite : Bool! = false
    
    var selectedMovie : Movie!

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
        collectionLayout.minimumInteritemSpacing = 15
        collectionLayout.minimumLineSpacing = 25
        
        moviesCollectionView.collectionViewLayout = collectionLayout
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        getInfo()
        
    }
    
    func getInfo(){
        let handlerBlockUser: ([Movie]) -> Void = { moviesArray in
            self.movies = moviesArray
            self.moviesCollectionView.reloadData()
        }
        
        MovieRepository.getAllMovies(completionHandler: handlerBlockUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            let destinationVC = segue.destination as! MovieDetailViewController
            destinationVC.movie = selectedMovie
        }
    }
}

extension MoviesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        
        cell.movieObject = movies[indexPath.row]
        
        cell.favoriteButton.isHidden = hideFavorite
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize.init(width: (self.view.frame.width - 45)/2, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        self.performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
}
