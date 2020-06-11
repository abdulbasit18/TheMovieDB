//
//  CoreDataManager.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManger {

    let context : NSManagedObjectContext

    init(context : NSManagedObjectContext) {
        self.context = context
    }

    @discardableResult
    func save(entity : String ) -> Bool {
        var objectSaved = true
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                objectSaved = false
                print("CD - save object error occured")
            }
        }
        return objectSaved
    }

    func fetchObject(_ entity : String ,  predicate : Predicate? = nil) -> [NSManagedObject]? {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var data : [NSManagedObject]?
        if(predicate != nil){
            fetchRequest.predicate = NSPredicate(format: predicate!.format, argumentArray: predicate!.arguments)
        }
        do{
            data = try context.fetch(fetchRequest) as? [NSManagedObject]
        }catch{
            print("CD - fetch object error occured")
        }
        return data
    }

    @discardableResult
    func deleteObjects(_ entity : String ,  predicate : Predicate? = nil) -> Bool {
        let data = self.fetchObject(entity, predicate: predicate)
        var result = false

        if let dataToDelete = data {
            dataToDelete.forEach({ (_data) in
                context.delete(_data)
            })
            do {
                try context.save()
                result = true
            }catch{
                print("CD - delete object error occured")
            }
        }
        return result
    }

    func doesThisObjectExist(_ entity : String ,  predicate : Predicate) -> NSManagedObject? {
        let data = self.fetchObject(entity, predicate: predicate)
        var object : NSManagedObject? = nil
        if let _data = data {
            object = (_data.count <= 0) ? data?.first : nil
        }
        return object
    }
}
