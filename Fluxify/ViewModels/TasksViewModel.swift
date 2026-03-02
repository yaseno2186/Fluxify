import Foundation
internal import Combine

class TasksViewModel: ObservableObject {
    @Published var tasks = [Task]()
    @Published var currentTaskIndex = 0
    @Published var score = 0
    @Published var quizCompleted = false
    @Published var lives = 3
    @Published var isGameOver = false

    @Published var selectedAnswer: String?
    @Published var isAnswerChecked = false
    @Published var isAnswerCorrect: Bool?

    private let lessonTitle: String
    private var cancellables = Set<AnyCancellable>()

    init(lessonTitle: String = "") {
        self.lessonTitle = lessonTitle
        // Removed fetchTasks() from here - must initialize all properties first
    }

    func fetchTasks() {
        BackendService.shared.fetchTasks(for: lessonTitle) { [weak self] tasks in
            DispatchQueue.main.async {
                self?.tasks = tasks
            }
        }
    }
    
    var currentTask: Task? {
        guard tasks.indices.contains(currentTaskIndex) else {
            return nil
        }
        return tasks[currentTaskIndex]
    }
    
    func startQuiz() {
        currentTaskIndex = 0
        score = 0
        lives = 3
        quizCompleted = false
        isGameOver = false
        resetQuestionState()
    }

    func checkAnswer() {
        guard let currentTask = currentTask, let selectedAnswer = selectedAnswer else { return }
        
        isAnswerChecked = true
        let isCorrect = selectedAnswer == currentTask.correctAnswer
        isAnswerCorrect = isCorrect
        
        if isCorrect {
            score += 1
        } else {
            lives -= 1
            if lives <= 0 {
                isGameOver = true
            }
        }
    }
    
    func nextTask() {
        if currentTaskIndex < tasks.count - 1 {
            currentTaskIndex += 1
            resetQuestionState()
        } else {
            quizCompleted = true
        }
    }
    
    private func resetQuestionState() {
        selectedAnswer = nil
        isAnswerChecked = false
        isAnswerCorrect = nil
    }
}
