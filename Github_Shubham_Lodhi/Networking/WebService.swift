//
//  ApiImplementation.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import Foundation
import Alamofire

class WebService {
    func searchRepositories(param: Dictionary<String, Any>, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let urlString = Constant.BaseUrl + Constant.search_Repository
        
        AF.request(urlString,parameters: param).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    
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
}
