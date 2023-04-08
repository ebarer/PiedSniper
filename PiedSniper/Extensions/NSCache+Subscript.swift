//
//  NSCache+Subscript.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject<String> {
    subscript(_ url: URL) -> CacheEntry<String>? {
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = url.absoluteString as NSString
            if let entry = newValue {
                let value = CacheEntryObject<String>(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
