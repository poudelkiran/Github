//
//  DetailViewModel.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import Foundation

class DetailViewModel: BaseViewModel {
    /// holds information of current user
    let user: User
    
    /// holds state of user deatil
    @Published var userDetail: LoadingState<UserDetail> = .idle
    
    /// holds state of the list of repositories
    @Published var repos: LoadingState<[Repo]> = .idle
    
    /// hods state of the pagination of the repository
    @Published var reposPaginationState: LoadingState<[Repo]> = .idle
    
    init(user: User) {
        self.user = user
        super.init()
        fetchUserDetail()
        getRepoList()
    }
    
    // Only show repoositories which are not forked
    func filteroutForkedRepo(repoList: [Repo]) -> [Repo] {
        return repoList.filter({!$0.fork})
    }
    
    
    /// update lanuage of the repo
    /// - Parameters:
    ///   - repo: repo whose language needs to be updated
    ///   - languages: languae to update. Passed nil in lagnuage if there is any error during fetch
    ///   - error: error during fetch. Passed nil if there is no error
    func updateRepoLanguage(of repo: Repo, to languages: Language? = nil, error: Error? = nil) {
        if case .loaded(var repos, let pagination) = self.repos {
            if let index = repos.firstIndex(where: { $0.id == repo.id }) {
                if let languages = languages {
                    repos[index].languages = .loaded(languages, nil)
                } else {
                    repos[index].languages = .error(error!)
                }
                
                self.repos = .loaded(repos, pagination)
            }
        }
        
    }
    
    /// Fetch detail of user based ont he user name
    func fetchUserDetail() {
        userDetail = .loading
        UserManager.shared.fetchUserDetail(userName: user.userName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let error):
                    self.userDetail = .error(error)
                }
                
            } receiveValue: { (result) in
                let (detail, _) = result
                self.userDetail = .loaded(detail, nil)
            }.store(in: &bag)
    }
    
    /// fetch list of repositories based on the repo url of the user
    func getRepoList() {
        repos = .loading
        RepoManager.shared.fetchRepoList(url: user.repoUrl)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break;
                case .failure(let error):
                    self.repos = .error(error)
                }
                
            } receiveValue: { (result) in
                let (repoList, pagination) = result
                
                self.repos = .loaded(self.filteroutForkedRepo(repoList: repoList), pagination)
            }.store(in: &bag)
    }
    
    /// fetch more repos from API if users repo's header  has next page url to fetch more repos
    /// - Parameters:
    ///   - nextPageUrl: url of to fetch for the next page repo
    ///   - existingRepos: list of existing repo to append with new repo
    func loadMoreRepos(nextPageUrl: String, existingRepos: [Repo] = []) {
        switch reposPaginationState {
        case .loading:
            break;
        default:
            reposPaginationState = .loading
            RepoManager.shared.fetchNextRepos(url:nextPageUrl)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break;
                    case .failure(let error):
                        self.reposPaginationState = .error(error)
                    }
                    
                } receiveValue: { (result) in
                    let (repos, pagination) = result
                    let newRepos = existingRepos + self.filteroutForkedRepo(repoList: repos)
                    self.repos = .loaded(newRepos, pagination)
                    self.reposPaginationState = .loaded(repos, pagination)
                }.store(in: &bag)
        }
    }
    
    /// Fetch development language of the repo
    /// - Parameter repo: repo whose language needs to be fetched
    func fetchDevelopmentLanguage(repo: Repo) {
        switch repo.languages {
        case .idle:
            RepoManager.shared.fetchDevelopmentLanguage(userName: user.userName, repoName: repo.name )
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                        
                    case .failure(let error):
                        self.updateRepoLanguage(of: repo, error: error)
                    default: break
                    }
                    
                } receiveValue: { (result) in
                    let (languages, _) = result
                    self.updateRepoLanguage(of: repo, to: languages)
                }.store(in: &bag)
        default: break
        }
    }
}
