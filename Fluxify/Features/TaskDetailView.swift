import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var viewModel: TasksViewModel
    @Environment(\.dismiss) private var dismiss

    private var progress: CGFloat {
        guard !viewModel.tasks.isEmpty else { return 0 }
        return CGFloat(viewModel.currentTaskIndex + 1) / CGFloat(viewModel.tasks.count)
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            
            if let task = viewModel.currentTask {
                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        // Progress bar
                        VStack(spacing: 8) {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .frame(height: 12)
                                        .foregroundColor(Color.gray.opacity(0.2))
                                    
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .cyan],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: max(0, geometry.size.width * progress), height: 12)
                                        .shadow(color: .cyan.opacity(0.6), radius: 8)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.currentTaskIndex)
                                }
                            }
                            .frame(height: 12)
                        }
                        .frame(maxWidth: 300)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text("\(viewModel.lives)")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()

                    // Main content card - fills available space
                    ScrollView {
                        VStack(spacing: 20) {
                            Text(task.question)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            // Task-specific content
                            switch task.type {
                            case .multipleChoice:
                                MultipleChoiceContent(task: task, viewModel: viewModel)
                            case .dragAndDrop:
                                DragAndDropContent(task: task, viewModel: viewModel)
                                    .frame(minHeight: 400) // Ensure minimum height
                            case .slider:
                                SliderContent(task: task, viewModel: viewModel)
                            case .sequence:
                                SequenceContent(task: task, viewModel: viewModel)
                            case .tapToReveal:
                                TapToRevealContent(task: task, viewModel: viewModel)
                            case .match:
                                MatchContent(task: task, viewModel: viewModel)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.6) // Minimum height
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                    // Bottom buttons - pushed to bottom
                    VStack(spacing: 0) {
                        if viewModel.isAnswerChecked {
                            VStack(spacing: 10) {
                                if let reasoning = task.reasoning {
                                    Text(reasoning)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                }

                                Button(action: {
                                    viewModel.nextTask()
                                }) {
                                    Text("Weiter")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(viewModel.isAnswerCorrect == true ? Color.green : Color.red)
                                        .cornerRadius(12)
                                }
                                .padding()
                            }
                        } else {
                            Button(action: {
                                viewModel.checkAnswer()
                            }) {
                                Text("Prüfen")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.selectedAnswer == nil ? .gray : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(viewModel.selectedAnswer == nil ? Color.gray.opacity(0.5) : Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding()
                            .disabled(viewModel.selectedAnswer == nil)
                        }
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                }
            } else {
                Text("Loading tasks...")
                    .onAppear {
                        viewModel.fetchTasks()
                    }
            }
        }
        .sheet(isPresented: $viewModel.isGameOver) {
            GameOverView(score: viewModel.score) {
                viewModel.startQuiz()
            }
        }
        .sheet(isPresented: $viewModel.quizCompleted) {
            QuizResultView(score: viewModel.score, totalQuestions: viewModel.tasks.count) {
                viewModel.startQuiz()
            }
        }
    }
}

// MARK: - Supporting Views

struct AnswerButton: View {
    let text: String
    @ObservedObject var viewModel: TasksViewModel
    let isCorrect: Bool
    
    private var isSelected: Bool { viewModel.selectedAnswer == text }
    
    var body: some View {
        Button(action: {
            if !viewModel.isAnswerChecked {
                viewModel.selectedAnswer = text
            }
        }) {
            HStack {
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if viewModel.isAnswerChecked && isSelected {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                }
            }
            .padding()
            .background((viewModel.isAnswerChecked && isSelected) ? (isCorrect ? Color.green : Color.red).opacity(0.1) : Color(UIColor.systemGroupedBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke((isSelected && !viewModel.isAnswerChecked) ? .blue : ((viewModel.isAnswerChecked && isSelected) ? (isCorrect ? .green : .red) : .clear), lineWidth: 3)
            )
        }
        .disabled(viewModel.isAnswerChecked && !isSelected)
    }
}

struct QuizResultView: View {
    let score: Int
    let totalQuestions: Int
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Completed!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your score: \(score)/\(totalQuestions)")
                .font(.title2)
            
            Button(action: onRetry) {
                Text("Retry Quiz")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

// NEW: Game Over View
struct GameOverView: View {
    let score: Int
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Text("You ran out of lives")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("Final Score: \(score)")
                .font(.headline)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button(action: onRetry) {
                Text("Try Again")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.top, 10)
        }
        .padding()
    }
}
// MARK: - Task Type Content Views

struct MultipleChoiceContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let images = task.imageName, let firstImage = images.first {
                Image(systemName: firstImage)
                    .font(.system(size: 100))
                    .padding()
            }
            
