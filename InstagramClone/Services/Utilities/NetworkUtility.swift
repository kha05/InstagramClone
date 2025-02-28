import Foundation

protocol NetworkUtilityProtocol {
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    func fetchData(from urlString: String) async throws -> Data
}

final class NetworkUtility: NetworkUtilityProtocol {
    private let session = URLSession.shared
    
    func fetch<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw RemoteError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RemoteError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw RemoteError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RemoteError.decodingError(error)
        }
    }
    
    func fetchData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw RemoteError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RemoteError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw RemoteError.serverError(httpResponse.statusCode)
        }
        
        return data
    }
    
    enum RemoteError: Error {
        case invalidURL
        case invalidResponse
        case serverError(Int)
        case decodingError(Error)
    }
}
