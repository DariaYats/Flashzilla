//
//  Card.swift
//  Flashzilla
//
//  Created by Дарья Яцынюк on 08.07.2024.
//

import Foundation
import SwiftData

@Model
class Card: Codable {
    enum CodingKeys: CodingKey {
        case promt, answer
    }
    
    var promt: String
    var answer: String
    
    init(promt: String, answer: String) {
        self.promt = promt
        self.answer = answer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        promt = try container.decode(String.self, forKey: .promt)
        answer =  try container.decode(String.self, forKey: .answer)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(promt, forKey: .promt)
        try container.encode(answer, forKey: .answer)
    }
    
    
}
