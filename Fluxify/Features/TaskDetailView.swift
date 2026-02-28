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
                                        .font(.system(size: 20))
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
       
        .sheet(isPresented: $viewModel.taskCompleted) {
            TaskCompletionView(
                score: viewModel.score,
                totalQuestions: viewModel.tasks.count,
                livesLeft: viewModel.lives,
                difficulty: "Mittel",
                onContinue: {
                    viewModel.taskCompleted = false
                    dismiss()
                },
                onRetry: {
                    viewModel.startTasks()
                },
                onHome: {  // NEW: Home button action
                    viewModel.taskCompleted = false
                    dismiss()
                }
            )
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

// MARK: - Task Completion View
struct TaskCompletionView: View {
    let score: Int
    let totalQuestions: Int
    let livesLeft: Int
    let difficulty: String
    let onContinue: () -> Void
    let onRetry: () -> Void
    let onHome: () -> Void  // NEW: Home button action
    
    @State private var showAnimation = false
    @State private var showScore = false
    @State private var showDetails = false
    @State private var showButtons = false
    
    private var percentage: Int {
        Int((Double(score) / Double(totalQuestions)) * 100)
    }
    
    private var rating: String {
        switch percentage {
        case 90...100: return "Perfekt! ⭐️"
        case 70..<90: return "Sehr gut! 👍"
        case 50..<70: return "Gut gemacht! ✨"
        default: return "Weiter üben! 💪"
        }
    }
    
    private var ratingColor: Color {
        switch percentage {
        case 90...100: return .green
        case 70..<90: return .blue
        case 50..<70: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [ratingColor.opacity(0.3), Color(UIColor.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Success Animation Circle
                ZStack {
                    // Outer pulsing rings
                    if showAnimation {
                        Circle()
                            .stroke(ratingColor.opacity(0.3), lineWidth: 2)
                            .frame(width: 200, height: 200)
                            .scaleEffect(showAnimation ? 1.2 : 0.8)
                            .opacity(showAnimation ? 0 : 1)
                            .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: showAnimation)
                    }
                    
                    // Main circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [ratingColor, ratingColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 150)
                        .shadow(color: ratingColor.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    // Checkmark or trophy
                    Image(systemName: percentage >= 70 ? "checkmark" : "trophy.fill")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(showAnimation ? 1 : 0)
                        .rotationEffect(.degrees(showAnimation ? 0 : -180))
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showAnimation)
                }
                .padding(.bottom, 30)
                
                // Rating text
                Text(rating)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(ratingColor)
                    .opacity(showScore ? 1 : 0)
                    .offset(y: showScore ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: showScore)
                
                // Score
                HStack(spacing: 8) {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("/ \(totalQuestions)")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .opacity(showScore ? 1 : 0)
                .offset(y: showScore ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: showScore)
                
                // Percentage badge
                Text("\(percentage)%")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(ratingColor)
                    )
                    .opacity(showScore ? 1 : 0)
                    .offset(y: showScore ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: showScore)
                
                Spacer()
                
                // Stats Cards
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        // Difficulty Card
                        TaskStatCard(
                            icon: "chart.bar.fill",
                            title: "Schwierigkeit",
                            value: difficulty,
                            color: .purple
                        )
                        
                        // Hearts Card
                        TaskStatCard(
                            icon: "heart.fill",
                            title: "Übrige Herzen",
                            value: "\(livesLeft)",
                            color: .red
                        )
                    }
                    
                    // Performance message
                    VStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        
                        Text(performanceMessage)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.secondarySystemGroupedBackground))
                    )
                }
                .padding(.horizontal, 24)
                .opacity(showDetails ? 1 : 0)
                .offset(y: showDetails ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: showDetails)
                
                Spacer()
                
                // Action Buttons -Weiter & Home-
                VStack(spacing: 12) {
                    // Primary: Continue button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("Weiter")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ratingColor)
                        )
                    }
                    
                    // Secondary buttons row
                    HStack(spacing: 12) {
                        // Retry button
                        Button(action: onRetry) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Wiederholen")
                            }
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.8), value: showButtons)
            }
        }
        .onAppear {
            // Trigger animations sequentially
            withAnimation {
                showAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showScore = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                showDetails = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showButtons = true
            }
        }
    }
    
    private var performanceMessage: String {
        if livesLeft == 3 && score == totalQuestions {
            return "Perfekter Durchlauf! Du hast alle Fragen richtig beantwortet und keine Herzen verloren!"
        } else if score == totalQuestions {
            return "Hervorragend! Alle Fragen richtig beantwortet!"
        } else if livesLeft > 0 {
            return "Gut gemacht! Du hast \(score) von \(totalQuestions) Fragen richtig beantwortet."
        } else {
            return "Knapp geschafft! Übe weiter, um besser zu werden."
        }
    }
}

// MARK: - Task Stat Card
struct TaskStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
    }
}
// MARK: - Task Type Content Views

struct MultipleChoiceContent: View {
    let task: Task
    @ObservedObject var viewModel: TasksViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Check if it's an SF Symbol or Asset image
            if let images = task.imageName, let firstImage = images.first {
                if UIImage(systemName: firstImage) != nil {
                    // It's an SF Symbol
                    Image(systemName: firstImage)
                        .font(.system(size: 100))
                } else {
                    // It's an asset image
                    Image(firstImage)  // Just use the name from Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
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
                
                // Display the background image (refrigerator diagram) if available
                if let images = task.imageName, let firstImage = images.first {
                    GeometryReader { geometry in
                        ZStack {
                            // Background image - using same logic as MultipleChoiceContent
                            if UIImage(systemName: firstImage) != nil {
                                // It's an SF Symbol
                                Image(systemName: firstImage)
                                    .font(.system(size: 120))
                                    .foregroundColor(.gray.opacity(0.3))
                            } else {
                                // It's an asset image
                                Image(firstImage)
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.3) // Make it subtle so drop zones are visible
                            }
                            
                            // Drop zones overlay
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
                        }
                    }
                } else {
                    // No image, just show the diagram
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
                }
            }
            .frame(maxHeight: .infinity) // Expand to fill space

