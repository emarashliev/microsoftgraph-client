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
            let body = try result.successful.body.json
            print(body)
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
