//
//  MovieDataStorage.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import CoreData

final class MovieDataStorage {
    
    static let shared = MovieDataStorage()
       let persistentContainer: NSPersistentContainer

       private init() {
           persistentContainer = NSPersistentContainer(name: "MovieDataStorage")
           persistentContainer.loadPersistentStores { _, error in
               if let error = error {
                   fatalError("Error: \(error)")
               }
           }
       }

       var context: NSManagedObjectContext {
           return persistentContainer.viewContext
       }
       
       func insert(value: String) {
           let entity = MovieFavoriteEntity(context: context)
           entity.movieId = value
           
           do {
               try context.save()
           } catch {
               print("Error: \(error.localizedDescription)")
           }
       }

       func delete(value: String) {
           let fetchRequest: NSFetchRequest<MovieFavoriteEntity> = MovieFavoriteEntity.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "movieId == %@", value)
           
           do {
               let results = try context.fetch(fetchRequest)
               for object in results {
                   context.delete(object)
               }
               try context.save()
           } catch {
               print("Error: \(error.localizedDescription)")
           }
       }

       func exists(value: String) -> Bool {
           let fetchRequest: NSFetchRequest<MovieFavoriteEntity> = MovieFavoriteEntity.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "movieId == %@", value)
           
           do {
               let count = try context.count(for: fetchRequest)
               return count > 0
           } catch {
               print("Error: \(error.localizedDescription)")
               return false
           }
       }
}
