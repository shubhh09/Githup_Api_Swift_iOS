//
//  HomeViewModel.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var currentPage: Int = 1
    private var canLoadMorePages = true
    
    private let gitHubAPI = WebService()
    private var cancellables = Set<AnyCancellable>()
    
    func searchRepositories(query: String) {
        guard !isLoading, canLoadMorePages else { return }
        
        isLoading = true
        errorMessage = nil
        
        var dict = Dictionary<String, Any>()
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.errorMessage = "Invalid Query"
            return
        }
        
        dict = [
        "q": "\(encodedQuery)",
        "per_page": "10",
        "page": "\(currentPage)"
        ]
        
        gitHubAPI.searchRepositories(param: dict) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let newRepositories):
                    if newRepositories.isEmpty {
                        self.canLoadMorePages = false
                    } else {
                        self.repositories.append(contentsOf: newRepositories)
                        self.currentPage += 1
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func resetSearch() {
        repositories = []
        currentPage = 1
        canLoadMorePages = true
    }
}
