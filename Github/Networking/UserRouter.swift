//
//  UserRouter.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 13/01/2024.
//

import Foundation

enum UserRouter: APICall {
    
    case users
    case detail(String)
    case nextUsers(String)
    case repoList(String)
    case developmentLanguage(String, String)
    
    var path: String {
        switch self {
        case .users: return "/users"
        case .detail(let userName): return "/users/"+userName
        case .nextUsers(let url), .repoList(let url): return url
        case .developmentLanguage(let userName, let repoName):
            return "/repos/\(userName)/\(repoName)/languages"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return HTTPMethod.get
        }
    }
    
    var headers: [String : String]? {
        assert(!Config.token.isEmpty, "Add your github token in Config.token")
        return [
            "Accept": "application/json",
            "Authorization": Config.token
        ]
    }
    
    func body() throws -> Data? {
        switch self {
        default: return nil
        }
    }
}
