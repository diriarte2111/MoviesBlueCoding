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
    
    var isFavorite : Bool! = false
    
    var selectedMovie : Movie!
    
    fileprivate var searching = false
    
    var filteredMovies : [Movie] = []
    
    var pageNumber = 1
    
    fileprivate var isWaiting = false

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.definesPresentationContext = true
        self.definesPresentationContext = true
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
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
        
        MovieRepository.getAllMovies(pageNumber:Int16(pageNumber), completionHandler: handlerBlockUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addKeyboardObservers ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height - self.tabBarController!.tabBar.frame.height, right: 0.0)
        moviesCollectionView.contentInset = contentInsets
        moviesCollectionView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0,bottom: 0.0, right: 0.0)
        moviesCollectionView.contentInset = contentInsets
        moviesCollectionView.scrollIndicatorInsets = contentInsets
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            let destinationVC = segue.destination as! MovieDetailViewController
            destinationVC.movie = selectedMovie
        }
    }
    
    private func doPaging() {
        isWaiting = false
        DispatchQueue.main.async { [weak self] in
            self?.getInfo()
        }
    }
}

extension MoviesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.searching ? self.filteredMovies.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        
        cell.movieObject = self.searching ? self.filteredMovies[indexPath.row] : movies[indexPath.row]
        
        cell.favoriteButton.isHidden = isFavorite
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        if self.searching || self.isFavorite { return }

        if indexPath.row == self.movies.count - 2 && !isWaiting {
            isWaiting = true
            let movie = movies[indexPath.row]
            self.pageNumber = Int(movie.pageNumber) + 1
            self.doPaging()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize.init(width: (self.view.frame.width - 45)/2, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = self.searching ? self.filteredMovies[indexPath.row] : movies[indexPath.row]
        self.performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
}

extension MoviesViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filteredMovies = movies.filter{ $0.title!.lowercased().contains(text.lowercased())}
            self.searching = true
        }
        else {
            self.searching = false
            self.filteredMovies = []
        }
        self.moviesCollectionView.reloadData()
    }
}
