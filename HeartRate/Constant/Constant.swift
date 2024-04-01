//
//  Constant.swift
//  HeartRate
//
//  Created by Haris Madhavan on 25/01/24.
//

import Foundation

struct Constant {
    
    struct Domain {
        static let domain = "https://zoop.me/"
    }
    
    struct Routes {
        static let routes = "/site/hr/"
    }
    
    static let BaseURL = Domain.domain + Routes.routes
    
    static let loginURL = BaseURL + "login.php"
    static let signupURL = BaseURL + "signup.php"
    static let detailsURL = BaseURL + "health_details.php"
    static let profileURL = BaseURL + "profile.php"
    static let pulseSaveURL = BaseURL + "pulse_save.php"
    static let pulseDetailsURL = BaseURL + "pulse_details.php"
}
