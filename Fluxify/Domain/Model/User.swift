//
//  User.swift
//  Fluxify
//
//  Created by TA638 on 17.01.26.
//

import Foundation

struct User: Codable{
    let uid: UUID
    var Email: String
    var streakDays: Int?
    var FirstName: String?
    var LastName: String?
    var username: String
    var phone: String?
}
