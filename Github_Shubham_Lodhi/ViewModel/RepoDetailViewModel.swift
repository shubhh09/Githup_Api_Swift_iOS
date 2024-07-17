//
//  RepoDetailViewModel.swift
//  Github_Shubham_Lodhi
//
//  Created by SHUBHAM on 17/07/24.
//

import Foundation
import Combine

class RepoDetailViewModel: ObservableObject{
    
    @Published var contributors:Contributors = []
    @Published var isloading = false
    @Published var errorMessage:String?
    
    private let gitHubAPI = WebService()
    
    func fetechContributors(url: String){
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
                    errorMessage = err.localizedDescription
                }
            }
        }
    }
}
