//
//  ContentView.swift
//  ClientExample
//
//  Created by Emil Marashliev on 8.07.24.
//

import SwiftUI
import MicrosoftgraphClient
import MSAL

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                Task {
                    do {
                        try await onButtonPressed()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Press me 😏")
            }
        }
        .padding()
    }

    func onButtonPressed() async throws {
        let bearerToken = try await getToken()
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

    func getToken() async throws -> String {
        let clientID = "" // Add your client ID here
        let scopes: [String] = ["user.read"]

        let config = MSALPublicClientApplicationConfig(clientId: clientID)
        let application = try MSALPublicClientApplication(configuration: config)

        guard let topController = getTopController() else { throw "topController is nil" }

        let webviewParameters = MSALWebviewParameters(authPresentationViewController: topController)
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
        let result = try await application.acquireToken(with: interactiveParameters)

        return result.accessToken
    }

    func getTopController() -> UIViewController? {
        var topController = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last?
            .rootViewController

        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}

#Preview {
    ContentView()
}
