//
//  Product.swift
//  07_08_2023_WebServicesDemo3
//
//  Created by Vishal Jagtap on 18/10/23.
//

import Foundation
struct Product{
    var id : Int
    var title : String
    var price : Double
//    var description : String
//    var category : String
//    var image : String
    var rating : Rating
}

struct Rating{
    var rate : Double
    var count : Int
}
