//
//  Bookmark+CoreDataProperties.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/30/20.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var businessName: String
    @NSManaged public var address: String
    @NSManaged public var discountdesc: String

}
