import Foundation

final class LocalStoryStateDataSource: StoryStateDataSource {
    private let defaults = UserDefaults.standard
    private let seenStoriesKey = "seenStories"
    private let likedStoriesKey = "likedStories"
    
    var likedStoriesIds: Set<String> {
        Set(defaults.stringArray(forKey: likedStoriesKey) ?? [])
    }
    
    var seenStoriesIds: Set<String> {
        Set(defaults.stringArray(forKey: seenStoriesKey) ?? [])
    }
    
    func toggleStoryLike(_ storyId: String) {
        var likedStories = likedStoriesIds
        if likedStories.contains(storyId) {
            likedStories.remove(storyId)
        } else {
            likedStories.insert(storyId)
        }
        defaults.set(Array(likedStories), forKey: likedStoriesKey)
    }
    
    func markStorySeen(_ storyId: String) {
        var seenStories = seenStoriesIds
        seenStories.insert(storyId)
        defaults.set(Array(seenStories), forKey: seenStoriesKey)
    }
}
