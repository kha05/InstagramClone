import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StoriesListViewModel()
    @State private var selectedStory: Story?

    var body: some View {
        NavigationView {
            VStack {
                storiesScrollView

                Spacer()

                Text("BeReal Stories Test")
                    .font(.headline)

                Spacer()
            }
            .navigationTitle("Stories")
            .fullScreenCover(item: $selectedStory) { story in
                StoryDetailView(
                    story: story,
                    viewModel: viewModel,
                    selectedStory: $selectedStory
                )
            }
        }
    }

    private var storiesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(viewModel.stories) { story in
                    StoryPreviewView(story: story)
                        .onTapGesture {
                            selectedStory = story
                        }
                        .onAppear {
                            if story == viewModel.stories.last {
                                Task {
                                    await viewModel.loadMoreStories()
                                }
                            }
                        }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding(.horizontal, 20)
                }
            }
            .padding()
        }
        .frame(height: 110)
        .background(Color(.systemGray6))
    }
}
