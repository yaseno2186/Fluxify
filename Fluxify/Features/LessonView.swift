//
//  LessonView.swift
//  Fluxify
//
//  Created by TA638 on 27.01.26.
//

import SwiftUI

struct LessonView: View {
    let lesson: Lesson
    @State private var currentExerciseIndex: Int = 0
    @State private var progress = LessonProgress(lessonId: UUID(), totalExercises: 0)
    @State private var showCelebration = false
    @State private var selectedAnswer: Int? = nil
    @State private var isAnswered = false
    @State private var isCorrect = false
    
    var allExercises: [(type: String, index: Int)] {
        var exercises: [(type: String, index: Int)] = []
        for (i, _) in lesson.multipleChoiceExercises.enumerated() {
            exercises.append(("multipleChoice", i))
        }
        for (i, _) in lesson.trueFalseExercises.enumerated() {
            exercises.append(("trueFalse", i))
        }
        for (i, _) in lesson.matchingExercises.enumerated() {
            exercises.append(("matching", i))
        }
        for (i, _) in lesson.dragDropExercises.enumerated() {
            exercises.append(("dragDrop", i))
        }
        return exercises
    }

    var body: some View {
        ZStack {
            // Colorful gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.85, blue: 0.9),
                    Color(red: 0.85, green: 0.95, blue: 0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with progress - Hide on completion screen
                if currentExerciseIndex < allExercises.count {
                    VStack(spacing: 12) {
                        HStack {
                            Text(lesson.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(currentExerciseIndex + 1)/\(allExercises.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        
                        // Progress Bar
                        ProgressView(value: Double(currentExerciseIndex) / Double(allExercises.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .padding(.horizontal, 16)
                            .animation(.easeInOut(duration: 0.5), value: currentExerciseIndex)
                        
                        // XP Display
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .scaleEffect(progress.xpEarned > 0 ? 1.0 : 0.8)
                            Text("\(progress.xpEarned) XP")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress.xpEarned)
                    }
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    
                    Divider()
                }
                
                // Exercise Content or Completion Screen
                if currentExerciseIndex >= allExercises.count {
                    // Lesson Completed!
                    RewardView(lesson: lesson, progress: progress)
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            if currentExerciseIndex < allExercises.count {
                                let (type, index) = allExercises[currentExerciseIndex]
                                
                                switch type {
                                case "multipleChoice":
                                    MultipleChoiceView(
                                        exercise: lesson.multipleChoiceExercises[index],
                                        isAnswered: $isAnswered,
                                        selectedIndex: $selectedAnswer,
                                        onAnswer: handleMultipleChoiceAnswer
                                    )
                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                                case "trueFalse":
                                    TrueFalseView(
                                        exercise: lesson.trueFalseExercises[index],
                                        isAnswered: $isAnswered,
                                        onAnswer: handleTrueFalseAnswer
                                    )
                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                                case "matching":
                                    MatchingView(
                                        exercise: lesson.matchingExercises[index],
                                        isAnswered: $isAnswered,
                                        onAnswer: handleMatchingAnswer
                                    )
                                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                            case "dragDrop":
                                    DragDropView(
                                        exercise: lesson.dragDropExercises[index],
                                        isAnswered: $isAnswered,
                                        onAnswer: handleDragDropAnswer
                                    )
                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                                default:
                                    EmptyView()
                                }
                            }
                        }
                        .padding(16)
                    }
                    .animation(.easeInOut(duration: 0.4), value: currentExerciseIndex)
                }
                Spacer()
                
                // Navigation Buttons
                HStack(spacing: 12) {
                    Button(action: goToPreviousExercise) {
                        Text("Zurück")
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .fontWeight(.semibold)
                    }
                    .disabled(currentExerciseIndex == 0)
                    .scaleEffect(currentExerciseIndex == 0 ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentExerciseIndex)
                    
                    Button(action: goToNextExercise) {
                        Text(currentExerciseIndex == allExercises.count - 1 ? "Fertig" : "Weiter")
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(isAnswered ? LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .fontWeight(.semibold)
                    }
                    .disabled(!isAnswered)
                    .scaleEffect(isAnswered ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isAnswered)
                }
                .padding(16)
            }
            
            // Celebration Animation
            if showCelebration {
                CelebrationView()
            }
        }
        .onAppear {
            progress.totalExercises = allExercises.count
        }
    }
    
    func handleMultipleChoiceAnswer(_ index: Int) {
        let exercise = lesson.multipleChoiceExercises[allExercises[currentExerciseIndex].index]
        isCorrect = index == exercise.correctAnswerIndex
        updateProgress()
    }
    
    func handleTrueFalseAnswer(_ answer: Bool) {
        let exercise = lesson.trueFalseExercises[allExercises[currentExerciseIndex].index]
        isCorrect = answer == exercise.isTrue
        updateProgress()
    }
    
    func handleMatchingAnswer(_ isMatched: Bool) {
        isCorrect = isMatched
        updateProgress()
    }
    
    func handleDragDropAnswer(_ isCorrect: Bool) {
        self.isCorrect = isCorrect
        updateProgress()
    }
    
    func updateProgress() {
        progress.completedExercises += 1
        if isCorrect {
            progress.correctAnswers += 1
            progress.xpEarned += 10
            showCelebration = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                showCelebration = false
            }
        } else {
            progress.xpEarned += 5
        }
        isAnswered = true
    }
    
    func goToNextExercise() {
        if currentExerciseIndex < allExercises.count - 1 {
            currentExerciseIndex += 1
            resetExerciseState()
        } else if currentExerciseIndex == allExercises.count - 1 {
            // Move to completion screen
            currentExerciseIndex += 1
            progress.isCompleted = true
        }
    }
    
    func goToPreviousExercise() {
        if currentExerciseIndex > 0 {
            currentExerciseIndex -= 1
            resetExerciseState()
        }
    }
    
    func resetExerciseState() {
        selectedAnswer = nil
        isAnswered = false
        isCorrect = false
    }
}

// MARK: - Multiple Choice View
struct MultipleChoiceView: View {
    let exercise: MultipleChoiceExercise
    @Binding var isAnswered: Bool
    @Binding var selectedIndex: Int?
    let onAnswer: (Int) -> Void
    
    let colors = [
        Color(red: 1.0, green: 0.6, blue: 0.6),   // Red
        Color(red: 0.6, green: 0.8, blue: 1.0),   // Blue
        Color(red: 0.6, green: 1.0, blue: 0.7),   // Green
        Color(red: 1.0, green: 0.95, blue: 0.6)   // Yellow
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image if available
            if let imageURL = exercise.imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(8)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text(exercise.question)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(nil)
            
            VStack(spacing: 10) {
                ForEach(Array(exercise.options.enumerated()), id: \.offset) { index, option in
                    Button(action: {
                        selectedIndex = index
                        onAnswer(index)
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                            Spacer()
                            if selectedIndex == index {
                                Image(systemName: isAnswered && index == exercise.correctAnswerIndex ? "checkmark.circle.fill" : "circle.fill")
                                    .foregroundColor(isAnswered && index == exercise.correctAnswerIndex ? .green : .white)
                            }
                        }
                        .padding(12)
                        .background(colors[index % colors.count])
                        .cornerRadius(8)
                    }
                    .disabled(isAnswered)
                    .scaleEffect(selectedIndex == index ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedIndex)
                }
            }
            
            if isAnswered {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: selectedIndex == exercise.correctAnswerIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(selectedIndex == exercise.correctAnswerIndex ? .green : .red)
                        Text(selectedIndex == exercise.correctAnswerIndex ? "Richtig!" : "Leider falsch!")
                            .font(.subheadline)
                            .foregroundColor(selectedIndex == exercise.correctAnswerIndex ? .green : .red)
                            .fontWeight(.bold)
                    }
                    
                    Text(exercise.explanation)
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(nil)
                }
                .padding(12)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - True/False View
struct TrueFalseView: View {
    let exercise: TrueFalseExercise
    @Binding var isAnswered: Bool
    @State private var selectedAnswer: Bool? = nil
    let onAnswer: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image if available
            if let imageURL = exercise.imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(8)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text(exercise.statement)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(nil)
            
            HStack(spacing: 12) {
                Button(action: {
                    selectedAnswer = true
                    onAnswer(true)
                }) {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                        Text("Wahr")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(selectedAnswer == true ? Color.green.opacity(0.8) : Color(red: 0.6, green: 1.0, blue: 0.7))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                }
                .disabled(isAnswered)
                
                Button(action: {
                    selectedAnswer = false
                    onAnswer(false)
                }) {
                    VStack {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                        Text("Falsch")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(selectedAnswer == false ? Color.red.opacity(0.8) : Color(red: 1.0, green: 0.6, blue: 0.6))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                }
                .disabled(isAnswered)
            }
            
            if isAnswered {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: selectedAnswer == exercise.isTrue ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(selectedAnswer == exercise.isTrue ? .green : .red)
                        Text(selectedAnswer == exercise.isTrue ? "Richtig!" : "Leider falsch!")
                            .font(.subheadline)
                            .foregroundColor(selectedAnswer == exercise.isTrue ? .green : .red)
                            .fontWeight(.bold)
                    }
                    
                    Text(exercise.explanation)
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(nil)
                }
                .padding(12)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - Matching View
struct MatchingView: View {
    let exercise: MatchingExercise
    @Binding var isAnswered: Bool
    @State private var matches: [UUID: UUID] = [:]
    let onAnswer: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(exercise.instruction)
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Verbinde die Paare:")
                .font(.caption)
                .foregroundColor(.gray)
            
            // Placeholder for matching UI
            Text("Matching-Übung wird noch implementiert")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(20)
        }
    }
}

// MARK: - Drag & Drop View
struct DragDropView: View {
    let exercise: DragDropExercise
    @Binding var isAnswered: Bool
    let onAnswer: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(exercise.question)
                .font(.headline)
                .foregroundColor(.white)
            
            // Placeholder for drag & drop UI
            Text("Drag & Drop-Übung wird noch implementiert")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(20)
        }
    }
}

