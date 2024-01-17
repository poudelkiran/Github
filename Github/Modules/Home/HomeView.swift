//
//  HomeView.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    /// view model
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack{
                content
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack{
                                Image(Images.github).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                                Text("Github")
                            }
                            
                        }
                    }
            }
            
        }
        
    }
    
    
    /// View for homeview
    @ViewBuilder private var content: some View {
        switch viewModel.users {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView().scaleEffect(2.0)
        case .loaded(let users, let pagination):
            loadedView(users: users, pagination: pagination)
        case  .error(let error):
            ErrorView(error: error, retryAction: {
                viewModel.fetchUsers()
            })
        }
    }
    
    
    /// List view when users is fetched from the API
    /// - Parameters:
    ///   - users: fetched user from API
    ///   - header: information regarding pagination
    /// - Returns: list view
    func loadedView(users: [User], pagination: Pagination?) -> some View {
        List {
            ForEach(users, id: \.id) { user in
                NavigationLink(destination: DetailView(user: user)) {
                    UserListCell(user: user)
                }
            }
            
            lastRowView(paginationData: pagination, existingUsers: users)
        }.refreshable {
            viewModel.fetchUsers()
        }
        
    }
    
    /// Last view of list based on the pagination data. Calls API to fetch new user, if it exists
    /// - Parameters:
    ///   - paginationData: paginated data to identify state
    ///   - existingUsers: current list of users
    /// - Returns: returns progress view, if new user is fetching, error view if there is any error and empty view otherwise
    func lastRowView(paginationData: Pagination?, existingUsers: [User]) -> some View {
        return ZStack(alignment: .center) {
            switch (viewModel.paginationState) {
            case .idle:
                EmptyView()
            case .loaded(_, _) :
                EmptyView()
            case .error(let error):
                ErrorView(error: error, retryAction: nil)
            case .loading:
                ProgressView().frame(maxWidth: .infinity)
            }
        }
        .onAppear{
            if let nextPageUrl = paginationData?.nextPageUrl, !nextPageUrl.isEmpty {
                self.viewModel.loadMoreUsers(nextPageUrl: nextPageUrl, existingUsers: existingUsers)
                
            }
        }
    }
}


