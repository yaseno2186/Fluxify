// Created By Yass

import Foundation

struct User: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var password: String
    var username: String
    var streak: Int = 0
    var league: String = "Bronze"
    var savedTasks: [Task] = []
    var lessonProgress: [LessonProgress] = [] // Add this
}

//password decoding example
extension User {
    func isPasswordValid(inputPassword: String) -> Bool {
        return inputPassword == password
    }
}

// Add this struct to User.swift
struct LessonProgress: Identifiable, Codable {
    var id = UUID()
    let lessonTitle: String
    var completedTasks: Int
    var totalTasks: Int
    
    var progress: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
}
