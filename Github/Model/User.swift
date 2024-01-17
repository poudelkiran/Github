//
//  User.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let userName: String
    let avatar: String
    let repoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatar = "avatar_url"
        case id
        case repoUrl = "repos_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try values.decode(String.self, forKey: .userName)
        avatar = try values.decode(String.self, forKey: .avatar)
        id = try values.decode(Int.self, forKey: .id)
        repoUrl = try values.decode(String.self, forKey: .repoUrl)
    }
}

