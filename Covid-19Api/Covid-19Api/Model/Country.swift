//
//  Country.swift
//  Covid-19Api
//
//  Created by Furkan Hanci on 6/29/21.
//

import Foundation


struct Country : Codable {
    
    var country : String
    var updated: Double
    var cases : Double
    var active : Double
    var recovered : Double
    var countryInfo : CountryInfo
    
}

struct CountryInfo : Codable {
    
    var _id: Int
    var iso2: String
    var iso3 : String
    var lat : Int
    var long : Int
    var flag : String
    
}
