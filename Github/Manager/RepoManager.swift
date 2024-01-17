//
//  RepoManager.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 17/01/2024.
//

import Foundation
import Combine

class RepoManager {
    static let shared = RepoManager()

    private let apiManager = APIManager.shared

    private init() {}
    
    func fetchRepoList(url: String) -> AnyPublisher<([Repo], Pagination?), Error> {

        if let url = URL(string: url) {
            let (baseURL, pathWithQuery) = url.extractComponents()
                return apiManager.fetchData(UserRouter.repoList(pathWithQuery ?? ""), baseUrl: baseURL ?? "")

        }
        
        let customResult: AnyPublisher<([Repo], Pagination?), Error> = Just(([Repo](), nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        
        return customResult
    }


    func fetchNextRepos(url: String) -> AnyPublisher<([Repo], Pagination?), Error> {

        if let url = URL(string: url) {
            let (baseURL, pathWithQuery) = url.extractComponents()
                return apiManager.fetchData(UserRouter.repoList(pathWithQuery ?? ""), baseUrl: baseURL ?? "")

        }
        
        let customResult: AnyPublisher<([Repo], Pagination?), Error> = Just(([Repo](), nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        
        return customResult
    }

    func fetchDevelopmentLanguage(userName: String, repoName: String) -> AnyPublisher<(Language, Pagination?), Error> {
        return apiManager.fetchData(UserRouter.developmentLanguage(userName, repoName))
    }
}
