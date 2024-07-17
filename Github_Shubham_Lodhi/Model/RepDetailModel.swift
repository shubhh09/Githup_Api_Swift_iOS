//
//  RepDetailModel.swift
//  Github_Shubham_Lodhi
//
//  Created by SHUBHAM on 17/07/24.
//

import Foundation

// MARK: - Contributor
struct Contributor: Codable, Identifiable, Equatable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: UserType?
    let siteAdmin: Bool?
    let contributions: Int?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case contributions
    }

    // Custom initializer to handle decoding errors in type field
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decodeIfPresent(String.self, forKey: .login)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.nodeID = try container.decodeIfPresent(String.self, forKey: .nodeID)
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        self.gravatarID = try container.decodeIfPresent(String.self, forKey: .gravatarID)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.htmlURL = try container.decodeIfPresent(String.self, forKey: .htmlURL)
        self.followersURL = try container.decodeIfPresent(String.self, forKey: .followersURL)
        self.followingURL = try container.decodeIfPresent(String.self, forKey: .followingURL)
        self.gistsURL = try container.decodeIfPresent(String.self, forKey: .gistsURL)
        self.starredURL = try container.decodeIfPresent(String.self, forKey: .starredURL)
        self.subscriptionsURL = try container.decodeIfPresent(String.self, forKey: .subscriptionsURL)
        self.organizationsURL = try container.decodeIfPresent(String.self, forKey: .organizationsURL)
        self.reposURL = try container.decodeIfPresent(String.self, forKey: .reposURL)
        self.eventsURL = try container.decodeIfPresent(String.self, forKey: .eventsURL)
        self.receivedEventsURL = try container.decodeIfPresent(String.self, forKey: .receivedEventsURL)
        self.siteAdmin = try container.decodeIfPresent(Bool.self, forKey: .siteAdmin)
        self.contributions = try container.decodeIfPresent(Int.self, forKey: .contributions)
        
        // Decode type as String first to handle unexpected enum values gracefully
        if let typeString = try container.decodeIfPresent(String.self, forKey: .type) {
            self.type = UserType(rawValue: typeString)
        } else {
            self.type = nil
        }
    }
    
    static func == (lhs: Contributor, rhs: Contributor) -> Bool {
        lhs.id == rhs.id
    }
}

// Enum to represent contributor type with fallback for unknown cases
enum UserType: String, Codable {
    case user = "User"
    case organization = "Organization"
    case unknown // Placeholder for any other unknown cases
    
    init(rawValue: String) {
        switch rawValue {
        case "User":
            self = .user
        case "Organization":
            self = .organization
        default:
            self = .unknown
        }
    }
}

typealias Contributors = [Contributor]
