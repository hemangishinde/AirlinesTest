//
//  CodingUserInfoKey+Util.swift
//  GoogleMapTest
//
//  Created by Admin on 06/02/21.
//

import Foundation
public extension CodingUserInfoKey {
  // Helper property to retrieve the Core Data managed object context
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
