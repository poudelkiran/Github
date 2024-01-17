//
//  UserManager.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 13/01/2024.
//

import Foundation
import Combine

class UserManager {
    static let shared = UserManager()

    private let apiManager = APIManager.shared

    private init() {}
    
    func fetchUsers() -> AnyPublisher<([User], Pagination?), Error> {
        return apiManager.fetchData(UserRouter.users)
    }
    
    func fetchNextUsers(url: String) -> AnyPublisher<([User], Pagination?), Error> {
        if let url = URL(string: url) {
            let (baseURL, pathWithQuery) = url.extractComponents()
                return apiManager.fetchData(UserRouter.nextUsers(pathWithQuery ?? ""), baseUrl: baseURL ?? "")

        }
        
        let customResult: AnyPublisher<([User], Pagination?), Error> = Just(([User](), nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        
        return customResult
    }
    
    func fetchUserDetail(userName: String) -> AnyPublisher<(UserDetail, Pagination?), Error> {
                return apiManager.fetchData(UserRouter.detail(userName))
    }
}
