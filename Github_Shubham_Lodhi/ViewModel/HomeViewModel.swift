//
//  HomeViewModel.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import Foundation
import Combine
import CoreData

class HomeViewModel: ObservableObject {
    
    //MARK: - Data Binding
    //MARK:-
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isNetwork: Bool = false
    
    //MARK: - Local Var
    //MARK:-
    private var currentPage: Int = 1
    private var canLoadMorePages = true
    
    private let gitHubAPI = WebService()
    private let persistenceController = PersistenceController.shared
    
    //    MARK: - Sarch Repository by query
    //    MARK:-
    func searchRepositories(query: String) {
        guard !isLoading, canLoadMorePages else {return}
        
        guard NetworkReachabilityManager.shared.isConnectedToNetwork else {
            isNetwork = false
            loadRepositoriesFromCoreData()
            return
        }
        
        isNetwork = true
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
                        self.saveRepositoriesToCoreData(repositories: self.repositories)
                    }
                case .failure(let error):
                    self.errorMessage = self.parseErrorMessage(error)
                    
                }
            }
        }
    }
    
    //    MARK: - Parse Error
    //    MARK:-
    private func parseErrorMessage(_ error: Error) -> String {
        if let customError = error as? CustomError {
            switch customError {
            case .error(let message):
                return message
            }
        }
        return error.localizedDescription
    }
    
    func resetSearch() {
        repositories = []
        currentPage = 1
        canLoadMorePages = true
    }
}

//    MARK: - Core Data
//    MARK:-
extension HomeViewModel {
    //    MARK: - Save data for offline usage
    //    MARK:-
    private func saveRepositoriesToCoreData(repositories: [Repository]) {
        let viewContext = persistenceController.container.viewContext
        viewContext.performAndWait {
            persistenceController.deleteAllData()
            repositories.prefix(15).forEach { repository in
                let entity = RepositoryEntity(context: viewContext)
                entity.name = repository.name
                entity.descriptionRepo = repository.description
                entity.ids = Int64(repository.id)
                entity.contributors_url = repository.contributorsURL
                entity.full_name = repository.fullName
                entity.html_url = repository.htmlURL
            }
            do {
                try viewContext.save()
            } catch {
                print("Failed to save repositories to Core Data: \(error)")
            }
        }
    }
    
    //    MARK: - Fetch Saved Data
    //    MARK:-
    public func loadRepositoriesFromCoreData() {
        let request: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        request.fetchLimit = 15
        
        let viewContext = persistenceController.container.viewContext
        
        do {
            let entities = try viewContext.fetch(request)
            DispatchQueue.main.async {
                self.repositories = entities.compactMap({ entity in
                    guard let name = entity.name, let description = entity.descriptionRepo else {
                        return nil
                    }
                    return  Repository(id: Int(entity.ids), name: name, fullName: entity.full_name ?? nil, description: description, htmlURL: entity.html_url ?? nil, contributorsURL: entity.contributors_url ?? nil, stargazersCount: nil, language: nil, forksCount: nil, createdAt: nil, updatedAt: nil, pushedAt: nil, owner: nil)
                })
            }
        } catch {
            errorMessage = "Failed to load repositories from Core Data: \(error)"
        }
    }
}