// MARK: - Celebration View
struct CelebrationView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
            
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .scaleEffect(1.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: UUID())
                
                Text("Großartig!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        .ignoresSafeArea()
    }
}
// MARK: - Reward View
struct RewardView: View {
    let lesson: Lesson
    let progress: LessonProgress
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Celebration animation
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .scaleEffect(1.2)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: UUID())
                
                Text("Großartig!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Lektion abgeschlossen!")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Stats
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(progress.xpEarned) XP verdient")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("\(progress.correctAnswers)/\(progress.completedExercises) Richtig")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "percent")
                        .foregroundColor(.blue)
                    Text("Genauigkeit: \(Int(progress.accuracy * 100))%")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: { dismiss() }) {
                Text("Zurück zum Home")
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .fontWeight(.semibold)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.85, blue: 0.9),
                    Color(red: 0.85, green: 0.95, blue: 0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    let sampleLesson = Lesson(
        title: "Kühlschrank",
        description: "Lerne wie ein Kühlschrank funktioniert",
        icon: "🧊",
        difficulty: .easy,
        sourceInfo: "Physik Lehrbuch 2024",
        multipleChoiceExercises: [
            MultipleChoiceExercise(
                question: "Wie kühlt ein Kühlschrank seine Lebensmittel ab?",
                options: ["Durch Eis", "Durch Verdampfung von Kühlmittel", "Durch kalte Luft von außen", "Durch Magnetismus"],
                correctAnswerIndex: 1,
                explanation: "Ein Kühlschrank nutzt die Verdampfung eines Kühlmittels, um Wärme zu entziehen.",
                difficulty: .easy
            )
        ],
        trueFalseExercises: [],
        matchingExercises: [],
        dragDropExercises: []
    )
    
    return LessonView(lesson: sampleLesson)
}
