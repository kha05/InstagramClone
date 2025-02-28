import SwiftUI
import Kingfisher
import Resolver

@main
struct InstagramCloneApp: App {
    init() {
        configureKingfisher()
        configureResolver()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureKingfisher() {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024 // 300 MB
        cache.diskStorage.config.sizeLimit = 1000 * 1024 * 1024 // 1 GB

        KingfisherManager.shared.defaultOptions = [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]
    }

    private func configureResolver() {
        Resolver.registerAllServices()
    }
}
