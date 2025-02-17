//
//  MovieFavoriteEntity+CoreDataProperties.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//
//

import Foundation
import CoreData


extension MovieFavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieFavoriteEntity> {
        return NSFetchRequest<MovieFavoriteEntity>(entityName: "MovieFavoriteEntity")
    }

    @NSManaged public var movieId: String?

}

extension MovieFavoriteEntity : Identifiable {

}
