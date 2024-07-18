//
//  WebService.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import Foundation
import Alamofire

//    MARK: - Custom Error 
//    MARK:-
enum CustomError: Error {
    case error(String)
}


class WebService {
//    MARK: - for Home View
//    MARK:-
    func searchRepositories(param: Dictionary<String, Any>, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let urlString = Constant.BaseUrl + Constant.search_Repository
        
        AF.request(urlString,parameters: param).responseData { response in
            switch response.result {
            case .success(let data):
                print("🌀 response code: ",response.response?.statusCode ?? -1)
                let status =  response.response?.statusCode ?? -1
                if status ==  200 {
                    do {
                        let decoder = JSONDecoder()
                        
                        let final_data = try decoder.decode(RepositoryData.self, from: data)
                        print("🌀 totalCount: \(final_data.totalCount ?? 0)")
                        completion(.success(final_data.items ?? []))
                    } catch {
                        print("error in success: \(error)")
                        completion(.failure(error))
                    }
                }else{
                    completion(.failure(CustomError.error("response code \(status) \n unable to process")))
                }
            case .failure(let error):
                print("error in failure: \(error)")
                completion(.failure(error))
            }
        }
    }
    
//    MARK: - for Repo Detail View
//    MARK:-
    func searchContributors(url: String, completion: @escaping (Result<Contributors, Error>) -> Void) {
        
        AF.request(url).responseData { response in
            let statusCode = response.response?.statusCode ?? -1
            switch response.result {
            case .success(let data):
                print("🌀 response code: ",response.response?.statusCode ?? -1)
                guard  statusCode == 200  else {
                    completion(.failure(CustomError.error("Oops! Something went wrong")))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    
                    let final_data = try decoder.decode(Contributors.self, from: data)
                    print("🌀 totalCount: \(final_data.count)")
                    completion(.success(final_data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
