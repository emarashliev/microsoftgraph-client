import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes
import Foundation

public struct MicrosoftgraphClient {
    public static func createClient(bearerToken: String) -> any APIProtocol {
        return Client(
            serverURL: URL(string: "https://graph.microsoft.com/v1.0")!,
            transport: URLSessionTransport(),
            middlewares: [GraphMiddleware(bearerToken: bearerToken)]
        )
    }
}

fileprivate struct GraphMiddleware: ClientMiddleware {
    let bearerToken: String
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = "Bearer \(bearerToken)"
        return try await next(request, body, baseURL)
    }
}
