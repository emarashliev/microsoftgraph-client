//
//  ContentView.swift
//  MicrosoftgraphClient
//
//  Created by Emil Marashliev on 29.06.24.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes

struct ContentView: View {
    
    let client: any APIProtocol
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
    init(client: (any APIProtocol)? = nil) {
        if let client = client {
            self.client = client
        } else {
            self.client = Client(
                serverURL: URL(string: "https://graph.microsoft.com/v1.0")!,
                transport: URLSessionTransport(),
                middlewares: [GraphMiddleware()]
            )
        }
    }
}

struct GraphMiddleware: ClientMiddleware {
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        let bearerToken = ProcessInfo.processInfo.environment["BEARER_TOKEN"]
        var request = request
        request.headerFields[.authorization] = "Bearer \(bearerToken!)"
        return try await next(request, body, baseURL)
    }
}


#Preview {
    ContentView()
}
