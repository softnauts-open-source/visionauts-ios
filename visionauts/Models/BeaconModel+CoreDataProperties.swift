//
//  BeaconModel+CoreDataProperties.swift
//  
//
//  Created by Renata Makuch on 12/03/2019.
//
//

import Foundation
import CoreData


extension BeaconModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BeaconModel> {
        return NSFetchRequest<BeaconModel>(entityName: "BeaconModel")
    }

    @NSManaged public var id: Int
    @NSManaged public var uuid: String?
    @NSManaged public var minor: String?
    @NSManaged public var major: String?
    @NSManaged public var enabled: Bool
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var texts: NSSet?

}

// MARK: Generated accessors for texts
extension BeaconModel {

    @objc(addTextsObject:)
    @NSManaged public func addToTexts(_ value: TextModel)

    @objc(removeTextsObject:)
    @NSManaged public func removeFromTexts(_ value: TextModel)

    @objc(addTexts:)
    @NSManaged public func addToTexts(_ values: NSSet)

    @objc(removeTexts:)
    @NSManaged public func removeFromTexts(_ values: NSSet)

}
