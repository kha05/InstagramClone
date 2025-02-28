import SwiftUI
import Kingfisher

struct StoryDetailView: View {
    // MARK: - Properties
    let story: Story
    @ObservedObject var viewModel: StoriesListViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedStory: Story?

    @State private var progressValue: Double = 0
    @State private var timer: Timer?

    // MARK: - Computed Properties
    private var currentStory: Story? {
        viewModel.stories.first(where: { $0.id == story.id })
    }

    // MARK: - Body
    var body: some View {
        Group {
            if let currentStory = currentStory {
                ZStack {
                    Color.black.ignoresSafeArea()

                    VStack(spacing: 0) {
                        progressBar

                        ZStack {
                            storyImage(for: currentStory)
                            gestureAreas
                            controlsOverlay(for: currentStory)
                        }
                    }
                }
                .onAppear {
                    viewModel.markStorySeen(currentStory.id)
                    startTimer()
                }
                .onDisappear {
                    timer?.invalidate()
                }
            }
        }
    }
}

private extension StoryDetailView {
    // MARK: - UI Components
    var progressBar: some View {
        ProgressView(value: min(1.0, max(0.0, progressValue)), total: 1.0)
            .progressViewStyle(LinearProgressViewStyle(tint: .white))
            .padding(.top, 1)
    }

    func storyImage(for story: Story) -> some View {
        KFImage(URL(string: story.content.imageUrl))
            .placeholder {
                ProgressView()
                    .foregroundColor(.white)
            }
            .fade(duration: 0.3)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    var gestureAreas: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(perform: showPreviousStory)
                .frame(width: UIScreen.main.bounds.width * 0.3)

            Color.clear
                .contentShape(Rectangle())
                .onLongPressGesture(minimumDuration: .infinity) {
                } onPressingChanged: { isPressing in
                    isPressing ? pauseTimer() : resumeTimer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.4)

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(perform: showNextStory)
                .frame(width: UIScreen.main.bounds.width * 0.3)
        }
    }

    func controlsOverlay(for story: Story) -> some View {
        VStack {
            header(for: story)

            Spacer()

            footer(for: story)
        }
    }

    func header(for story: Story) -> some View {
        HStack {
            KFImage(URL(string: story.user.profilePictureUrl))
                .placeholder {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                }
                .fade(duration: 0.25)
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())

            Text(story.user.name)
                .foregroundColor(.white)
                .font(.subheadline)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
        }
        .padding()
    }

    func footer(for story: Story) -> some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    viewModel.toggleLike(for: story.id)
                }
            } label: {
                Image(systemName: story.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(story.isLiked ? .red : .white)
                    .font(.system(size: 24))
                    .scaleEffect(story.isLiked ? 1.2 : 1.0)
            }
            Spacer()
        }
        .padding()
    }

    // MARK: - Navigation
    func showPreviousStory() {
        if let previousStory = getPreviousStory() {
            withAnimation {
                selectedStory = previousStory
                resetTimer()
            }
        }
    }

    func showNextStory() {
        if let nextStory = getNextStory() {
            withAnimation {
                selectedStory = nextStory
                resetTimer()
            }
        } else {
            dismiss()
        }
    }

    func getPreviousStory() -> Story? {
        guard let currentStory = currentStory,
              let currentIndex = viewModel.stories.firstIndex(where: { $0.id == currentStory.id }) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return viewModel.stories[previousIndex]
    }

    func getNextStory() -> Story? {
        guard let currentStory = currentStory,
              let currentIndex = viewModel.stories.firstIndex(where: { $0.id == currentStory.id }) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        guard nextIndex < viewModel.stories.count else {
            return nil
        }
        return viewModel.stories[nextIndex]
    }

    // MARK: - Timer Management
    private func startTimer() {
        progressValue = 0.0

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let newValue = self.progressValue + 0.02

            if newValue >= 1.0 {
                timer.invalidate()
                self.progressValue = 1.0
                self.showNextStory()
            } else {
                self.progressValue = newValue
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
    }

    func resumeTimer() {
        startTimer()
    }

    func resetTimer() {
        timer?.invalidate()
        progressValue = 0
        startTimer()
    }
}
