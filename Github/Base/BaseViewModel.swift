//
//  BaseViewModel.swift
//  Github
//
//  Created by FMI-PC-LT-48 on 12/01/2024.
//

import Foundation
import Combine

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T, Pagination?)
    case error(Error)
}

class Pagination {
    var nextPageUrl: String = ""
    
    init(nextPageUrl: String) {
        self.nextPageUrl = nextPageUrl
    }
}


class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
    init() {
        print("Initialized --> \(String(describing: self))")
    }
    
    deinit {
        debugPrint("De-Initialized --> \(String(describing: self))")
    }
}
