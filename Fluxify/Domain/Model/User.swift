//
//  User.swift
//  Fluxify
//
//  Created by TA638 on 17.01.26.
//

import Foundation

struct User: Codable {
    let uid: UUID
    var username: String
    var streakDays: Int?
    var league: String
    var email: String
    var FirstName: String?
    var LastName: String?
    var phone: String?
    var completedLessons: [UUID]
}
 
