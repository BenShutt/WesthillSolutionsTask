//
//  MRZParser.swift
//  RealtimeNumberReader
//
//  Created by Ben Shutt on 28/08/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

/// The string represents a valid MRZ.
typealias MRZ = String

/// Determine if a given string is a valid MRZ according to the _task criteria requirements_.
///
/// # Notes
/// Given the time in a production app, my more stringent approach
/// would probably look like a structure with:
///
/// ```swift
/// struct MRZ {
///     var documentType: DocumentType // Enum, p for passport
///     var countryCode: CountryCode // Enum, GBR for UK+NI
///     var lastName: String
///     var firstNames: [String]
///     // etc
///
///     init(_ string: String) throws -> MRZ { ... }
/// }
/// ```
///
/// The logic for the parsing would also be stricter; e.g. potentially using regex(s) to ensure
/// the MRZ is composed of valid characters.
/// It goes without saying, this is a huge candidate for a lot of ruthless unit tests!
struct MRZParser {

    /// An MRZ filler character.
    private static let filler: Character = "<"

    /// Range of possible line counts for a valid MRZ.
    static let lineCounts = 2...3

    /// Set of valid character counts per line. All lines will have the same length
    /// matching one of these values.
    static let lineCharacterCounts: Set<Int> = [30, 36, 44]

    /// Parse the given string using the following criteria:
    /// - Strip spaces
    /// - A `<` in (the first line) of length 44, 36, or 30 characters
    /// - 2 (passport) or 3 remaining lines of the same length (44 for a passport).
    ///
    /// Though I think the word "remaining" above may be misleading, an MRZ
    /// can have 1 to 3 lines (inclusive).
    static func parse(_ string: String) throws -> MRZ {
        // Trim leading and trailing whitespace and new-lines
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)

        // Split by the new-line component (for iOS systems)
        let lines = trimmed.split(separator: "\n")
        guard lineCounts.contains(lines.count) else {
            throw MRZParserError.numberOfLines(lines.count)
        }

        // Get the number of characters in the first line and 
        // ensure it is a valid value
        let firstLineCount = lines[0].count // We have ≥1 elements
        guard lineCharacterCounts.contains(firstLineCount) else {
            throw MRZParserError.lineCharacterCount(firstLineCount)
        }

        // Check that each line has the same number of characters
        try lines.dropFirst().forEach { line in
            guard line.count == firstLineCount else {
                throw MRZParserError.lineCount
            }
        }

        // Check the first line contains a filler
        guard Set(lines[0]).contains(filler) else {
            throw MRZParserError.filler
        }

        // Return the trimmed MRZ
        return trimmed
    }
}

// MARK: - MRZParserError

/// An `Error` thrown by an `MRZParser` instance
enum MRZParserError: Error {

    /// The given number of lines is not valid for an MRZ
    case numberOfLines(Int)

    /// The given line character count is not valid for an MRZ
    case lineCharacterCount(Int)

    /// Not all lines have the same length
    case lineCount

    /// The first line is missing a filler character
    case filler
}
