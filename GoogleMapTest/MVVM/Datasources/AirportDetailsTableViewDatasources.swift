//
//  AirportDetailsTableViewDatasources.swift
//  GoogleMapTest
//
//  Created by Admin on 07/02/21.
//

import UIKit

class AirportDetailsTableViewDatasources: NSObject, UITableViewDataSource {
    
    // MARK: - Table view data source
    let nearestAirportDetailsArray = NearestAirportDetailsArrayManager.shared.airportDetailsArray
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearestAirportDetailsArray.prefix(5).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirportDetailCell", for: indexPath) as! AirportDetailsTableViewCell
        
        let airportDetails = nearestAirportDetailsArray[indexPath.row]
                print(airportDetails["CountryName"] as? [String: Any] as Any)
                if let name = airportDetails["CountryName"] as? [String: Any] {
                    print(name)
                }
                cell.m_airportNameLable.text=airportDetails["AirportName"] as? String
                cell.m_countryNameLabel.text=airportDetails["CountryName"] as? String
                cell.m_runwayLengthLabel.text=airportDetails["RunwayLength"] as? String
        return cell
    }
}
