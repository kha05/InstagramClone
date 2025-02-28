protocol LoadDataUseCaseProtocol {
    func loadInitialData() async throws
    func getNextPage() -> [User]?
}

final class LoadDataUseCase: LoadDataUseCaseProtocol {
    private var currentPageIndex = 0
    private var loadedAllPages = false
    private var cachedUsers: [[User]] = []
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func loadInitialData() async throws {
        let users = try await userRepository.getUsers(page: 0)
        cachedUsers = [users]
        currentPageIndex = 0
        loadedAllPages = users.isEmpty
    }
    
    func getNextPage() -> [User]? {
        if currentPageIndex < cachedUsers.count {
            let users = cachedUsers[currentPageIndex]
            currentPageIndex = (currentPageIndex + 1) % max(1, cachedUsers.count)
            return users
        }
        
        if loadedAllPages {
            currentPageIndex = 0
            return cachedUsers.first
        }

        Task {
            do {
                let nextPage = cachedUsers.count
                let users = try await userRepository.getUsers(page: nextPage)
                
                if users.isEmpty {
                    loadedAllPages = true
                } else {
                    cachedUsers.append(users)
                }
            } catch {
                print("Error loading page: \(error)")
                loadedAllPages = true
            }
        }

        currentPageIndex = 0
        return cachedUsers.first
    }
}
