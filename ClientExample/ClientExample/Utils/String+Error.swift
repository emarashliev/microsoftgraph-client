//
//  String+Error.swift
//  ClientExample
//
//  Created by Emil Marashliev on 18.10.24.
//

import Foundation

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? { return self }
}

