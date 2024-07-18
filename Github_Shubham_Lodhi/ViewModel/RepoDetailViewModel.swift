//
//  RepoDetailViewModel.swift
//  Github_Shubham_Lodhi
//
//  Created by SHUBHAM on 17/07/24.
//

import Foundation
import Combine

class RepoDetailViewModel: ObservableObject{
    
    //MARK: - Data Binding
    //MARK:-
    @Published var contributors:Contributors = []
    @Published var isloading = false
    @Published var errorMessage:String?
    @Published var isNetwork: Bool = false
    
    //MARK: - Local Var
    //MARK:-
    private let gitHubAPI = WebService()
    
    //MARK: - Fetch Contributors Details
    //MARK:-
    func fetechContributors(url: String){
        guard NetworkReachabilityManager.shared.isConnectedToNetwork else {
            isNetwork = false
            return
        }
        isNetwork = true
        isloading = true
        guard url != "" else {return}
        DispatchQueue.main.async {[self] in
            isloading = false
            gitHubAPI.searchContributors(url: url) { [self] result in
                self.isloading = false
                switch result{
                case .success(let data):
                    contributors = data
                    print(contributors.count)
                case .failure(let err):
                    self.errorMessage = self.parseErrorMessage(err)
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
}
