//
//  HomeViewModel.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import Foundation


class HomeViewModel: BaseViewModel {
    
    
    /// holds the state and data of users
    @Published var users: LoadingState<[User]> = .idle
    
    /// holds state and data of pagination state of users
    @Published var paginationState: LoadingState<[User]> = .idle
    
    
    /// holds instance of user manager for API Call
    let userManager = UserManager.shared

    override init() {
        super.init()
        fetchUsers()
    }
    
    /// Fetch list of users from API
    func fetchUsers() {
        users = .loading
        userManager.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let error):
                    self.users = .error(error)
                }

            } receiveValue: { (result) in
                let (users, pagination) = result
                self.users = .loaded(users, pagination)

            }.store(in: &bag)
    }
    
    /// If there is nextPage url, fetch more users
    /// - Parameters:
    ///   - nextPageUrl: url of the next page to fetch for the user
    ///   - existingUsers: list of existing users to append with new users
     func loadMoreUsers(nextPageUrl: String, existingUsers: [User] = []) {
         
        switch paginationState {
        case .loading:
            break;
        default:
            paginationState = .loading
                    userManager.fetchNextUsers(url:nextPageUrl)
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            switch completion {
                            case .finished:
                                break;
                            case .failure(let error):
                                self.paginationState = .error(error)
                            }
            
                        } receiveValue: { (result) in
                            let (users, pagination) = result
                            self.users = .loaded(existingUsers + users, pagination)
                            self.paginationState = .loaded(users, pagination)
                        }.store(in: &bag)
        }

    }
}
