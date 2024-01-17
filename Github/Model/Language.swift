//
//  Language.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 17/01/2024.
//

struct Language: Decodable {
    let name: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let languageContainer = try container.decode(Dictionary<String, Int>.self)
        self.name = languageContainer.map({$0.key})
    }
}
