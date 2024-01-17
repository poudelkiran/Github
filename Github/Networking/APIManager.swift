//
//  APIManager.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 13/01/2024.
//

import Foundation
import Combine

class APIManager {
    static let shared = APIManager() // Singleton instance

    static let baseURL = "https://api.github.com"

    private init() {}

    func fetchData<T: Decodable>(_ call: APICall, baseUrl: String = APIManager.baseURL) -> AnyPublisher<(T, Pagination?), Error> {
        do {
            let request = try call.urlRequest(baseURL: APIManager.baseURL)
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let httpResponse = output.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    let link = httpResponse.value(forHTTPHeaderField: "Link")

                    let pagination = self.getPaginationInfo(link: link)
                    
                    
                    return (try JSONDecoder().decode(T.self, from: output.data), pagination)
                }

                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func getPaginationInfo(link: String?) -> Pagination {
        guard let link else { return Pagination(nextPageUrl: "")}
        let links = link.components(separatedBy: ",")

        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:"; ")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
            dictionary[components[1]] = cleanPath
        })
        
        if let nextPagePath = dictionary["rel=\"next\""] {
            return Pagination(nextPageUrl: nextPagePath)
        }

        return Pagination(nextPageUrl: "")
    }
}

