//
//  SearchItem.swift
//  CustomSearchField
//
//  Created by Emrick Sinitambirivoutin on 20/02/2019.
//  Copyright © 2019 Emrick Sinitambirivoutin. All rights reserved.
//

import Foundation

class SearchItem {
    var attributedCityName: NSMutableAttributedString?
    var allAttributedName : NSMutableAttributedString?
    
    var cityName: String

    public init(cityName: String) {
        self.cityName = cityName
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        allAttributedName!.append(attributedCityName!)
        
        
        return allAttributedName!
    }
    
    public func getStringText() -> String{
        return "\(cityName)"
    }

}
