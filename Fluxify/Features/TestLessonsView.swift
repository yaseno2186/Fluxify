//
//  TestLessonsView.swift
//  Fluxify
//
//  Created by TA638 on 27.01.26.
//

import SwiftUI

struct TestLessonsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Test Lessons")
                    .font(.title2)
                    .fontWeight(.bold)
                
                NavigationLink(destination: LessonView(lesson: createKuhlschrankLesson())) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.white)
                        Text("Test: Kühlschrank Lektion")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Sample Lessons
    private func createKuhlschrankLesson() -> Lesson {
        return Lesson(
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
                    explanation: "Ein Kühlschrank nutzt die Verdampfung eines Kühlmittels, um Wärme zu entziehen. Das Kühlmittel verdampft in einem Rohr im Inneren des Kühlschranks und entzieht dabei Wärme. Diese Wärme wird dann nach außen transportiert.",
                    difficulty: .easy
                ),
                MultipleChoiceExercise(
                    question: "Welcher Prozess ist hauptsächlich für die Kühlung verantwortlich?",
                    options: ["Konvektion", "Leitung", "Verdampfung", "Strahlung"],
                    correctAnswerIndex: 2,
                    explanation: "Der Verdampfungsprozess ist am wichtigsten. Das Kühlmittel verdampft und absorbiert dabei latente Wärmenergie.",
                    difficulty: .medium
                )
            ],
            trueFalseExercises: [
                TrueFalseExercise(
                    statement: "Ein Kühlschrank kann Wärme komplett beseitigen.",
                    isTrue: false,
                    explanation: "Nein, ein Kühlschrank transportiert Wärme nur von innen nach außen. Die Wärme wird an die Umgebung abgegeben, nicht vernichtet.",
                    difficulty: .easy
                )
            ],
            matchingExercises: [],
            dragDropExercises: []
        )
    }
}

#Preview {
    TestLessonsView()
}
