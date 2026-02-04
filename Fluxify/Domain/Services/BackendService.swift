import Foundation

class BackendService {

    static let shared = BackendService()

    private init() {}

    func login(email: String, password: String, completion: @escaping (User?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if email == "test@example.com" && password == "password" {
                let user = User(name: "Test User", email: "test@example.com", password: "password", username: "testuser")
                completion(user)
            } else {
                completion(nil)
            }
        }
    }

    func fetchLessons(completion: @escaping ([Lesson]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let lessons = [
                Lesson(title: NSLocalizedString("lesson_microwave_title", comment: ""), description: NSLocalizedString("lesson_microwave_description", comment: ""), iconName: "waves.and.rays"),
                Lesson(title: NSLocalizedString("lesson_refrigerator_title", comment: ""), description: NSLocalizedString("lesson_refrigerator_description", comment: ""), iconName: "refrigerator"),
                Lesson(title: NSLocalizedString("lesson_induction_title", comment: ""), description: NSLocalizedString("lesson_induction_description", comment: ""), iconName: "heater.vertical"),
                Lesson(title: NSLocalizedString("lesson_gps_title", comment: ""), description: NSLocalizedString("lesson_gps_description", comment: ""), iconName: "globe.americas")
            ]
            completion(lessons)
        }
    }
    
    // Updated: Now accepts lessonTitle to return specific tasks
    func fetchTasks(for lessonTitle: String, completion: @escaping ([Task]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            // Microwave tasks
            let microwaveTasks = [
                Task(
                    question: "Wie funktioniert eine Mikrowelle?",
                    imageName: "waves.and.rays",
                    options: ["Mit Wärme", "Mit Mikrowellen", "Mit Gas", "Mit Elektrizität"],
                    correctAnswer: "Mit Mikrowellen"
                ),
                Task(
                    question: "Was sollte man nie in die Mikrowelle tun?",
                    imageName: nil,
                    options: ["Tasse", "Metall", "Plastik", "Papier"],
                    correctAnswer: "Metall"
                )
            ]
            
            // Refrigerator tasks
            let refrigeratorTasks = [
                Task(
                    question: "Wie heißt diese Komponente im Kühlschrank?",
                    imageName: "refrigerator",
                    options: ["Kondensator", "Verdampfer", "Expansionsventil", "Kompressor"],
                    correctAnswer: "Kompressor"
                ),
                Task(
                    question: "Welche Aufgabe hat der Kompressor?",
                    imageName: nil,
                    options: ["Kühlen", "Gefrieren", "Erhitzen", "Lüften"],
                    correctAnswer: "Kühlen"
                ),
                Task(
                    question: "Wie heißt das Gas im Kühlschrank?",
                    imageName: "refrigerator.fill",
                    options: ["Sauerstoff", "Stickstoff", "Kältemittel", "Helium"],
                    correctAnswer: "Kältemittel"
                )
            ]
            
            // Induction tasks
            let inductionTasks = [
                Task(
                    question: "Wie heizt ein Induktionsherd?",
                    imageName: "heater.vertical",
                    options: ["Mit Feuer", "Mit Magnetfeldern", "Mit Gas", "Mit Öl"],
                    correctAnswer: "Mit Magnetfeldern"
                ),
                Task(
                    question: "Welches Geschirr funktioniert auf Induktion?",
                    imageName: nil,
                    options: ["Aluminium", "Kupfer", "Eisen/Edelstahl", "Plastik"],
                    correctAnswer: "Eisen/Edelstahl"
                )
            ]
            
            // GPS tasks
            let gpsTasks = [
                Task(
                    question: "Wie viele Satelliten braucht GPS mindestens?",
                    imageName: "globe.americas",
                    options: ["2", "3", "4", "5"],
                    correctAnswer: "4"
                ),
                Task(
                    question: "Wofür steht GPS?",
                    imageName: nil,
                    options: ["Global Position System", "Global Positioning System", "General Position System", "Geo Position System"],
                    correctAnswer: "Global Positioning System"
                )
            ]
            
            // Return correct tasks based on lesson title
            let tasks: [Task]
            
            if lessonTitle.contains("Mikrowelle") || lessonTitle.contains("Microwave") {
                tasks = microwaveTasks
            } else if lessonTitle.contains("Kühlschrank") || lessonTitle.contains("Refrigerator") {
                tasks = refrigeratorTasks
            } else if lessonTitle.contains("Induktion") || lessonTitle.contains("Induction") {
                tasks = inductionTasks
            } else if lessonTitle.contains("GPS") {
                tasks = gpsTasks
            } else {
                tasks = refrigeratorTasks // Default fallback
            }
            
            completion(tasks)
        }
    }

    func fetchUserProfile(completion: @escaping (User?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let user = User(
                name: "Test User",
                email: "test@example.com",
                password: "password",
                username: "testuser",
                streak: 5,
                league: "Gold",
                savedTasks: []
            )
            completion(user)
        }
    }

    func logout(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
}
