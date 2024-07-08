//
//  ContentView.swift
//  ClientExample
//
//  Created by Emil Marashliev on 8.07.24.
//

import SwiftUI
import MicrosoftgraphClient

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                Task {
                    await onButtonPressed()
                }
            } label: {
                Text("Press me 😏")
            }
        }
        .padding()
    }
    
    func onButtonPressed() async {
        let bearerToken = ProcessInfo.processInfo.environment["BEARER_TOKEN"]!
        let client = MicrosoftgraphClient.createClient(bearerToken: bearerToken)
        do {
            let result = try await client.getUser(.init())
            switch result {
            case .successful(statusCode: let status, let body):
                let json = try body.body.json
                print(status)
                print(json)
            case .clientError(statusCode: let status, let error):
                let json = try error.body.json
                print("clientError - \(status)")
                print(json)
            case .serverError(statusCode: let status, let error):
                let json = try error.body.json
                print("serverError - \(status)")
                print(json)
            case .undocumented(statusCode: let status, let error):
                print("undocumented - \(status)")
                print(error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
