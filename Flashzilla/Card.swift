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
        case prompt, answer
    }
    
    var prompt: String
    var answer: String
    
    init(prompt: String, answer: String) {
        self.prompt = prompt
        self.answer = answer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decode(String.self, forKey: .prompt)
        answer =  try container.decode(String.self, forKey: .answer)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(answer, forKey: .answer)
    }
    
    
}
