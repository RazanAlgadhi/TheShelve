//
//  BooksDataBaseModel+CoreDataProperties.swift
//  Astronomy POD
//
//  Created by Risalat on 19/05/23.
//
//

import Foundation
import CoreData


extension BooksDataBaseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BooksDataBaseModel> {
        return NSFetchRequest<BooksDataBaseModel>(entityName: "BooksDataBaseModel")
    }

    @NSManaged public var url: URL?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    
}

extension BooksDataBaseModel : Identifiable {

}
