//
//  UserViewModel.swift
//  Fluxify
//
//  Created by Yass on 15.02.26.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var lessonProgress: [LessonProgress] = []
    
    static let shared = UserViewModel()
    
    private init() {
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        BackendService.shared.fetchUserProfile { [weak self] user in
            DispatchQueue.main.async {
                self?.user = user
                self?.lessonProgress = user?.lessonProgress ?? []
            }
        }
    }
    
    func getProgress(for lessonTitle: String) -> Double {
        return lessonProgress.first { $0.lessonTitle == lessonTitle }?.progress ?? 0
    }
    
    func updateProgress(lessonTitle: String, completedTasks: Int, totalTasks: Int) {
        if let index = lessonProgress.firstIndex(where: { $0.lessonTitle == lessonTitle }) {
            lessonProgress[index].completedTasks = completedTasks
        } else {
            lessonProgress.append(LessonProgress(
                lessonTitle: lessonTitle,
                completedTasks: completedTasks,
                totalTasks: totalTasks
            ))
        }
        // Save to backend/UserDefaults in real app
    }
}
