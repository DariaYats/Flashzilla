//
//  Card.swift
//  Flashzilla
//
//  Created by Дарья Яцынюк on 08.07.2024.
//

import Foundation


struct Card: Codable {
    var promt: String
    var answer: String
    
    static let example = Card(promt: "Who played special FBI agent in Twin Peaks", answer: "Kyle Maclachlan")
}
