//
//  CustomSearchTextField.swift
//  CustomSearchField
//
//  Created by Emrick Sinitambirivoutin on 19/02/2019.
//  Copyright © 2019 Emrick Sinitambirivoutin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class CustomSearchTextField: UITextField{
    
    var dataList : [Cities] = [Cities]()
    var CityDetails : [Cities] = [Cities]()
    var resultsList : [SearchItem] = [SearchItem]()
    var tableView: UITableView?
    var nearestAirportArray = [Dictionary<String, Any>]()
    let context = CoreDataStorage.shared.persistentContainer.viewContext
    
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
        
    }
    
    
    // Text Field related methods
    
    @objc open func textFieldDidChange(){
        print("Text changed ...")
        filter()
        updateSearchTableView()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")

    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }
 
    // MARK: CoreData manipulation methods
    
    func saveItems() {
        print("Saving items")
        do {
            try context.save()
        } catch {
            print("Error while saving items: \(error)")
        }
    }
    
    func loadItems(withRequest request : NSFetchRequest<Cities>) {
            do {
                dataList = try context.fetch(request)
                dataList = getUniqueValues(source: dataList)
            } catch {
                print("Error while fetching data: \(error)")
            }
        }
    func getUniqueValues<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
            var buffer = [T]()
            var added = Set<T>()
            for element in source {
                if !added.contains(element) {
                    buffer.append(element)
                    added.insert(element)
                }
            }
            return buffer
        }
        
    
    
    // MARK: Filtering methods
    
    fileprivate func filter() {
        let predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", self.text!)
        let request : NSFetchRequest<Cities> = Cities.fetchRequest()
        request.predicate = predicate

        loadItems(withRequest : request)
        
        resultsList = []
        
        for i in 0 ..< dataList.count {
            
            let item = SearchItem(cityName: dataList[i].cityName!)

            let cityFilterRange = (item.cityName as NSString).range(of: text!, options: .caseInsensitive)
            
                
            if cityFilterRange.location != NSNotFound {
                item.attributedCityName = NSMutableAttributedString(string: item.cityName)
                
                
                item.attributedCityName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: cityFilterRange)
               
                resultsList.append(item)
            }
            
        }
        
        tableView?.reloadData()
    }
    func getCityData(selectedCity:String){
        let predicate = NSPredicate(format: "cityName == %@", selectedCity)
        let request : NSFetchRequest<Cities> = Cities.fetchRequest()
        request.predicate = predicate

        loadCityDetails(withRequest : request)
        
    }
    func loadCityDetails(withRequest request : NSFetchRequest<Cities>) {
        var selectedLat : Double?
        var selectedLon : Double?
        
        do {
            CityDetails = try context.fetch(request)
            for selectedCity in CityDetails{
                selectedLat = Double(selectedCity.lattitude ?? "0")
                selectedLon = Double(selectedCity.longitude ?? "0")
            }
            print("CityDetails: \(CityDetails)")
            let requestforlatlong : NSFetchRequest<Cities> = Cities.fetchRequest()
            do {
                var distanaceArray = [Dictionary<String, Any>]()
                let airports = try context.fetch(requestforlatlong)
                for airport in airports {
                    let lat = Double(airport.lattitude ?? "0")
                    let lon = Double(airport.longitude ?? "0")
                    let coordinate₀ = CLLocation(latitude: selectedLat ?? 0, longitude: selectedLon ?? 0)
                    let coordinate₁ = CLLocation(latitude: lat ?? 0, longitude: lon ?? 0)
                    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                    let distanceInKiloMeters = distanceInMeters/1000
                    if(distanceInKiloMeters<100000){
                        var airportDictionary = Dictionary<String, Any>()
                        airportDictionary["AirportName"]=airport.airportName
                        airportDictionary["CountryName"]=airport.countryName
                        airportDictionary["RunwayLength"]=airport.runway_length
                        airportDictionary["Distance"]=distanceInKiloMeters

                        distanaceArray.append(airportDictionary)
                        
                    }
                }
                let sortedArray = distanaceArray.sorted {
                    (($0 as Dictionary<String, Any>)["Distance"] as? Double ?? 0) < (($1 as Dictionary<String, Any>)["Distance"] as? Double ?? 0)
                }
                print("NearestAirportDetailsArray: \(sortedArray.prefix(5))")
                NearestAirportDetailsArrayManager.shared.airportDetailsArray=sortedArray
//                nearestAirportArray = sortedArray
            } catch let error {
                print(error.localizedDescription)
            }
        } catch {
            print("Error while fetching data: \(error)")
        }
    }
}

extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {

    
    // Create SearchTableview
    func buildSearchTableView() {

        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .white
            self.window?.addSubview(tableView)

        } else {
            //addData()
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(resultsList.count)
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = resultsList[indexPath.row].getFormatedText()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = resultsList[indexPath.row].getStringText()
        tableView.isHidden = true
        self.endEditing(true)
        getCityData(selectedCity: self.text ?? "")
        
    }

    
}
