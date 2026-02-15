import Foundation
import Combine

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
        fetchTasks() // Fetch tasks on init
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
        guard let currentTask = currentTask else { return }
        
        isAnswerChecked = true
        
        var isCorrect = false
        
        switch currentTask.type {
        case .multipleChoice, .tapToReveal, .match:
            isCorrect = selectedAnswer == currentTask.correctAnswer
            
        case .dragAndDrop, .sequence:
            // These set "correct" or "wrong" directly
            isCorrect = selectedAnswer == "correct"
            
        case .slider:
            // Slider sets "correct" or "wrong" directly
            isCorrect = selectedAnswer == "correct"
        }
        
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
            if currentTaskIndex < tasks.count {
                UserViewModel.shared.updateProgress(
                    lessonTitle: lessonTitle,
                    completedTasks: currentTaskIndex + 1,
                    totalTasks: tasks.count
                )
                resetQuestionState()
            }
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
