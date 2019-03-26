//
//  TextModel+CoreDataClass.swift
//  
//
//  Created by Renata Makuch on 12/03/2019.
//
//

import Foundation
import CoreData

@objc(TextModel)
public class TextModel: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, language, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    //MARK: - Mapper
    
    public static func map(from json: [String:Any]) -> TextModel? {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
        }
    
        let managedObjectContext = CoreDataManager.shared.getContext(.main)
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let item = try decoder.decode(TextModel.self, from: jsonData)

            return item
        } catch {
            print("Error decoding TextModel: \(error)")
            return nil
        }
    }
    
    //MARK: - Decoding
    
    public convenience required init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "TextModel", in: managedObjectContext) else {
                fatalError("Failed to decode TextModel")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        language = try container.decode(String.self, forKey: .language)
        desc = try container.decode(String.self, forKey: .description)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
    
    public func encode(to encoder: Encoder) throws { }
}
