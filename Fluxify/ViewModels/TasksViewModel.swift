import Foundation
internal import Combine

class TasksViewModel: ObservableObject {
    @Published var tasks = [Task]()
    @Published var currentTaskIndex = 0
    @Published var score = 0
    @Published var taskCompleted = false
    @Published var lives = 3
    @Published var isGameOver = false
    @Published var selectedAnswer: String?
    @Published var isAnswerChecked = false
    @Published var isAnswerCorrect: Bool?

    private let lessonTitle: String
    private var cancellables = Set<AnyCancellable>()

    init(lessonTitle: String = "") {
        self.lessonTitle = lessonTitle
        fetchTasks()
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
    
    func startTasks() {
        currentTaskIndex = 0
        score = 0
        lives = 3
        taskCompleted = false
        isGameOver = false
        resetQuestionState()
    }

    func checkAnswer() {
        guard let currentTask = currentTask else { return }
        
        isAnswerChecked = true
        
        var isCorrect = false
        
        switch currentTask.type {
        case .multipleChoice, .match:
            isCorrect = selectedAnswer == currentTask.correctAnswer
            
        case .dragAndDrop, .sequence:
            isCorrect = selectedAnswer == "correct"
            
        case .slider:
            isCorrect = selectedAnswer == "correct"
        }
        
        isAnswerCorrect = isCorrect
        
        if isCorrect {
            score += 1
        } else {
            lives -= 1
            if lives <= 0 {
                lives = 0  // Prevent negative
                isGameOver = true  // Set game over state
            }
        }
    }
    
    
    func nextTask() {
        if isGameOver {
            return
        }
        
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
            taskCompleted = true
        }
    }
    
    private func resetQuestionState() {
        selectedAnswer = nil
        isAnswerChecked = false
        isAnswerCorrect = nil
    }
}