            VStack(spacing: 15) {
                ForEach(task.options ?? [], id: \.self) { option in
                    AnswerButton(
                        text: option,
                        viewModel: viewModel,
                        isCorrect: option == task.correctAnswer
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}
struct DragAndDropContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    @State private var placedItems: [String: DragItem] = [:]
    @State private var selectedItem: DragItem?
    
    var body: some View {
        VStack(spacing: 16) {
            // Diagram - takes available space
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.1))
                
                // Fridge diagram
                GenericDiagramView(
                    dropZones: task.dropZones ?? [],
                    placedItems: placedItems,
                    selectedItem: $selectedItem,
                    onZoneTap: { zoneId in
                        if let item = selectedItem {
                            placeItem(item, in: zoneId)
                        }
                    }
                )
                .padding()
            }
            .frame(maxHeight: .infinity) // Expand to fill space

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(availableItems) { item in
                            LabelButton(
                                item: item,
                                isSelected: selectedItem?.id == item.id
                            ) {
                                selectedItem = item
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            
            .padding(5)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(16)
        }
    
        .padding(.horizontal)
    }
    
    // Only show items that haven't been placed yet
    private var availableItems: [DragItem] {
        let placedIds = Set(placedItems.values.map { $0.id })
        return (task.dragItems ?? []).filter { !placedIds.contains($0.id) }
    }
    
    private func placeItem(_ item: DragItem, in zoneId: String) {
        placedItems[zoneId] = item
        selectedItem = nil
        checkCompletion()
    }
    
    private func checkCompletion() {
        print("=== CHECK COMPLETION ===")
        print("placedItems count: \(placedItems.count)")
        print("expected count: \(task.dragItems?.count ?? 0)")
        
        for (zoneId, item) in placedItems {
            print("Zone: \(zoneId), Item: \(item.text), correctZoneId: \(item.correctZoneId)")
            print("Match: \(item.correctZoneId == zoneId)")
        }
        
        let allCorrect = placedItems.allSatisfy { zoneId, item in
            item.correctZoneId == zoneId
        }
        let allPlaced = placedItems.count == (task.dragItems?.count ?? 0)
        
        print("allCorrect: \(allCorrect)")
        print("allPlaced: \(allPlaced)")
        
        if allPlaced {
            viewModel.selectedAnswer = allCorrect ? "correct" : "wrong"
            print("Set selectedAnswer to: \(viewModel.selectedAnswer ?? "nil")")
        }
    }
    
}

// MARK: - Label Button (Horizontal layout)
struct LabelButton: View {
    let item: DragItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                if let imageName = item.imageName {
                    Image(systemName: imageName)
                        .font(.system(size: 16))
                }
                Text(item.text)
                    .font(.system(size: 14, weight: isSelected ? .bold : .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        // Smooth animation when items rearrange
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
    }
}
// MARK: - Generic Diagram View
struct GenericDiagramView: View {
    let dropZones: [DropZone]
    let placedItems: [String: DragItem]
    @Binding var selectedItem: DragItem?
    let onZoneTap: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(dropZones) { zone in
                    ZoneBubble(
                        zone: zone,
                        placedItem: placedItems[zone.id],
                        isSelected: selectedItem != nil && placedItems[zone.id] == nil,
                        onTap: { onZoneTap(zone.id) }
                    )
                    .position(
                        x: geometry.size.width * zone.position.x,
                        y: geometry.size.height * zone.position.y
                    )
                }
            }
        }
    }
}

struct ZoneBubble: View {
    let zone: DropZone
    let placedItem: DragItem?
    let isSelected: Bool
    let onTap: () -> Void
    
    private var isCorrectlyPlaced: Bool {
        guard let item = placedItem else { return false }
        return item.correctZoneId == zone.id
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Bubble background - green if correct, red if wrong, gray if empty
                Circle()
                    .fill(placedItem != nil ?
                        (isCorrectlyPlaced ? Color.green.opacity(0.3) : Color.red.opacity(0.3)) :
                        (isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2)))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(placedItem != nil ?
                        (isCorrectlyPlaced ? Color.green : Color.red) :
                        (isSelected ? Color.blue : Color.gray), lineWidth: 2)
                    .frame(width: 50, height: 50)
                
