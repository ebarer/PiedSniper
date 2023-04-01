//
//  SourceHelpers.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/9/23.
//

import Foundation

extension URL {
    /// Load the URL, scrape the HTML, then sanitize and separate the results.
    /// - Parameters:
    ///   - url: URL to scrape.
    /// - Returns: Returns unsanitized output for the specified URL.
    func scrape() async -> String? {
        do {
            let (data, _) = try await URLSession.shared.data(from: self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Bundle {
    /// Load the contents of the specified file.
    /// - Parameter file: File to load.
    /// - Returns: Returns unsanitized output for the specified file.
    func load(file: String?) -> String? {
        guard let fileName = file else { return nil }
        guard let path = path(forResource: fileName, ofType: "txt") else { return nil }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}
