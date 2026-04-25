//
//  ExpertenListeView.swift
//  Fluxify
//
//  Created by Yass on 07.03.26.
//

import SwiftUI

struct ExpertenListeView: View {
    let lessons: [Lesson]
    @StateObject private var savedManager = SavedLessonsManager.shared 
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.blue)
                        .frame(height: 200)
                        .offset(y: -40)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 25)
                        
                        ZStack(alignment: .center) {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
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
                            
                            Text("Experten Geräte")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(height: 50)
                        .padding(.top, 60)
                        
                        Spacer()
                    }
                    .frame(height: 180)
                }
                .frame(height: 160)
                
                // Content
                if lessons.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No expert devices available")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(lessons) { lesson in
                            NavigationLink(destination:
                                TaskDetailView(viewModel: TasksViewModel(lessonTitle: lesson.title))
                            ) {
                                ExpertLessonRow(lesson: lesson)
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

struct ExpertLessonRow: View {
    let lesson: Lesson
    @StateObject private var savedManager = SavedLessonsManager.shared   // ← CHANGED from @EnvironmentObject
    @StateObject private var userVM = UserViewModel.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with blue color (expert color)
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
            
            // Bookmark Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    savedManager.toggle(lesson)
                }
            }) {
                Image(systemName: savedManager.isSaved(lesson) ? "bookmark.fill" : "bookmark")
                    .font(.title3)
                    .foregroundColor(savedManager.isSaved(lesson) ? .blue : .gray)
                    .scaleEffect(savedManager.isSaved(lesson) ? 1.2 : 1.0)
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

struct ExpertenListeView_Previews: PreviewProvider {
    static var previews: some View {
        ExpertenListeView(lessons: [])
            .environmentObject(SavedLessonsManager())
    }
}
