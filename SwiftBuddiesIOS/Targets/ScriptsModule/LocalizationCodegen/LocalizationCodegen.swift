
//
//  main.swift
//  Localization
//
//  Created by Can Yoldas on 25/04/2024.
//

import Foundation
import ArgumentParser

/// Credits to Tiziano Coroneo
@main
struct LocalizationCodegen: AsyncParsableCommand {
    
    var projectDirectoryURL: URL {
        let scriptURL = URL(fileURLWithPath: #file)
        let projectDirectoryURL = scriptURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            
        
         return projectDirectoryURL
    }

    func run() throws {
        let fileName = "Localizable.xcstrings"
        let fileURL = projectDirectoryURL
            .appendingPathComponent("LocalizationModule")
            .appendingPathComponent("Resources")
            .appendingPathComponent(fileName)
        
        
       let _ = generateStaticKeys(fromFileAtPath: fileURL.path())
    }
    
    func generateStaticKeys(fromFileAtPath filePath: String) -> [String] {
        print(FileManager.default.fileExists(atPath: filePath).description)
        guard let data = FileManager.default.contents(atPath: filePath) else {
            print("Failed to read file at path: \(filePath)")
            return []
        }
        
        var lines: [LocalizedLine] = []
        
        do {
            let decodedData = try JSONDecoder().decode(Localizable.self, from: data)
            
            for (key,val) in decodedData.strings {
                lines.append(.init(key: key, value: val.localizations?.en?.stringUnit?.value ?? ""))
            }
            dump(decodedData)
        } catch {
            print("error decoding: \(error.localizedDescription)")
            return []
        }
        
        let fileContent = makeAllContent(
            localizationKeys: lines)
        
        let fileURL = projectDirectoryURL
            .appendingPathComponent("LocalizationModule")
            .appendingPathComponent("Sources")
            .appendingPathComponent("GeneratedLocalizationStrings.swift")
        
        do {
            let newData: Data = fileContent.data(using: .utf8)!
            try newData.write(to: URL(filePath: fileURL.path()), options: [.atomic])
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func makePropertyFor(
        content: LocalizedLine,
        depth: Int
    ) -> String {
        """
        \(String(repeating: "    ", count: depth))/// \(content.value)
        \(String(repeating: "    ", count: depth))@LocalizedString(key: "\(content.key)") public static var \(sanitizeName(content.key)): Text
        """
    }
    
    func makeAccessorStruct() -> String {
    """
    import SwiftUI

    @propertyWrapper
    public struct LocalizedString {
        public let key: String
        public init(key: String) { self.key = key }

        public var wrappedValue: Text { Text(LocalizedStringKey(self.key), bundle: .module) }
        public var projectedValue: LocalizedString { self }
        public var localized: String { NSLocalizedString(self.key, bundle: .module, comment: "") }
        public func format(_ arguments: CVarArg...) -> String { String(format: localized, arguments: arguments) }
        public func callAsFunction(_ arguments: CVarArg...) -> String { String(format: localized, arguments: arguments) }
    }
    
    """
}
    
    func makeAllContent(
        localizationKeys: [LocalizedLine]
    ) -> String {
        """
        \(makeAccessorStruct())

        \(makeAccessorList(localizationKeys))

        """
    }
    
    func makeAccessorList(
        _ list: [LocalizedLine]
    ) -> String {
        let content = list
            .sorted()
            .map { makePropertyFor(content: $0, depth: 1) }
            .joined(separator: "\n")

        return """
        // MARK: - Localized strings keys

        public enum L {
        \(content)
        }
        """
    }

    private var keywords: Set<String> = [
        "associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "precedencegroup", "protocol", "public", "rethrows", "static", "struct", "subscript", "typealias", "var", "break", "case", "catch", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "throw", "switch", "where", "while", "Any", "as", "await", "catch", "false", "is", "nil", "rethrows", "self", "Self", "super", "throw", "throws", "true", "try", "associativity", "convenience", "didSet", "dynamic", "final", "get", "indirect", "infix", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "some", "Type", "unowned", "weak", "willSet",
    ]

    func sanitizeName<S: StringProtocol>(_ name: S) -> String {
        var newName = name
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        if newName.starts(with: #/\d/#) {
            newName = "_\(newName)"
        }

        if keywords.contains(newName) {
            newName = "`\(newName)`"
        }

        return newName.lowercased()
    }
}

struct LocalizedLine: Comparable {
    static func < (lhs: LocalizedLine, rhs: LocalizedLine) -> Bool {
        lhs.key < rhs.value
    }
    
    let key: String
    let value: String
}

struct Localizable: Codable {
    let strings: [String: StringValue]
}

// MARK: - StringValue
struct StringValue: Codable {
    let localizations: Localizations?
}

// MARK: - Localizations
struct Localizations: Codable {
    let en: En?
}

// MARK: - En
struct En: Codable {
    let stringUnit: StringUnit?
}

// MARK: - StringUnit
struct StringUnit: Codable {
    let value: String?
}
