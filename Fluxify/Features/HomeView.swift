//
//  NewHome.swift
//  Fluxify
//
//  Created by Bahinaz on 29.01.26.
//
//
//  NewHome.swift
//  Fluxify
//
//  Created by Bahinaz on 29.01.26.
//

import SwiftUI
internal import Combine
import Foundation

struct HomeView: View {
    @StateObject private var manager = SavedGeraeteManager()
    @State private var searchText = ""
    @StateObject private var viewModel = HomeViewModel()
    
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
                    Text("Home")
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
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            
                            VStack(spacing: 16) {
                                NavigationLink(destination: GespeicherteListeView(manager: manager)) {
                                    SpecialFeatureCard(title: "Gespeichert", icon: "bookmark.fill", color: .indigo, borderColor: .indigo.opacity(0.8))
                                }
                                
                                NavigationLink(destination: ExpertenListeView(geraete: geraete.filter { $0.kategorie == "Experten Geräte" }, manager: manager)) {
                                    SpecialFeatureCard(title: "Experten Geräte", icon: "graduationcap.fill", color: .blue, borderColor: .blue.opacity(0.8))
                                }
                                
                                NavigationLink(destination: WusstestDuSchonView()) {
                                    SpecialFeatureCard(title: "Wusstest du schon?", icon: "lightbulb.fill", color: .yellow, borderColor: .yellow.opacity(0.8))
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
            .onAppear {
                viewModel.fetchLessons()
            }
        }
    }
}

// MARK: - 5. Sub-Views & Components

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
            
            Spacer().frame(width: 56)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray5)))
    }
}

// Farbige Rahmen für Experten & Wusstest du schon
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
            
            Spacer().frame(width: 56)
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
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Gerät suchen...", text: $searchText)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
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

// MARK: - 6. Detail Views

struct ThemaDetailView: View {
    let titel: String
    let farbe: Color
    let geraete: [Geraet]
    @ObservedObject var manager: SavedGeraeteManager
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = HomeViewModel()
    @State private var isLoading = true
    
    private var lessonsForCategory: [Lesson] {
        viewModel.lessons.filter { $0.category == category }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(color)
                        .frame(height: 200)
                        .offset(y: -40)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 25)
                        ZStack(alignment: .center) {
                            HStack {
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
                
                LazyVStack(spacing: 16) {
                    ForEach(geraete) { geraet in
                        NavigationLink(destination: GerätDetailView(geraet: geraet)) {
                            GerätKachel(
                                geraet: geraet,
                                hintergrundFarbe: farbe.opacity(0.1),
                                showProgress: true,
                                manager: manager
                            )
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



// MARK: - Kacheln & Detail

struct GerätKachel: View {
    let geraet: Geraet
    let hintergrundFarbe: Color
    let showProgress: Bool
    @ObservedObject var manager: SavedGeraeteManager
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(hintergrundFarbe)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: geraet.icon)
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                )
            
            Text(geraet.name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    manager.toggle(geraet)
                }
            } label: {
                Image(systemName: manager.isSaved(geraet) ? "bookmark.fill" : "bookmark")
                    .font(.title3)
                    .foregroundColor(manager.isSaved(geraet) ? .blue : .gray)
                    .scaleEffect(manager.isSaved(geraet) ? 1.2 : 1.0)
                    .padding(8)
            }
            
            if showProgress {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
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

struct ExpertenListeView: View {
    let geraete: [Geraet]
    @ObservedObject var manager: SavedGeraeteManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.blue.opacity(0.8))
                        .frame(height: 200)
                        .offset(y: -40)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 25)
                        ZStack(alignment: .center) {
                            HStack {
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
                            Text("Experten Geräte")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                        .padding(.top, 60)
                        Spacer()
                    }
                    .frame(height: 180)
                }
                .frame(height: 160)
                
                LazyVStack(spacing: 16) {
                    ForEach(lessons) { lesson in
                        NavigationLink(destination:
                            TaskDetailView(viewModel: TasksViewModel(lessonTitle: lesson.title))
                        ) {
                            ExpertenLessonRow(lesson: lesson)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 25)
                Spacer(minLength: 50)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

// Lesson Row for Expert List
struct ExpertenLessonRow: View {
    let lesson: Lesson
    @StateObject private var userVM = UserViewModel.shared
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: lesson.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(.black) // Black icon
                )
            
            // Only title, no description
            Text(lesson.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(geraet.name).font(.system(size: 18, weight: .semibold)).foregroundColor(.black)
            Spacer()
            
            // Progress bar instead of stars
            ProgressBar(
                progress: userVM.getProgress(for: lesson.title),
                color: .blue
            )
            .frame(width: 60, height: 6)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 5))
    }
}

struct WusstestDuSchonView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Button("Zurück") { presentationMode.wrappedValue.dismiss() }.padding()
            Spacer()
            Text("Wusstest du schon?").font(.title)
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

