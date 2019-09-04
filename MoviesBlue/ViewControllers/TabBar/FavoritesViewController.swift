//
//  FavoritesViewController.swift
//  MoviesBlue
//
//  Created by David Iriarte on 9/3/19.
//  Copyright © 2019 davidIriarte. All rights reserved.
//

import UIKit

class FavoritesViewController: MoviesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        isFavorite = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfo()
    }
    
    override func getInfo(){
        movies = MovieRepository.getAllFavoriteMovies()
        moviesCollectionView.reloadData()
    }

}
