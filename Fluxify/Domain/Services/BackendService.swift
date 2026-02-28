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
                Lesson(
                    title: NSLocalizedString("Mikrowelle", comment: ""),
                    iconName: "microwave.fill",
                    category: .waermelehre  // Mikrowelle is Wärmelehre
                ),
                Lesson(
                    title: NSLocalizedString("Kühlschrank", comment: ""),
                    iconName: "refrigerator",
                    category: .waermelehre  // Kühlschrank is Wärmelehre
                ),
                Lesson(
                    title: NSLocalizedString("Induktion", comment: ""),
                    iconName: "heater.vertical",
                    category: .elektromagnetismus  // Induktion is Elektromagnetismus
                ),
                Lesson(
                    title: NSLocalizedString("GPS", comment: ""),
                    iconName: "globe.americas",
                    category: .experten  // GPS is Experten
                )
            ]
            completion(lessons)
        }
    }
    
    // Updated: Now accepts lessonTitle to return specific tasks
    func fetchTasks(for lessonTitle: String, completion: @escaping ([Task]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        
            // Microwave tasks - Updated with TaskType
                  let microwaveTasks = [
                      Task(
                          type: .multipleChoice,
                          question: "Wie heizt eine Mikrowelle?",
                          imageName: ["microwave_waves"],
                          options: ["Mit Wärme", "Mit Mikrowellen", "Mit Gas", "Mit Elektrizität"],
                          correctAnswer: "Mit Mikrowellen",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Mikrowellen sind elektromagnetische Wellen. Sie lassen Wassermoleküle im Essen schnell hin- und herbewegen. Durch diese Bewegung entsteht Wärme.",
                          tip: "Tipp: Je mehr Wasser im Essen ist, desto schneller wird es heiß."
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Was passiert mit Metall in der Mikrowelle?",
                          imageName: ["metal_sparks"],
                          options: ["Es schmilzt", "Es funkelt", "Es wird heiß", "Nichts"],
                          correctAnswer: "Es funkelt",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Metall reflektiert Mikrowellen. An spitzen Kanten entstehen starke elektrische Felder, die Funken erzeugen. Das kann das Gerät beschädigen.",
                          tip: "⚠️ Achtung: Nie Metall in die Mikrowelle geben!"
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Warum dreht sich der Teller?",
                          imageName: ["turntable", "hotspots"],
                          options: ["Zum Mischen", "Für gleichmäßige Hitze", "Zum Abkühlen", "Nur Dekoration"],
                          correctAnswer: "Für gleichmäßige Hitze",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Mikrowellen bilden stehende Wellen. Es gibt heiße und kalte Stellen. Der Drehteller bewegt das Essen durch alle Zonen.",
                          tip: "Tipp: Essen in der Mitte platzieren für beste Ergebnisse."
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Warum wird das Essen außen heißer?",
                          imageName: ["penetration_depth"],
                          options: ["Zu wenig Leistung", "Mikrowellen dringen nur 2-3 cm ein", "Der Teller dreht zu langsam", "Wärme steigt nach oben"],
                          correctAnswer: "Mikrowellen dringen nur 2-3 cm ein",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Die Wellen werden im äußeren Bereich des Essens absorbiert. Das Innere erwärmt sich nur durch Wärmeleitung von außen.",
                          tip: "Tipp: Große Stücke niedriger Leistung und länger erwärmen."
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Was ist ein Magnetron?",
                          imageName: ["magnetron"],
                          options: ["Ein Motor", "Die Mikrowellen-Quelle", "Ein Ventilator", "Ein Sensor"],
                          correctAnswer: "Die Mikrowellen-Quelle",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Das Magnetron ist eine Vakuumröhre. Sie erzeugt die 2,45 GHz Mikrowellen durch schnell bewegte Elektronen.",
                          tip: "Tipp: Das Herzstück jeder Mikrowelle."
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Warum platzen Eier in der Mikrowelle?",
                          imageName: ["egg_explosion"],
                          options: ["Zu schnell erhitzt", "Dampfdruck in der Schale", "Chemische Reaktion", "Zu viel Salz"],
                          correctAnswer: "Dampfdruck in der Schale",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Das Wasser im Ei verdampft. Die Schale hält den Druck zurück. Bei zu hohem Druck explodiert das Ei.",
                          tip: "⚠️ Achtung: Eier immer aufschlagen oder anstechen!"
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Welche Frequenz nutzt die Mikrowelle?",
                          imageName: ["frequency_wave"],
                          options: ["50 Hz", "2,45 GHz", "100 MHz", "1000 Hz"],
                          correctAnswer: "2,45 GHz",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "2,45 GHz bedeutet 2,45 Milliarden Schwingungen pro Sekunde. Diese Frequenz wird besonders gut von Wasser absorbiert.",
                          tip: "Tipp: Dieselbe Frequenz nutzt auch WLAN."
                      ),
                      Task(
                          type: .multipleChoice,
                          question: "Warum bleibt der Teller kalt?",
                          imageName: ["glass_plate"],
                          options: ["Er ist zu dick", "Glas absorbiert keine Mikrowellen", "Er dreht sich zu schnell", "Er ist isoliert"],
                          correctAnswer: "Glas absorbiert keine Mikrowellen",
                          dragItems: nil,
                          dropZones: nil,
                          sliderConfig: nil,
                          sequenceItems: nil,
                          reasoning: "Keramik und Glas haben keine Wassermoleküle. Sie lassen Mikrowellen durch und werden nicht heiß.",
                          tip: "Tipp: Deshalb nutzen wir Glas und Porzellan in der Mikrowelle."
                      )
                  ]
                  
            // Interactive refrigerator tasks
            let refrigeratorTasks = [
                // Multiple Choice (existing)
                Task(
                    type: .multipleChoice,
                    question: "Wie heißt das untere Teil im Kühlschrank?",
                    imageName: ["Fridge Image"],
                    options: ["Kondensator", "Verdampfer", "Kompressor", "Expansionsventil" ],
                    correctAnswer: "Kompressor",
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: nil,
                    sequenceItems: nil,
                    reasoning: "Der Kompressor ist das Herzstück des Kältekreislaufs. Er verdichtet das gasförmige Kältemittel, wodurch Druck und Temperatur steigen.",
                    tip: "💡 Tipp: Der Kompressor sollte frei von Staub sein für optimale Kühlleistung!"
                ),
                
                // Drag & Drop: Build the cooling cycle
                Task(
                    type: .dragAndDrop,
                    question: "Ziehe die Teile an die richtige Stelle im Kältekreislauf!",
                    imageName: ["Fridge Image"],
                    options: nil,
                    correctAnswer: nil,
                    dragItems: [
                        DragItem(text: "Kompressor", correctZoneId: "bottom", imageName: "bolt.fill"),        // or "gearshape.fill"
                        DragItem(text: "Kondensator", correctZoneId: "left", imageName: "flame.fill"),        // or "radiator"
                        DragItem(text: "Expansionsventil", correctZoneId: "top", imageName: "arrow.down.circle"), // or "arrow.down.circle"
                        DragItem(text: "Verdampfer", correctZoneId: "right", imageName: "snowflake")    // or "wind"
                    ],
                    dropZones: [
                        DropZone(id: "bottom", label: "Unten", imageName: nil, position: CGPoint(x: 0.5, y: 0.9)),   // bottom center
                        DropZone(id: "right", label: "Rechts", imageName: nil, position: CGPoint(x: 0.7, y: 0.5)),   // right side
                        DropZone(id: "top", label: "Oben", imageName: nil, position: CGPoint(x: 0.3, y: 0.2)), // top left inside
                        DropZone(id: "left", label: "Links", imageName: nil, position: CGPoint(x: 0.3, y: 0.5))    // left side inside
                    ],
                    sliderConfig: nil,
                    sequenceItems: nil,
                    reasoning: "Der Kreislauf: Kompressor (unten) → Kondensator (hinten) → Expansionsventil (oben) → Verdampfer (innen) → zurück zum Kompressor.",
                    tip: "Tipp: Folge dem Pfeil - warm außen, kalt innen!"
                ),
                
                // Slider: Temperature adjustment
                Task(
                    type: .slider,
                    question: "Stelle die optimale Gefrierschrank-Temperatur ein!",
                    imageName: ["freezer_temp_display"],
                    options: nil,
                    correctAnswer: nil,
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: SliderConfig(
                        minValue: -25,
                        maxValue: -10,
                        correctValue: -18,
                        tolerance: 2,
                        unit: "°C",
                        step: 1
                    ),
                    sequenceItems: nil,
                    reasoning: "-18°C ist der Standard für Gefrierschränke. Bei dieser Temperatur bleiben Lebensmittel lange haltbar und Bakterien können nicht wachsen.",
                    tip: "💡 Tipp: Jede Grad Celsius mehr verbraucht ca. 6% mehr Energie!"
                ),
                
                // Sequence: Order the cooling process
                Task(
                    type: .sequence,
                    question: "Ordne die Schritte des Kältekreislaufs richtig!",
                    imageName: ["cooling_cycle_arrows"],
                    options: nil,
                    correctAnswer: nil,
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: nil,
                    sequenceItems: [
                        SequenceItem(text: "Kompressor verdichtet Gas", correctPosition: 1, imageName: "step1_compress"),
                        SequenceItem(text: "Kondensator gibt Wärme ab", correctPosition: 2, imageName: "step2_condense"),
                        SequenceItem(text: "Ventil lässt Druck sinken", correctPosition: 3, imageName: "step3_expand"),
                        SequenceItem(text: "Verdampfer wird kalt", correctPosition: 4, imageName: "step4_evaporate")
                    ],
                    reasoning: "1. Verdichten → 2. Abkühlen & Verflüssigen → 3. Entspannen → 4. Verdampfen & Kälte erzeugen",
                    tip: "Tipp: Denke an den Kreislauf - es geht immer weiter!"
                )
            ]
            // Induction tasks - Updated
            let inductionTasks = [
                Task(
                    type: .multipleChoice,
                    question: "Wie heizt ein Induktionsherd?",
                    imageName: ["heater.vertical"],
                    options: ["Mit Feuer", "Mit Magnetfeldern", "Mit Gas", "Mit Öl"],
                    correctAnswer: "Mit Magnetfeldern",
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: nil,
                    sequenceItems: nil,
                    reasoning: "Induktionsherde erzeugen ein hochfrequentes magnetisches Wechselfeld. Dieses Feld induziert Wirbelströme im Topf, die Wärme erzeugen.",
                    tip: "💡 Tipp: Der Topf selbst wird heiß, die Platte bleibt kühl!"
                ),
                Task(
                    type: .multipleChoice,
                    question: "Welches Geschirr funktioniert auf Induktion?",
                    imageName: nil,
                    options: ["Aluminium", "Kupfer", "Eisen/Edelstahl", "Plastik"],
                    correctAnswer: "Eisen/Edelstahl",
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: nil,
                    sequenceItems: nil,
                    reasoning: "Für Induktion wird ferromagnetisches Material benötigt. Eisen und magnetischer Edelstahl konzentrieren die Magnetfeldlinien.",
                    tip: "💡 Tipp: Test mit Magnet: Haftet ein Magnet am Topfboden, ist er induktionsgeeignet!"
                )
            ]
            
            // GPS tasks - Updated
            let gpsTasks = [
                Task(
                    type: .multipleChoice,
                    question: "Wie viele Satelliten braucht GPS mindestens?",
                    imageName: ["globe.americas"],
                    options: ["2", "3", "4", "5"],
                    correctAnswer: "4",
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: nil,
                    sequenceItems: nil,
                    reasoning: "Für eine 3D-Position (Länge, Breite, Höhe) plus Zeitkorrektur werden 4 Satelliten benötigt.",
                    tip: "💡 Tipp: Mehr Satelliten verbessern die Genauigkeit!"
                ),
                Task(
                    type: .multipleChoice,
                    question: "Wofür steht GPS?",
                    imageName: nil,
                    options: ["Global Position System", "Global Positioning System", "General Position System", "Geo Position System"],
                    correctAnswer: "Global Positioning System",
                    dragItems: nil,
                    dropZones: nil,
                    sliderConfig: nil,
                    sequenceItems: nil,
                    reasoning: "GPS wurde 1973 von der US-Regierung entwickelt und besteht aus 24-32 Satelliten.",
                    tip: "💡 Tipp: GPS ist nur eines von mehreren GNSS-Systemen!"
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
                tasks = refrigeratorTasks
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
                savedTasks: [],
                lessonProgress: [
                    LessonProgress(lessonTitle: "Mikrowelle", completedTasks: 0, totalTasks: 8),
                    LessonProgress(lessonTitle: "Kühlschrank", completedTasks: 0, totalTasks: 6),
                    LessonProgress(lessonTitle: "Induktion", completedTasks: 0, totalTasks: 2),
                    LessonProgress(lessonTitle: "GPS", completedTasks: 0, totalTasks: 2)
                ]
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
