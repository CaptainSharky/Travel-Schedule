import SwiftUI
import Combine

struct StoriesViewerView: View {
    struct Configuration {
        let secondsPerStory: TimeInterval
        let timerTickInternal: TimeInterval
        let progressPerTickWithinStory: CGFloat

        init(
            secondsPerStory: TimeInterval = 10,
            timerTickInternal: TimeInterval = 0.05
        ) {
            self.secondsPerStory = secondsPerStory
            self.timerTickInternal = timerTickInternal
            self.progressPerTickWithinStory = CGFloat(timerTickInternal / secondsPerStory)
        }
    }

    @Binding private var stories: [Story]
    private let startStoryID: UUID
    private let configuration: Configuration

    @Environment(\.dismiss) private var dismiss

    @State private var storyIndices: [Int] = []
    @State private var currentPosition: Int = 0
    @State private var progressInStory: CGFloat = 0

    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?

    init(
        stories: Binding<[Story]>,
        startStoryID: UUID,
        configuration: Configuration = .init()
    ) {
        self._stories = stories
        self.startStoryID = startStoryID
        self.configuration = configuration
        self._timer = State(initialValue: Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common))
    }

    private var storiesCount: Int { storyIndices.count }

    private var currentStoryIndexInSource: Int? {
        guard !storyIndices.isEmpty, currentPosition < storyIndices.count else { return nil }
        return storyIndices[currentPosition]
    }

    private var currentStory: Story? {
        guard let idx = currentStoryIndexInSource, stories.indices.contains(idx) else { return nil }
        return stories[idx]
    }

    private var overallProgress: CGFloat {
        guard storiesCount > 0 else { return 0 }
        let base = CGFloat(currentPosition) / CGFloat(storiesCount)
        let addition = progressInStory / CGFloat(storiesCount)
        return min(max(base + addition, 0), 1)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let story = currentStory {
                StoryView(story: story)
            } else {
                Color.black.ignoresSafeArea()
            }

            HStack(spacing: 0) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { goPrevious() }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { goNextAndMarkViewed() }
            }
            .ignoresSafeArea()

            ProgressBar(numberOfSections: max(storiesCount, 1), progress: overallProgress)
                .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))

            CloseButton(action: { close() })
                .padding(.top, 57)
                .padding(.trailing, 12)
        }
        .onAppear {
            buildViewingSequenceOrDismiss()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onReceive(timer) { _ in
            timerTick()
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    handleDragEnded(value)
                }
        )
    }

    // MARK: - Sequence

    private func buildViewingSequenceOrDismiss() {
        let unviewed = stories.indices.filter { stories[$0].isViewed == false }
        guard !unviewed.isEmpty else {
            dismiss()
            return
        }
        guard let startIndex = stories.firstIndex(where: { $0.id == startStoryID }),
              let startPos = unviewed.firstIndex(of: startIndex) else {
            dismiss()
            return
        }

        storyIndices = Array(unviewed[startPos...])
        currentPosition = 0
        progressInStory = 0
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        timer = Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
        cancellable = timer.connect()
    }

    private func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }

    private func resetStoryTimer() {
        progressInStory = 0
        startTimer()
    }

    private func timerTick() {
        progressInStory += configuration.progressPerTickWithinStory
        if progressInStory >= 1 {
            goNextAndMarkViewed()
        }
    }

    // MARK: - Navigation

    private func markCurrentStoryViewed() {
        guard let idx = currentStoryIndexInSource else { return }
        guard stories.indices.contains(idx) else { return }
        if stories[idx].isViewed == false {
            stories[idx].isViewed = true
        }
    }

    private func goNextAndMarkViewed() {
        markCurrentStoryViewed()

        if currentPosition + 1 >= storiesCount {
            close()
            return
        }

        currentPosition += 1
        resetStoryTimer()
    }

    private func goPrevious() {
        guard currentPosition > 0 else {
            resetStoryTimer()
            return
        }
        currentPosition -= 1
        resetStoryTimer()
    }

    private func close() {
        stopTimer()
        dismiss()
    }

    // MARK: - Gestures

    private func handleDragEnded(_ value: DragGesture.Value) {
        let dx = value.translation.width
        let dy = value.translation.height

        if dy > 80, abs(dx) < 60 {
            close()
            return
        }

        if abs(dx) > abs(dy) {
            if dx < -60 {
                goNextAndMarkViewed()
            } else if dx > 60 {
                goPrevious()
            }
        }
    }
}
