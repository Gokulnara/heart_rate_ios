//
//  Model.swift
//  HeartRate
//
//  Created by Haris Madhavan on 25/01/24.
//

import Foundation

struct LoginModel: Codable {
    var status, message, userID: String?
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case userID = "user_id"
    }
}
