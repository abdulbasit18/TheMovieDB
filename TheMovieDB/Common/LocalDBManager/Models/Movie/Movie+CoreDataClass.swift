//
//  Movie+CoreDataClass.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {


    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(context : NSManagedObjectContext ) {
        let entityDesc = NSEntityDescription.entity(forEntityName: "Movie", in: context)
        super.init(entity: entityDesc!, insertInto: context)
    }

    init(movieDTO : MovieDTO , context : NSManagedObjectContext){

        let entityDesc = NSEntityDescription.entity(forEntityName: "Movie", in: context)
        super.init(entity: entityDesc!, insertInto: context)

        self.movieId = Int64(movieDTO.id)
        self.title = movieDTO.title
        self.originalTitle = movieDTO.originalTitle
        self.adult = movieDTO.adult ?? false
        self.releaseDate = movieDTO.releaseDate
        self.overview = movieDTO.overview
        self.posterPath = movieDTO.posterPath
        self.voteAverage = movieDTO.voteAverage ?? 0
    }
}
