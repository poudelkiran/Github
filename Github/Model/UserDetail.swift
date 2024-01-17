//
//  UserDetail.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 13/01/2024.
//

import Foundation

struct UserDetail: Codable, Equatable, Identifiable {
    let id: Int
    let userName: String
    let avatar: String
    let name: String
//    let email: String
    let followers: Int
    let following: Int
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatar = "avatar_url"
        case id
        case name
//        case email
        case followers
        case following
        case reposUrl = "repos_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try values.decode(String.self, forKey: .userName)
        avatar = try values.decode(String.self, forKey: .avatar)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
//        email = try values.decode(String.self, forKey: .email)
        followers = try values.decode(Int.self, forKey: .followers)
        following = try values.decode(Int.self, forKey: .following)
        reposUrl = try values.decode(String.self, forKey: .reposUrl)

    }
}
