//
//  NearestAirportDetails.swift
//  GoogleMapTest
//
//  Created by Admin on 08/02/21.
//

import Foundation
class NearestAirportDetailsArrayManager{
    static let shared = NearestAirportDetailsArrayManager()
    var airportDetailsArray : [Dictionary<String, Any>] = []
    private init(){}

    func getArray()->[Dictionary<String, Any>]{
        return airportDetailsArray
    }

    func addDataInArray(data : Dictionary<String, Any>){
        airportDetailsArray.append(data)
    }
}
