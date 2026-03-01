import Foundation

enum TaskType: String, CaseIterable {
    case multipleChoice = "multiple_choice"
    case dragAndDrop = "drag_and_drop"
    case slider = "slider"
    case sequence = "sequence"
    case match = "match"
}

struct Task: Identifiable {
    let id = UUID()
    let type: TaskType
    let question: String
    let imageName: [String]?
    let options: [String]?
    let correctAnswer: String?
    let dragItems: [DragItem]?
    let dropZones: [DropZone]?
    let sliderConfig: SliderConfig?
    let sequenceItems: [SequenceItem]?
    let reasoning: String?
    let tip: String?
}

struct DragItem: Identifiable {
    let id = UUID()
    let text: String
    let correctZoneId: String
    let imageName: String?
}

struct DropZone: Identifiable {
    let id: String 
    let label: String
    let imageName: String?
    let position: CGPoint
}

struct SliderConfig {
    let minValue: Double
    let maxValue: Double
    let correctValue: Double
    let tolerance: Double
    let unit: String
    let step: Double
}

struct SequenceItem: Identifiable {
    let id = UUID()
    let text: String
    let correctPosition: Int
    let imageName: String?
}
