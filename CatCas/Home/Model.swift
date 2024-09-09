//
//  Model.swift
//  CatCas
//
//  Created by Владимир Кацап on 09.09.2024.
//

import Foundation


struct Game: Codable {
    var place: String
    var amount: Int
    var result: Bool
    var type: String
    var date: String
    var time: String
    
    init(place: String, amount: Int, result: Bool, type: String, date: String, time: String) {
        self.place = place
        self.amount = amount
        self.result = result
        self.type = type
        self.date = date
        self.time = time
    }
    
}
