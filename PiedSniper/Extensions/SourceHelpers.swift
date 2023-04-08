//
//  SourceHelpers.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/9/23.
//

import Foundation

extension URL {
    /// - Parameters:
    ///   - cache: If a cache is provided, check if the data has already been downloaded
    ///   - forceExpire: If a cache is provided, force the cache to be invalidated for this request.
    /// - Returns: Scraped HTML for URL.
    func scrape(cache: NSCache<NSString, CacheEntryObject<String>>? = nil, forceExpire: Bool = false) async -> String? {
        if !forceExpire, let cached = cache?[self] {
            switch cached {
            case .ready(let result):
                return result
            case .inProgress(let task):
                return try? await task.value
            }
        }

        let task = Task<String, Error> {
            let (data, _) = try await URLSession.shared.data(from: self)
            return String(data: data, encoding: .utf8) ?? ""
        }

        cache?[self] = .inProgress(task)

        do {
            let result = try await task.value
            cache?[self] = .ready(result)
            return result
        } catch {
            cache?[self] = nil
            return nil
        }
    }

    func attributedScrape(cache: NSCache<NSString, CacheEntryObject<String>>) async -> NSAttributedString? {
        do {
            let (data, _) = try await URLSession.shared.data(from: self)
            let attrStr = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return attrStr
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
