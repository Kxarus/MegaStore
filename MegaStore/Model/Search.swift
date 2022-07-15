//
//  Search.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 08.07.2022.
//

import Foundation

struct Search: Codable {
    let successful: Bool
    let errorMessage, errorMessageCode: String
    let campaigns: [Campaign?]
    let products: [Product?]
    let more, moreCampaigns: Bool?
}

struct Campaign: Codable {
    let id: Int?
    let name: String?
    let cashback: String?
    let actions: [Action?]
    let imageURL: String?
    let paymentTime: String?
}

struct Action: Codable {
    let value: String
    let text: String
}

struct Product: Codable {
    let id: Int?
    let name: String?
    let cashback: String?
    let actions: [Action?]
    let imageUrls: [String?]
    let price: String?
    let campaignName: String?
    let campaignImageURL: String?
    let paymentTime: String?

}