                // Content
                if let item = placedItem {
                    VStack(spacing: 2) {
                        Image(systemName: item.imageName ?? "checkmark")
                            .font(.system(size: 14))
                        
                    }
                    .foregroundColor(isCorrectlyPlaced ? .green : .red)
                } else {
                    Image(systemName: isSelected ? "" : "")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
            }
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                
                self.size.width = max(self.size.width, x)
            }
            
            self.size.height = y + rowHeight
        }
    }
}
struct SliderContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    @State private var currentValue: Double = 0
    
    init(task: Task, viewModel: TasksViewModel) {
        self.task = task
        self.viewModel = viewModel
        let initialValue = task.sliderConfig?.minValue ?? 0
        _currentValue = State(initialValue: initialValue)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Value display - glass effect circle
            ZStack {
                // Subtle glass background
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 150, height: 150)
                
                // Border to define the circle
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 150, height: 150)
                
                VStack {
                    Text("\(Int(currentValue))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    Text(task.sliderConfig?.unit ?? "")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary)
                }
            }
            
            // Slider with colored track
            VStack(spacing: 10) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        // Colored fill track - shows progress
                        Capsule()
                            .fill(sliderTrackColor)
                            .frame(width: trackWidth(in: geometry.size.width), height: 12)
                        
                        // Native slider with invisible track
                        Slider(
                            value: $currentValue,
                            in: (task.sliderConfig?.minValue ?? 0)...(task.sliderConfig?.maxValue ?? 100),
                            step: task.sliderConfig?.step ?? 1
                        ) {
                            Text("Value")
                        } minimumValueLabel: {
                            EmptyView()
                        } maximumValueLabel: {
                            EmptyView()
                        }
                        .tint(.clear) // Makes the slider's native track invisible
                        .onChange(of: currentValue) {
                            checkAnswer()
                        }
                    }
                }
                .frame(height: 30)
                .padding(.horizontal)
                
                // Min/Max labels
                HStack {
                    Text(formattedValue(task.sliderConfig?.minValue ?? 0))
                    Spacer()
                    Text(formattedValue(task.sliderConfig?.maxValue ?? 100))
                }
                .padding(.horizontal)
                .foregroundColor(.gray)
            }
        }
        .padding()
    }
    
    // Calculate track width based on current value
    private func trackWidth(in totalWidth: CGFloat) -> CGFloat {
        guard let config = task.sliderConfig else { return 0 }
        let range = config.maxValue - config.minValue
        let progress = (currentValue - config.minValue) / range
        return totalWidth * CGFloat(progress)
    }
    
    // Track color changes based on proximity to target
    private var sliderTrackColor: Color {
        guard let config = task.sliderConfig else { return .blue }
        return .blue
    }
    
    private func formattedValue(_ value: Double) -> String {
        let unit = task.sliderConfig?.unit ?? ""
        return "\(Int(value))\(unit)"
    }
    
    private func checkAnswer() {
        guard let config = task.sliderConfig else { return }
        let isCorrect = abs(currentValue - config.correctValue) <= config.tolerance
        viewModel.selectedAnswer = isCorrect ? "correct" : "wrong"
    }
}
struct SequenceContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    @State private var selectedItems: [SequenceItem] = []
    
    var body: some View {
        VStack(spacing: 20) {
            // Current sequence
            VStack(spacing: 10) {
                Text("Deine Reihenfolge:")
                    .font(.headline)
                
                ForEach(Array(selectedItems.enumerated()), id: \.element.id) { index, item in
                    HStack {
                        Text("\(index + 1).")
                            .font(.title3)
                            .foregroundColor(.blue)
                        Text(item.text)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                        Spacer()
                        Button {
                            selectedItems.removeAll { $0.id == item.id }
                            checkCompletion()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                if selectedItems.isEmpty {
                    Text("Tippe die Schritte in Reihenfolge")
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Divider()
            
            // Available items
            ForEach(availableItems) { item in
                Button {
                    selectedItems.append(item)
                    checkCompletion()
                } label: {
                    HStack {
                        Image(systemName: item.imageName ?? "circle")
                        Text(item.text)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                }
                .disabled(viewModel.isAnswerChecked)
            }
        }
        .padding()
    }
    
    private var availableItems: [SequenceItem] {
        let selectedIds = Set(selectedItems.map { $0.id })
        return (task.sequenceItems ?? []).filter { !selectedIds.contains($0.id) }
    }
    
    private func checkCompletion() {
        guard selectedItems.count == (task.sequenceItems?.count ?? 0) else { return }
        let isCorrect = selectedItems.enumerated().allSatisfy { index, item in
            item.correctPosition == index + 1
        }
        viewModel.selectedAnswer = isCorrect ? "correct" : "wrong"
    }
}

struct TapToRevealContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tap to Reveal - Coming Soon")
                .foregroundColor(.gray)
            
            // Placeholder for tap zones
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    Text("Tap zones will appear here")
                        .foregroundColor(.gray)
                )
        }
        .padding()
    }
}

struct MatchContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Match - Coming Soon")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(viewModel: TasksViewModel())
    }
}
