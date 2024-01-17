//
//  Repo.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 15/01/2024.
//

import Foundation

struct Repo: Codable {
    let id: Int
    let name: String
    let htmlUrl: String
    let stars: Int
    let fork: Bool
    let description: String?
    var languages: LoadingState<Language>
    let languagesUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case htmlUrl = "html_url"
        case stars = "stargazers_count"
        case fork
        case description
        case languagesUrl = "languages_url"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        htmlUrl = try values.decode(String.self, forKey: .htmlUrl)
        stars = try values.decode(Int.self, forKey: .stars)
        fork = try values.decode(Bool.self, forKey: .fork)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        languages = .idle
        languagesUrl = try values.decode(String.self, forKey: .languagesUrl)
    }
}

