//
//  WebService.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import Foundation
import Alamofire

enum CustomError: Error {
    case error(String)
}


class WebService {
    func searchRepositories(param: Dictionary<String, Any>, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let urlString = Constant.BaseUrl + Constant.search_Repository
        
        AF.request(urlString,parameters: param).responseData { response in
            switch response.result {
            case .success(let data):
                print("🌀 response code: ",response.response?.statusCode ?? -1)
                if let rawDataString = String(data: data, encoding: .utf8) {
                                    print("🌀 Raw Data: \(rawDataString)")
                                }
                do {
                    let decoder = JSONDecoder()
                    
                    let welcome = try decoder.decode(Welcome.self, from: data)
                    print("🌀 totalCount: \(welcome.totalCount ?? 0)")
                    completion(.success(welcome.items ?? []))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
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
                    
                    let welcome = try decoder.decode(Contributors.self, from: data)
                    print("🌀 totalCount: \(welcome.count)")
                    completion(.success(welcome))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
