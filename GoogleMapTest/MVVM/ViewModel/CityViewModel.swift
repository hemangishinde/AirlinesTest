//
//  CityViewModel.swift
//  GoogleMapTest
//
//  Created by Admin on 06/02/21.
//

import UIKit
protocol CityListViewModelDelegate: NSObject {
    func parseCitysSuccess()
    func parseCityFailedWithMessage(_ message: String)
}
class CityViewModel: NSObject {
    private var cities: Array<Cities> {
        didSet {
            self.delegate?.parseCitysSuccess()
        }
    }
    
    weak var delegate: CityListViewModelDelegate?
    
    init(_ delegate: CityListViewModelDelegate?) {
        self.delegate = delegate
        self.cities = Array<Cities>()
    }
    
    func parseJson() {
        
        let urlString = "https://gist.githubusercontent.com/tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588/airports.json"

        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
          if error != nil {
            print(error as Any)
          } else {
            do {
                let decoder = JSONDecoder()
                let managedObjectContext = CoreDataStorage.shared.managedObjectContext()
                guard let codingInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                    fatalError("Failed to retrieve managed object context Key")
                }
                decoder.userInfo[codingInfoKeyManagedObjectContext] = managedObjectContext

                do {
                    let result = try decoder.decode([Cities].self, from: data!)
                    print(result)
                } catch let error {
                    print("decoding error: \(error)")
                }

                CoreDataStorage.shared.clearStorage(forEntity: "Cities")
                CoreDataStorage.shared.saveContext()

                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                print(paths[0])
               
            } catch let error as NSError {
              print(error)
            }
          }

        }.resume()
            
    }
    
    
}
