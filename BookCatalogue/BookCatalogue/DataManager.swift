//
//  DataManager.swift
//
//
//  Created by pc on 19/05/23.
//

import Foundation
import CoreData
import UIKit
import StoreKit

class DataManager {
    
    static let shared = DataManager()

    let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
  
    
    func saveBooks(book: Book){
        let pic = getBooks()
        let url = book.thumbnailURL
        let urls = pic.map{ $0.url!}
        guard !urls.contains(url) else{
            return
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "BooksDataBaseModel", into: moc!) as? BooksDataBaseModel
        entity?.title = book.title
        entity?.url = book.thumbnailURL
        entity?.explanation = book.author
        saveMOC()
    }
    
    func getBooks() -> [BooksDataBaseModel]{
        var pics = [BooksDataBaseModel]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BooksDataBaseModel")
        do{
            pics = try (moc?.fetch(fetchRequest) as? [BooksDataBaseModel])!
        }catch{
            print("can not get data")
        }
        return pics
    }
    
    func deleteImages(index: URL) {
        let pic = getBooks()
        let urls = pic.map{ $0.url!}
        guard urls.contains(index) else{
            return
        }
        pic.forEach { img in
            if img.url == index{
                moc?.delete(img)
                saveMOC()
            }
        }
    }
    
    func deleteAllImage(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BooksDataBaseModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc?.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Failed to clear Core Data: \(error), \(error.userInfo)")
        }

    }
    
    func saveMOC(){
        do {
            try moc?.save()
            print("Image saved successfully.")
        } catch {
            print("Failed to save image: \(error)")
        }
    }
}
