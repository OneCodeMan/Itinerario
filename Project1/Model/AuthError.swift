//
//  AuthError.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-01.
//

import Foundation
import Firebase

enum AuthError: Error {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case weakPassword
    case unknown
    
    init(authErrorCode: AuthErrorCode.Code) {
        switch authErrorCode {
        case .invalidEmail:
            self = .invalidEmail
        case .wrongPassword:
            self = .invalidPassword
        case .weakPassword:
            self = .weakPassword
        case .userNotFound:
            self = .userNotFound
        default:
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "Email you entered is invalid. Try again."
        case .invalidPassword:
            return "Incorrect password. Try again."
        case .weakPassword:
            return "Password must be at least 6 characters in length. Please try again."
        case .userNotFound:
            return "Looks like there is no user associated with this e-mail."
        default:
            return "Unknown error. Try again."
        }
    }
}

