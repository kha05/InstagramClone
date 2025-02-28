import XCTest
@testable import InstagramClone

final class LoadInitialStoriesUseCaseTests: XCTestCase {
    var sut: LoadInitialStoriesUseCase!
    var mockUserRepository: MockUserRepository!
    var mockStoryContentRepository: MockStoryContentRepository!
    var mockStoryStateRepository: MockStoryStateRepository!
    
    override func setUp() {
        super.setUp()
        mockUserRepository = MockUserRepository()
        mockStoryContentRepository = MockStoryContentRepository()
        mockStoryStateRepository = MockStoryStateRepository()
        
        sut = LoadInitialStoriesUseCase(
            userRepository: mockUserRepository,
            storyContentRepository: mockStoryContentRepository,
            storyStateRepository: mockStoryStateRepository
        )
    }
    
    override func tearDown() {
        sut = nil
        mockUserRepository = nil
        mockStoryContentRepository = nil
        mockStoryStateRepository = nil
        super.tearDown()
    }
    
    func testLoadInitialStoriesSuccess() async throws {
        // Given
        let mockUsers = [
            User(id: 1, name: "Test", profilePictureUrl: "test-url")
        ]
        mockUserRepository.users = mockUsers
        
        // When
        let stories = try await sut.execute()
        
        // Then
        XCTAssertEqual(stories.count, 1)
        XCTAssertEqual(mockUserRepository.getUsersCallCount, 1)
        XCTAssertEqual(mockStoryContentRepository.getContentCallCount, 1)
    }
    
    func testLoadInitialStoriesError() async {
        // Given
        struct TestError: Error {}
        mockUserRepository.error = TestError()
        
        // When/Then
        do {
            _ = try await sut.execute()
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
