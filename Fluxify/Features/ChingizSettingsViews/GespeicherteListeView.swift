//
//  GespeicherteListeView.swift
//  Fluxify
//
//  Created by Chingiz on 12.02.26.
//

import SwiftUI
import Foundation
internal import Combine

struct GespeicherteListeView: View {
    @StateObject private var viewModel = GespeicherteListeViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // Group lessons by category
    private var gruppierteLessons: [LessonCategory: [Lesson]] {
        Dictionary(grouping: viewModel.savedLessons, by: { $0.category })
    }
    
    // Sorted categories for consistent ordering
    private var sortierteKategorien: [LessonCategory] {
        gruppierteLessons.keys.sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header Bereich
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
                if viewModel.isLoading {
                    ProgressView("Laden...")
                        .padding(.top, 50)
                } else if viewModel.savedLessons.isEmpty {
                    // Anzeige, wenn die Liste komplett leer ist
                    VStack(spacing: 20) {
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Noch nichts gespeichert")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                } else {
                    // LazyVStack für Performance
                    LazyVStack(spacing: 25) {
                        
                        // Wir gehen jede gefundene Kategorie einzeln durch
                        ForEach(sortierteKategorien, id: \.self) { category in
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                // TRENNELEMENT: Der Text für das Themengebiet
                                Text(category.rawValue.uppercased())
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 4)
                                
                                // 2. SCHLEIFE: Wir zeigen alle Lessons an, die zu DIESER Kategorie gehören
                                ForEach(gruppierteLessons[category] ?? []) { lesson in
                                    NavigationLink(destination:
                                        TaskDetailView(viewModel: TasksViewModel(lessonTitle: lesson.title))
                                    ) {
                                        // Die Kachel mit der Kategorie-Farbe
                                        LessonKachel(
                                            lesson: lesson,
                                            showProgress: true
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
        .onAppear {
            viewModel.fetchSavedLessons()
        }
    }
}

// MARK: - ViewModel
class GespeicherteListeViewModel: ObservableObject {
    @Published var savedLessons: [Lesson] = []
    @Published var isLoading: Bool = false
    
    func fetchSavedLessons() {
        isLoading = true
        
        // Fetch all available lessons from BackendService
        BackendService.shared.fetchLessons { [weak self] allLessons in
            // Fetch user profile to get saved lesson titles
            BackendService.shared.fetchUserProfile { user in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    // Get saved lesson titles from user profile
                    // Note: Currently User.savedTasks is [Task], but we treat them as lesson identifiers
                    // You might want to add savedLessonTitles: [String] to User struct
                    let savedLessonTitles = user?.savedTasks.map { $0.question } ?? []
                    
                    if !savedLessonTitles.isEmpty {
                        // Filter lessons that are in user's saved list
                        self?.savedLessons = allLessons.filter { lesson in
                            savedLessonTitles.contains(lesson.title)
                        }
                    } else {
                        // Demo: Show all lessons if nothing is saved
                        // In production, replace this with empty array
                        self?.savedLessons = allLessons
                    }
                }
            }
        }
    }
    
    func removeLesson(_ lesson: Lesson) {
        savedLessons.removeAll { $0.id == lesson.id }
        // TODO: Call BackendService to update saved lessons on server
    }
}

// MARK: - Lesson Kachel
struct LessonKachel: View {
    let lesson: Lesson
    let showProgress: Bool
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
            
            // Progress bar if enabled
            if showProgress {
                ProgressBar(
                    progress: userVM.getProgress(for: lesson.title),
                    color: lesson.category.color
                )
                .frame(width: 60, height: 6)
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
        GespeicherteListeView()
    }
}
