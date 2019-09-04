//
//  MovieRepository.swift
//  MoviesBlue
//
//  Created by David Iriarte on 9/3/19.
//  Copyright © 2019 davidIriarte. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import Alamofire

class MovieRepository {
    
    class func getAllMovies(pageNumber: Int16, completionHandler: @escaping ([Movie]) -> Void ){
        var movies : [Movie] = []
        
        movies = getMoviesFromDataBase(pageNumber: pageNumber)
        
        if movies.count == 0 {
            let handlerBlockUser: ([Movie]) -> Void = { moviesArray in
                completionHandler(moviesArray)
            }
            
            self.getMoviesFromAPI(pageNumber: pageNumber, completionHandler: handlerBlockUser)
            
        }else{
            movies = getAllMoviesFromDataBase()
            completionHandler(movies)
        }
    }
    
    class func getMoviesFromDataBase(pageNumber:Int16) -> [Movie] {
        var movies : [Movie] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return movies
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        fetchRequest.predicate = NSPredicate(format: "pageNumber == \(pageNumber)")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return movies
    }
    
    class func getAllMoviesFromDataBase() -> [Movie] {
        var movies : [Movie] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return movies
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return movies
    }
    
    class func getMoviesFromAPI(pageNumber: Int16, completionHandler: @escaping ([Movie]) -> Void ){
        var url = "https://api.themoviedb.org/3/discover/movie?api_key=e0f8cd821313d7bf4362d6fab32ae53e&sort_by=primary_release_date.desc&include_adult=false&include_video=false&primary_release_date.gte=2019-01-01&primary_release_date.lte=2019-07-31&with_release_type=1&year=2019"
        url = url + "&page=\(pageNumber)"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let moviesJSON : JSON = JSON(response.result.value!)
                    for movie in moviesJSON["results"].arrayValue {
                        self.addMovie(movieJson: movie, pageNumber: moviesJSON["page"].number!.int16Value)
                    }
                    let movie = getAllMoviesFromDataBase()
                    completionHandler(movie)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
    
    private class func addMovie(movieJson: JSON, pageNumber : Int16) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity  = NSEntityDescription.entity(forEntityName: "Movie",
                                                 in: managedContext)!
        
        let movie = NSManagedObject(entity: entity,
                                    insertInto: managedContext) as! Movie
        
        movie.title = movieJson["title"].string
        movie.overview = movieJson["overview"].string
        movie.poster_path = movieJson["poster_path"].string
        movie.vote_average = movieJson["vote_average"].number?.doubleValue ?? 0
        movie.movieId = movieJson["id"].number?.int64Value ?? 0
        movie.pageNumber = pageNumber
        movie.release_date = movieJson["release_date"].string
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func getAllFavoriteMovies () -> [Movie] {
        var movies : [Movie] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return movies
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        fetchRequest.predicate = NSPredicate(format: "isFavorite == 1")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return movies
    }
    
    class func saveAsFavorite(_ isFavorite:Bool, movieId: Int64) {
        
        var movie : Movie!
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        fetchRequest.predicate = NSPredicate(format: "movieId == \(movieId)")
        
        do {
            let movies = try managedContext.fetch(fetchRequest) as! [Movie]
            movie = movies.first
            movie.isFavorite = isFavorite
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getAllWatchListMovies () -> [Movie] {
        var movies : [Movie] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return movies
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        fetchRequest.predicate = NSPredicate(format: "isInWatchlist == 1")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return movies
    }
    
    class func saveToWatchlist(_ addOrRemove:Bool, movieId: Int64) {
        
        var movie : Movie!
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        fetchRequest.predicate = NSPredicate(format: "movieId == \(movieId)")
        
        do {
            let movies = try managedContext.fetch(fetchRequest) as! [Movie]
            movie = movies.first
            movie.isInWatchlist = addOrRemove
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
