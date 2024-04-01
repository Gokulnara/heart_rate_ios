//
//  PulseModel.swift
//  HeartRate
//
//  Created by Haris Madhavan on 02/02/24.
//

import Foundation

// MARK: - PulseModel
// MARK: - PulseModel
struct PulseModel: Codable {
    var status, message, id, date: String?
    var details: [PulseDetail]?
    var pulses: [String]?
}

// MARK: - Detail
struct PulseDetail: Codable {
    var pid, pulse, level, originalDate: String?
    var dateOnly, timeOnly: String?

    enum CodingKeys: String, CodingKey {
        case pid, pulse, level
        case originalDate = "original_date"
        case dateOnly = "date_only"
        case timeOnly = "time_only"
    }
}

