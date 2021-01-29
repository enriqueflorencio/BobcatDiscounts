//
//  Bookmark+CoreDataProperties.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 1/6/21.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var address: String
    @NSManaged public var businessName: String
    @NSManaged public var category: String
    @NSManaged public var discountdesc: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
