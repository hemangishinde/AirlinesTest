//
//  Cities+CoreDataProperties.swift
//  GoogleMapTest
//
//  Created by Admin on 07/02/21.
//
//

import Foundation
import CoreData


extension Cities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cities> {
        return NSFetchRequest<Cities>(entityName: "Cities")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var airportName: String?
    @NSManaged public var runway_length: String?
    @NSManaged public var lattitude: String?
    @NSManaged public var longitude: String?

}

extension Cities : Identifiable {

}