            // Draggable items at bottom
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
    
    // Check if the current answer is correct
    private var isCorrect: Bool {
        guard let config = task.sliderConfig else { return false }
        return abs(currentValue - config.correctValue) <= config.tolerance
    }
    
    // Determine circle color based on state
    private var circleColor: Color {
        if viewModel.isAnswerChecked {
            return isCorrect ? .green : .red
        } else {
            return .gray.opacity(0.3) // Default color when not checked
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Value display - glass effect circle
            ZStack {
                // Background circle that changes color when checked
                if viewModel.isAnswerChecked {
                    Circle()
                        .fill(isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                } else {
                    Circle()
                        .fill(.ultraThinMaterial)
                }
                // Border that changes color when checked
                Circle()
                    .stroke(
                        viewModel.isAnswerChecked ?
                            (isCorrect ? Color.green : Color.red) :
                            Color.gray.opacity(0.3),
                        lineWidth: 3
                    )
                    .frame(width: 150, height: 150)
                
                VStack {
                    Text("\(Int(currentValue))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(viewModel.isAnswerChecked ? (isCorrect ? .green : .red) : .primary)
                    Text(task.sliderConfig?.unit ?? "")
                        .font(.system(size: 24))
                        .foregroundColor(viewModel.isAnswerChecked ? (isCorrect ? .green : .red) : .secondary)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.isAnswerChecked)
            .animation(.easeInOut(duration: 0.3), value: isCorrect)

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
                        .disabled(viewModel.isAnswerChecked) // Disable slider after checking
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
    @State private var showSuccessAnimation = false
    
    // Check if all items are placed
    private var allItemsPlaced: Bool {
        selectedItems.count == (task.sequenceItems?.count ?? 0)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Visual timeline at top
            if !selectedItems.isEmpty {
                VStack(spacing: 12) {
                    Text("Deine Reihenfolge:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Horizontal connected timeline
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(Array(selectedItems.enumerated()), id: \.element.id) { index, item in
                                HStack(spacing: 0) {
                                    // Timeline node
                                    TimelineNode(
                                        number: index + 1,
                                        text: item.text,
                                        imageName: item.imageName,
                                        isCorrect: viewModel.isAnswerChecked ? item.correctPosition == index + 1 : nil,
                                        onRemove: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedItems.removeAll { $0.id == item.id }
                                                checkCompletion()
                                            }
                                        }
                                    )
                                    
                                    // Connector line (except for last item)
                                    if index < selectedItems.count - 1 {
                                        ConnectorLine()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 120)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
            } else {
                // Empty state with instruction
                VStack(spacing: 12) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .symbolEffect(.bounce, value: selectedItems.count)
                    
                    Text("Tippe die Schritte in der richtigen Reihenfolge")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Baue den Kältekreislauf Schritt für Schritt auf")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                        .fill(Color.blue.opacity(0.05))
                )
                .padding(.horizontal)
            }
            
            // Divider with animation hint
            if !allItemsPlaced {
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "hand.tap.fill")
                            .font(.caption)
                        Text("Verfügbare Schritte")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.secondary)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal)
            }
            
            // Available items as attractive cards
            LazyVStack(spacing: 12) {
                ForEach(availableItems) { item in
                    SequenceCard(item: item, position: nil) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedItems.append(item)
                            checkCompletion()
                        }
                    }
                    .disabled(viewModel.isAnswerChecked)
                    .opacity(viewModel.isAnswerChecked ? 0.5 : 1)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
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

// MARK: - Timeline Node (for the sequence display)
struct TimelineNode: View {
    let number: Int
    let text: String
    let imageName: String?
    let isCorrect: Bool? // nil = not checked, true = correct, false = wrong
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Number circle with status
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 44, height: 44)
                    .shadow(color: shadowColor, radius: 4, x: 0, y: 2)
                
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark" : "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(number)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Icon if available
            if let imageName = imageName {
                Image(systemName: imageName)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
            }
            
            // Text label
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
            
            // Remove button (only when not checked)
            if isCorrect == nil {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red.opacity(0.7))
                }
            }
        }
        .frame(width: 90)
    }
    
    private var backgroundColor: Color {
        guard let isCorrect = isCorrect else { return .blue }
        return isCorrect ? .green : .red
    }
    
    private var shadowColor: Color {
        guard let isCorrect = isCorrect else { return .blue.opacity(0.3) }
        return isCorrect ? .green.opacity(0.3) : .red.opacity(0.3)
    }
    
    private var iconColor: Color {
        guard let isCorrect = isCorrect else { return .blue }
        return isCorrect ? .green : .red
    }
}

// MARK: - Connector Line
struct ConnectorLine: View {
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .cyan.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 30, height: 3)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.cyan)
        }
        .frame(width: 40)
    }
}

// MARK: - Sequence Card (for available items)
struct SequenceCard: View {
    let item: SequenceItem
    let position: Int? // nil = not placed yet
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Step number or placeholder
                ZStack {
                    if let pos = position {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 36, height: 36)
                        Text("\(pos)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                            .frame(width: 36, height: 36)
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
                
                // Icon
                if let imageName = item.imageName {
                    Image(systemName: imageName)
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                        .frame(width: 40)
                }
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.text)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text("Schritt \(item.correctPosition) im Kreislauf")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Arrow indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue.opacity(0.5))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(position == nil ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: position)
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
