//
//  URL.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 13/01/2024.
//

import Foundation

extension URL {
    /// function to extract the base url and query from the url
    /// - Returns: returns base url and query
    func extractComponents() -> (baseURL: String?, pathWithQuery: String?) {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return (nil, nil)
        }

        let baseURL = components.scheme.flatMap { scheme in
            components.host.map { host in
                "\(scheme)://\(host)"
            }
        }

        let pathWithQuery = components.path + (components.query.map { "?\($0)" } ?? "")

        return (baseURL, pathWithQuery)
    }
}
