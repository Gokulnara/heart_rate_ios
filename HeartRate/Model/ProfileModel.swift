//
//  ProfileModel.swift
//  HeartRate
//
//  Created by Haris Madhavan on 31/01/24.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    var status, message: String?
    var details: [Detail]?
}

// MARK: - Detail
struct Detail: Codable {
    var id, username, email, age: String?
    var height, weight, gender: String?
}
