import Foundation
import CoreGraphics

class MockDataManager {
    static let shared = MockDataManager()
    
    func getLessons() -> [Lesson] {
        return [
            Lesson(
                id: UUID(),
                title: "Kühlschrank",
                description: "Lern wie der Kühlschrank arbeitet.",
                subject: .wärmelere,
                tasks: [
                    getFridgeTask()
                ],
                isCompleted: false,
                isLocked: false,
                coordinate: CGPoint(x: 100, y: 150)
            ),
            Lesson(
                id: UUID(),
                title: "Photoaparat",
                description: "Wie kann ein stück metal des Lebens fotografiert werden?",
                subject: .optik,
                tasks: [
                    getCameraTask()
                ],
                isCompleted: false,
                isLocked: true, // User needs to finish physics first (mock logic)
                coordinate: CGPoint(x: 250, y: 300)
            )
        ]
    }
    
    private func getFridgeTask() -> Task {
        let compressorId = UUID()
        let condenserId = UUID()
        let evaporatorId = UUID()
        let valveId = UUID()
        
        return Task(
            id: UUID(),
            question: "Baue den Kühlschrankkreislauf zusammen. Ziehe die Komponenten in die richtige Reihenfolge.",
            type: .dragAndDrop,
            items: [
                TaskItem(id: compressorId, content: "Compressor", isImage: false, targetZoneId: nil),
                TaskItem(id: condenserId, content: "Condenser Coils", isImage: false, targetZoneId: nil),
                TaskItem(id: valveId, content: "Expansion Valve", isImage: false, targetZoneId: nil),
                TaskItem(id: evaporatorId, content: "Evaporator Coils", isImage: false, targetZoneId: nil)
            ],
            // In a real app, we'd map these to slots. For now, we assume simple ordering.
            correctArrangement: [compressorId, condenserId, valveId, evaporatorId],
            explanation: "The cycle starts at the Compressor, which pressurizes the gas. It moves to the Condenser to release heat, then through the Expansion Valve to drop pressure, and finally the Evaporator to absorb heat from inside the fridge."
        )
    }
    
    private func getCameraTask() -> Task {
        return Task(
            id: UUID(),
            question: "Identify the Nucleus components.",
            type: .multipleChoice,
            items: [
                TaskItem(id: UUID(), content: "Protons & Neutrons", isImage: false, targetZoneId: nil),
                TaskItem(id: UUID(), content: "Electrons Only", isImage: false, targetZoneId: nil),
                TaskItem(id: UUID(), content: "Quarks & Gluons (Advanced)", isImage: false, targetZoneId: nil)
            ],
            correctArrangement: nil, // Logic handled in view for multiple choice
            explanation: "The nucleus contains Protons (positive) and Neutrons (neutral). Electrons orbit outside."
        )
    }
    
    func getDailyFacts() -> [DailyFact] {
        return [
            DailyFact(title: "Space Smells", content: "Astronauts describe the smell of space as a mix of hot metal, diesel fumes, and barbecue.", imageName: "nose.fill"),
            DailyFact(title: "Neutron Stars", content: "A teaspoon of a neutron star would weigh about 6 billion tons.", imageName: "star.fill"),
            DailyFact(title: "Water Bears", content: "Tardigrades can survive in the vacuum of space.", imageName: "ant.fill")
        ]
    }
    
    func getUser() -> User {
        return User(uid: UUID(), username: "SpaceCadet", league: "Nabula", email: "email@example.com", completedLessons: [])
    }
}
