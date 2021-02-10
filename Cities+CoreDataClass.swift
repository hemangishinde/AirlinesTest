//
//  Cities+CoreDataClass.swift
//  GoogleMapTest
//
//  Created by Admin on 07/02/21.
//
//

import UIKit
import CoreData

public class Cities: NSManagedObject, Codable {

    
    enum CodingKeys: String, CodingKey {
        case name
        case city
        case state
        case country
        case runway_length
        case lat
        case lon
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Cities", in: managedObjectContext) else {
            fatalError("Failed to decode")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try container.decode(String.self, forKey: .city)
        countryName = try container.decode(String.self, forKey: .country)
        airportName = try container.decode(String.self, forKey: .name)
        lattitude = try container.decode(String.self, forKey: .lat)
        longitude = try container.decode(String.self, forKey: .lon)
        runway_length = try container.decodeIfPresent(String.self, forKey: .runway_length)

        
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cityName, forKey: .city)
        try container.encode(countryName, forKey: .country)
        try container.encode(airportName, forKey: .name)
        try container.encode(runway_length, forKey: .runway_length)
        
    }
}
