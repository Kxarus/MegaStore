//
//  AnswerByPhone.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 06.07.2022.
//

import Foundation

struct Answer: Codable {
    let successful: Bool
    let errorMessage, errorMessageCode: String
    let normalizedPhone: String
    let explainMessage: String
}

struct Answer2: Codable {
    let successful: Bool
    let errorMessage, errorMessageCode: String
}
