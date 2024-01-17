//
//  DetailView.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import SwiftUI

struct DetailView: View {
    
    /// view model
    @StateObject private var viewModel: DetailViewModel
    
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(user: user))
    }
    
    var body: some View {
        VStack{
            header
            Spacer()
            content
            Spacer()
        }
    }
    
    /// header view
    @ViewBuilder private var header: some View {
        VStack {
            Circle()
                .stroke(.gray.opacity(0.35), lineWidth: 2)
                .frame(width: 64, height: 64)
                .overlay(
                    
                    AsyncImage(url: URL(string: viewModel.user.avatar)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            Image(Images.github).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                            
                        } else {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                    }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle()))
            
            Text(viewModel.user.userName)
            
            personalInformationContainerView
        }
    }
    
    
    
    /// view that displays name of user with number of followers and followings
    @ViewBuilder private var personalInformationContainerView: some View {
        VStack {
            switch viewModel.userDetail {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 50)
            case .loaded(let detail, _):
                VStack(spacing: 10) {
                    Text(detail.name)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .fontWidth(Font.Width.compressed)
                    
                    HStack(spacing: 50) {
                        VStack(spacing: 4){
                            Text("FOLLOWERS")
                                .foregroundColor(.mint)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                            
                            Text(String(detail.followers)).fontWeight(.semibold)
                        }
                        
                        VStack(spacing: 4){
                            Text("FOLLOWING")   .foregroundColor(.mint)
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                            Text(String(detail.following)).fontWeight(.semibold)
                        }
                        
                        
                    }
                }.frame(maxWidth: .infinity).padding([.vertical], 10)
            case .error(let error):
                ErrorView(error: error, retryAction: {
                    viewModel.fetchUserDetail()
                }).padding(20)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                .padding([.leading, .trailing], 10)
        )
        .padding()
    }
    
    
    @ViewBuilder private var personalInformationView: some View {
        switch (viewModel.userDetail) {
        case .loading, .idle:
            ProgressView()
        case .loaded(let detail, _):
            VStack {
                Text(detail.name)
                HStack {
                    Text("Followers")
                    Spacer()
                    Text("Following")
                }
            }
            
            
        case .error(let error):
            MessageView(message: error.localizedDescription)
        }
    }
    
    /// content View
    @ViewBuilder private var content: some View {
        switch viewModel.repos {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView().scaleEffect(2.0)
        case .loaded(let repos, let pagination):
            loadedView(repos: repos, pagination: pagination)
        case  .error(let error):
            ErrorView(error: error, retryAction: {
                viewModel.getRepoList()
            })
        }
    }
    
    func loadedView(repos: [Repo], pagination: Pagination?) -> some View {
        if repos.isEmpty {
            return AnyView(MessageView(message: "No non-forked repos found"))
        } else {
            
            
            return AnyView(List {
                ForEach(repos, id: \.id) { repo in
                    NavigationLink(destination: LoadingWebView(url: URL(string: repo.htmlUrl))) {
                        ReposListCell(repo: repo)
                            .onAppear{
                                viewModel.fetchDevelopmentLanguage(repo: repo)
                            }
                    }
                }
                
                lastRowView(paginationData: pagination, existingRepos: repos)
                
                
            }.refreshable {
                viewModel.getRepoList()
            })
        }
        
    }
    
    /// last row view for the repo
    /// - Parameters:
    ///   - paginationData: paginated data
    ///   - existingRepos: existing repo to append with new repo
    /// - Returns: returns either progress view, error view or empty view based on the loading contitions
    func lastRowView(paginationData: Pagination?, existingRepos: [Repo]) -> some View {
        return ZStack(alignment: .center) {
            switch (viewModel.reposPaginationState) {
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
                self.viewModel.loadMoreRepos(nextPageUrl:  nextPageUrl, existingRepos: existingRepos)
                
            }
        }
    }
    
}
