//
//  TextModel+CoreDataProperties.swift
//  
//
//  Created by Renata Makuch on 12/03/2019.
//
//

import Foundation
import CoreData


extension TextModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextModel> {
        return NSFetchRequest<TextModel>(entityName: "TextModel")
    }

    @NSManaged public var id: Int
    @NSManaged public var language: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var beacon: BeaconModel?

}
