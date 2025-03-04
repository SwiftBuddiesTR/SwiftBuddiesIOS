import Foundation
import BuddiesNetwork

public final class BuddiesJSONDecodingInterceptor: Interceptor {
    public var id: String = UUID().uuidString
    
    public func intercept<Request>(
        chain: RequestChain,
        operation: HTTPOperation<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping HTTPResultHandler<Request>
    ) where Request: Requestable {
        guard let response = response else {
            chain.proceed(
                operation: operation,
                interceptor: self,
                response: response,
                completion: completion
            )
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let result = try decoder.decode(Request.Data.self, from: response.rawData)
            response.parsedData = result
            
            chain.proceed(
                operation: operation,
                interceptor: self,
                response: response,
                completion: completion
            )
        } catch let decodingError as DecodingError {
            let detailedError = handleDecodingError(decodingError, data: response.rawData, for: operation.properties.requestName)
            completion(.failure(detailedError))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func handleDecodingError(_ error: DecodingError, data: Data, for model: any Decodable) -> Error {
        let description: String
        
        switch error {
        case .keyNotFound(let key, let context):
            description = """
                Key '\(key.stringValue)' not found
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                for model: \(model)
                """
            
        case .valueNotFound(let type, let context):
            description = """
                Value of type '\(type)' not found
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                for model: \(model)
                """
            
        case .typeMismatch(let type, let context):
            description = """
                Type mismatch for type '\(type)'
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                for model: \(model)
                """
            
        case .dataCorrupted(let context):
            description = """
                Data corrupted
                Debug: \(context.debugDescription)
                Coding Path: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                for model: \(model)
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
