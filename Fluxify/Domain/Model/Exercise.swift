//
//  Exercise.swift
//  Fluxify
//
//  Created by TA638 on 17.01.26.
//

import Foundation

enum ExerciseType {
    case multipleChoice
    case trueFalse
    case matching
    case dragDrop
}

enum DifficultyLevel {
    case easy
    case medium
    case hard
    
    var description: String {
        switch self {
        case .easy:
            return "Einfach"
        case .medium:
            return "Mittel"
        case .hard:
            return "Schwer"
        }
    }
}

// MARK: - Multiple Choice Exercise
struct MultipleChoiceExercise: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let difficulty: DifficultyLevel
    let imageURL: String? = nil  // Optional image URL
    
    var correctAnswer: String {
        options[correctAnswerIndex]
    }
}

// MARK: - True/False Exercise
struct TrueFalseExercise: Identifiable {
    let id = UUID()
    let statement: String
    let isTrue: Bool
    let explanation: String
    let difficulty: DifficultyLevel
    let imageURL: String? = nil  // Optional image URL
}

// MARK: - Matching Exercise
struct MatchingPair: Identifiable {
    let id = UUID()
    let left: String
    let right: String
}

struct MatchingExercise: Identifiable {
    let id = UUID()
    let instruction: String
    let pairs: [MatchingPair]
    let explanation: String
    let difficulty: DifficultyLevel
    let imageURL: String? = nil  // Optional image URL
}

// MARK: - Drag & Drop Exercise
struct DragDropOption: Identifiable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

struct DragDropExercise: Identifiable {
    let id = UUID()
    let question: String
    let dropZones: [String] // e.g., ["___", "___", "___"]
    let options: [DragDropOption]
    let explanation: String
    let difficulty: DifficultyLevel
    let imageURL: String? = nil  // Optional image URL
}

// MARK: - Lesson
struct Lesson: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let difficulty: DifficultyLevel
    let sourceInfo: String // e.g., "Quelle: Physik-Lehrbuch"
    let imageURL: String? = nil  // Optional header image
    
    let multipleChoiceExercises: [MultipleChoiceExercise]
    let trueFalseExercises: [TrueFalseExercise]
    let matchingExercises: [MatchingExercise]
    let dragDropExercises: [DragDropExercise]
    
    var allExercisesCount: Int {
        multipleChoiceExercises.count + trueFalseExercises.count + 
        matchingExercises.count + dragDropExercises.count
    }
}

// MARK: - User Progress
struct LessonProgress: Identifiable {
    let id = UUID()
    var lessonId: UUID
    var completedExercises: Int = 0
    var totalExercises: Int
    var correctAnswers: Int = 0
    var xpEarned: Int = 0
    var isCompleted: Bool = false
    
    var progressPercentage: Double {
        totalExercises > 0 ? Double(completedExercises) / Double(totalExercises) : 0
    }
    
    var accuracy: Double {
        completedExercises > 0 ? Double(correctAnswers) / Double(completedExercises) : 0
    }
}
