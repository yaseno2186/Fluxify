//
//  Lesson.swift
//  Fluxify
//
//  Created by TA638 on 17.01.26.
//

import Foundation
import SwiftUI

enum Subject: String, Codable {
    case wärmelere
    case eletromeganismus
    case optik
    case mechanik
}

enum TaskType: String, Codable {
    case dragAndDrop // The "Fridge" style
    case multipleChoice
    case assembly // Putting parts together
}

struct Lesson: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let subject: Subject
    let tasks: [Task]
    var isCompleted: Bool = false
    var isLocked: Bool = true
    let coordinate: CGPoint // Position on the "Galaxy Map"
}

struct Task: Identifiable, Codable {
    let id: UUID
    let question: String
    let type: TaskType
    let items: [TaskItem] // Items to drag, or choices
    let correctArrangement: [UUID]? // For drag and drop, the order or matching IDs
    let explanation: String // Why the answer is what it is
}

struct TaskItem: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String // Text or Image Name
    let isImage: Bool
    var targetZoneId: UUID? // If matching to a specific zone
}
