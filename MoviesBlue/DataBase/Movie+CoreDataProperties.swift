//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by David Iriarte on 9/4/19.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var movieId: Int64
    @NSManaged public var overview: String?
    @NSManaged public var pageNumber: Int16
    @NSManaged public var poster_path: String?
    @NSManaged public var title: String?
    @NSManaged public var vote_average: Double
    @NSManaged public var isInWatchlist: Bool

}
