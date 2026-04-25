//
//  NewHome.swift
//  Fluxify
//
//  Created by Bahinaz on 29.01.26.
//

import SwiftUI
internal import Combine

struct HomeView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var savedManager = SavedLessonsManager.shared
    var gefilterteLessons: [Lesson] {
        if searchText.isEmpty { return [] }
        return viewModel.lessons.filter {
            $0.title.lowercased().hasPrefix(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    
                    // Header
                    Text("Lerneinheiten")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 50)
                    
                    // Suchleiste
                    SuchLeiste(searchText: $searchText, lessons: viewModel.lessons)
                    
                    if searchText.isEmpty {
                        // Vier Themen-Kacheln
                        VStack(spacing: 16) {
                            NavigationLink(destination:
                                            ThemaDetailView(
                                                titel: "Mechanik",
                                                color: .mint,
                                                category: .mechanik
                                            )
                            ) {
                                FeatureCard(title: "Mechanik", icon: "gearshape.2.fill", color: .mint)
                            }
                            
                            NavigationLink(destination:
                                            ThemaDetailView(
                                                titel: "Elektromagnetismus",
                                                color: .red,
                                                category: .elektromagnetismus
                                            )
                            ) {
                                FeatureCard(title: "Elektromagnetismus", icon: "bolt.fill", color: .red)
                            }
                            
                            NavigationLink(destination:
                                            ThemaDetailView(
                                                titel: "Wärmelehre",
                                                color: .orange,
                                                category: .waermelehre
                                            )
                            ) {
                                FeatureCard(title: "Wärmelehre", icon: "flame.fill", color: .orange)
                            }
                            
                            NavigationLink(destination:
                                            ThemaDetailView(
                                                titel: "Optik",
                                                color: .purple,
                                                category: .optik
                                            )
                            ) {
                                FeatureCard(title: "Optik", icon: "triangle.fill", color: .purple)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        
                        // Untere Kacheln
                        VStack(spacing: 16) {
                            // Gespeichert - PASS THE PARAMETERS HERE
                            NavigationLink(destination: GespeicherteListeView(allLessons: viewModel.lessons)) {
                                SpecialFeatureCard(
                                    title: "Gespeichert",
                                    icon: "bookmark.fill",
                                    color: .indigo,
                                    borderColor: .indigo.opacity(0.8)
                                )
                            }
                            
                            // Experten Geräte - Filter by experten category
                            NavigationLink(destination:
                                ExpertenListeView(lessons: viewModel.lessons.filter { $0.category == .experten })
                            ) {
                                SpecialFeatureCard(
                                    title: "Experten Geräte",
                                    icon: "graduationcap.fill",
                                    color: .blue,
                                    borderColor: .blue.opacity(0.8)
                                )
                            }
                            
                            // Wusstest du schon
                            NavigationLink(destination: WusstestDuSchonView()) {
                                SpecialFeatureCard(
                                    title: "Wusstest du schon?",
                                    icon: "lightbulb.fill",
                                    color: .yellow,
                                    borderColor: .yellow.opacity(0.8)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120)
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
            .onAppear {
                viewModel.fetchLessons()
            }
        }
        
        .environmentObject(savedManager)
        .environmentObject(viewModel)
    }
}
// MARK: - Supporting Views
struct FeatureCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.8))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
                .frame(width: 56)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
    }
}

struct SpecialFeatureCard: View {
    let title: String
    let icon: String
    let color: Color
    let borderColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.8))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
                .frame(width: 56)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: 3)
        )
    }
}

struct SuchLeiste: View {
    @Binding var searchText: String
    let lessons: [Lesson]
    
    var gefilterteLessons: [Lesson] {
        if searchText.isEmpty { return [] }
        return lessons.filter {
            $0.title.lowercased().hasPrefix(searchText.lowercased())
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Gerät suchen...", text: $searchText)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
            .padding(.horizontal, 24)
            
            if !gefilterteLessons.isEmpty {
                ForEach(gefilterteLessons) { lesson in
                    NavigationLink(destination:
                        TaskDetailView(viewModel: TasksViewModel(lessonTitle: lesson.title))
                    ) {
                        HStack {
                            Image(systemName: lesson.iconName)
                                .frame(width: 30)
                            Text(lesson.title)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            Text(lesson.category.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}
// MARK: - Detail Views

struct ThemaDetailView: View {
    let titel: String
    let color: Color
    let category: LessonCategory
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = HomeViewModel()
    @State private var isLoading = true
        
    private var lessonsForCategory: [Lesson] {
        viewModel.lessons.filter { $0.category == category }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header (keep existing)
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(color)
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
                            
                            Text(titel)
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
                if isLoading {
                    ProgressView("Loading...")
                        .padding(.top, 50)
                } else if lessonsForCategory.isEmpty {
                    Text("No lessons available")
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(lessonsForCategory) { lesson in
                                NavigationLink(destination: TaskDetailView(viewModel: TasksViewModel(lessonTitle: lesson.title))) {
                                    LessonRowView(lesson: lesson, color: color)
                                }
                                .buttonStyle(.plain) 
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
            viewModel.fetchLessons()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
    }
}

// NEW: Row with tap action instead of NavigationLink wrapper
struct LessonRowView: View {
    let lesson: Lesson
    let color: Color
    @StateObject private var userVM = UserViewModel.shared
    @StateObject private var savedManager = SavedLessonsManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: lesson.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                )
            
            Text(lesson.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ProgressBar(
                progress: userVM.getProgress(for: lesson.title),
                color: color
            )
            .frame(width: 60, height: 6)
            
            // Bookmark button works independently inside the NavigationLink
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
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

struct WusstestDuSchonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 70)
            .padding(.leading, 16)
            
            Spacer()
            
            Text("Wusstest du schon?")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
            
            Text("Hier kommen interessante Fakten...")
                .foregroundColor(.black.opacity(0.6))
                .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
