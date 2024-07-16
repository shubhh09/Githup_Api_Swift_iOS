//
//  HomeModel.swift
//  Shubham_Lodhi_ios
//
//  Created by SHUBHAM on 16/07/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Repository]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let name: String?
    let fullName: String?
    let description: String?
    let htmlURL: String?
    let stargazersCount: Int?
    let language: String?
    let forksCount: Int?
    let createdAt: String?
    let updatedAt: String?
    let pushedAt: String?
    let owner: Owner?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case language
        case forksCount = "forks_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case owner
    }

    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Owner: Codable, Identifiable {
    let id: Int
    let login: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}



// MARK: - License
struct License: Codable {
    let key, name, spdxID: String?
    let url: String?
    let nodeID: String?

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}
