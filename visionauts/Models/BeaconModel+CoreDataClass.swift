//
//  BeaconModel+CoreDataClass.swift
//  
//
//  Created by Renata Makuch on 12/03/2019.
//
//

import Foundation
import CoreData

@objc(BeaconModel)
public class BeaconModel: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, uuid, minor, major, enabled, texts
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var descriptionInCurrentLanguage: String? {
        guard let texts = self.texts?.allObjects as? [TextModel] else {
            return nil
        }
    
        let text = texts.first(where: { $0.language == "en" })
        return text?.desc
        /// debug test
        //        return  "minor: \(self.minor ?? ""), major: \(self.major ?? "") ,uuid: \(self.uuid ?? "no uuid"), description: \(text?.desc ?? "empty")"
    }
    
    //MARK: - Mapper
    
    public static func map(from json: [String:Any]) -> BeaconModel? {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
        }
        
        let managedObjectContext = CoreDataManager.shared.getContext(.main)
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let item = try decoder.decode(BeaconModel.self, from: jsonData)
            
            return item
        } catch {
            print("Error decoding BeaconModel: \(error)")
            return nil
        }
    }
    
    //MARK: - Decoding
    
    public convenience required init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "BeaconModel", in: managedObjectContext) else {
                fatalError("Failed to decode BeaconModel")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decode(String.self, forKey: .uuid)
        minor = try container.decode(String.self, forKey: .minor)
        major = try container.decode(String.self, forKey: .major)
        enabled = try container.decode(Bool.self, forKey: .enabled)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        if let texts = try container.decodeIfPresent([TextModel].self, forKey: .texts) {
            self.addToTexts(NSSet(array: texts))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}
