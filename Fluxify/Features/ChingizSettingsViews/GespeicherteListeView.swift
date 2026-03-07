//
//  GespeicherteListeView.swift
//  Fluxify
//
//  Created by Chingiz on 12.02.26.
//

import SwiftUI
import Foundation
internal import Combine

// MARK: - SavedLessonsManager
class SavedLessonsManager: ObservableObject {
    static let shared = SavedLessonsManager()
    
    @Published var savedLessonTitles: Set<String> = []  // Changed from savedLessonIds
    
    private let userDefaultsKey = "savedLessonTitles"  // Changed key
    
    init() {
        loadSavedLessons()
    }
    
    // Load from UserDefaults
    private func loadSavedLessons() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            savedLessonTitles = decoded  // Changed
        }
    }
    
    // Save to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedLessonTitles) {  // Changed
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Check if a lesson is saved - NOW USES TITLE
    func isSaved(_ lesson: Lesson) -> Bool {
        savedLessonTitles.contains(lesson.title)  // Changed from lesson.id.uuidString
    }
    
    // Toggle save status - NOW USES TITLE
    func toggle(_ lesson: Lesson) {
        let title = lesson.title  // Changed from id.uuidString
        if savedLessonTitles.contains(title) {
            savedLessonTitles.remove(title)
        } else {
            savedLessonTitles.insert(title)
        }
        saveToUserDefaults()
    }
    
    // Add a lesson - NOW USES TITLE
    func add(_ lesson: Lesson) {
        savedLessonTitles.insert(lesson.title)  // Changed
        saveToUserDefaults()
    }
    
    // Remove a lesson - NOW USES TITLE
    func remove(_ lesson: Lesson) {
        savedLessonTitles.remove(lesson.title)  // Changed
        saveToUserDefaults()
    }
    
    // Get all saved lessons from a list
    func getSavedLessons(from lessons: [Lesson]) -> [Lesson] {
        return lessons.filter { isSaved($0) }
    }
}

// MARK: - GespeicherteListeView
struct GespeicherteListeView: View {
    @EnvironmentObject var savedManager: SavedLessonsManager // <-- CHANGE TO @EnvironmentObject
    var allLessons: [Lesson] // Keep this as regular parameter since it comes from viewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    // Get only saved lessons
    private var savedLessons: [Lesson] {
        allLessons.filter { savedManager.isSaved($0) }
    }
    
    // Group saved lessons by category
    private var gruppierteLessons: [LessonCategory: [Lesson]] {
        Dictionary(grouping: savedLessons, by: { $0.category })
    }
    
    // Sorted categories
    private var sortierteKategorien: [LessonCategory] {
        gruppierteLessons.keys.sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .fill(Color.indigo)
                                        .frame(height: 200)
                                        .offset(y: -40)
                                    
                                    VStack(spacing: 0) {
                                        Spacer().frame(height: 25)
                                        HStack {
                                            // Zurück-Button
                                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                                Image(systemName: "chevron.left")
                                                    .font(.title2.bold())
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                                    .background(Color.black.opacity(0.2))
                                                    .clipShape(Circle())
                                            }
                                            .padding(.leading, 16)
                                            Spacer()
                                        }
                                        .frame(height: 50)
                                        .padding(.top, 60)
                                        Spacer()
                                    }
                                    .frame(height: 180)
                                    .overlay(
                                        Text("Gespeichert")
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.top, 40)
                                    )
                                }
                                .frame(height: 160)

                
                // MARK: - Inhalts Bereich
                if savedLessons.isEmpty {
                    // Empty state - nothing saved yet
                    VStack(spacing: 20) {
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("Noch nichts gespeichert")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("Tippe auf das Lesezeichen-Symbol bei einem Gerät, um es hier zu speichern.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 100)
                } else {
                    // Show saved lessons grouped by category
                    LazyVStack(spacing: 25) {
                        ForEach(sortierteKategorien, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 12) {
                                // Category Header
                                Text(category.rawValue.uppercased())
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                
                                // Lessons in this category
                                ForEach(gruppierteLessons[category] ?? []) { lesson in
                                    NavigationLink(destination:
                                        TaskDetailView(viewModel: TasksViewModel(lessonTitle: lesson.title))
                                    ) {
                                        SavedLessonRow(
                                            lesson: lesson
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                }
                
                Spacer(minLength: 50)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Saved Lesson Row with Remove Option
struct SavedLessonRow: View {
    let lesson: Lesson
    @EnvironmentObject var savedManager: SavedLessonsManager // <-- CHANGE TO @EnvironmentObject
    @StateObject private var userVM = UserViewModel.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with category color
            RoundedRectangle(cornerRadius: 12)
                .fill(lesson.category.color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: lesson.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(lesson.category.color)
                )
            
            // Title
            Text(lesson.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress bar
            ProgressBar(
                progress: userVM.getProgress(for: lesson.title),
                color: lesson.category.color
            )
            .frame(width: 60, height: 6)
            
            // Remove button (X)
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    savedManager.remove(lesson)
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red.opacity(0.7))
                    .padding(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
        )
    }
}

struct GespeicherteListeView_Previews: PreviewProvider {
    static var previews: some View {
        GespeicherteListeView(allLessons: []) // Only pass allLessons
            .environmentObject(SavedLessonsManager()) // Inject for preview
    }
}
