import Foundation
import BuddiesNetwork

public final class BuddiesJSONDecodingInterceptor: Interceptor {
    public var id: String = UUID().uuidString
    
    public func intercept<Request>(
        chain: RequestChain,
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, Error>) -> Void
    ) where Request: Requestable {
        guard let response = response else {
            chain.proceed(request: request, interceptor: self, response: response, completion: completion)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let result = try decoder.decode(Request.Data.self, from: response.rawData)
            completion(.success(result))
        } catch let decodingError as DecodingError {
            let detailedError = handleDecodingError(decodingError, data: response.rawData)
            completion(.failure(detailedError))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func handleDecodingError(_ error: DecodingError, data: Data) -> Error {
        let description: String
        
        switch error {
        case .keyNotFound(let key, let context):
            description = """
                Key '\(key.stringValue)' not found
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                """
            
        case .valueNotFound(let type, let context):
            description = """
                Value of type '\(type)' not found
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                """
            
        case .typeMismatch(let type, let context):
            description = """
                Type mismatch for type '\(type)'
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                """
            
        case .dataCorrupted(let context):
            description = """
                Data corrupted
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                """
            
        @unknown default:
            description = error.localizedDescription
        }
        
        // Print raw JSON for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🚨 Decoding Error Details:")
            print("Error: \(description)")
            print("Raw JSON:")
            print(jsonString)
        }
        
        return NSError(
            domain: "JSONDecodingInterceptor",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: description]
        )
    }
} 
