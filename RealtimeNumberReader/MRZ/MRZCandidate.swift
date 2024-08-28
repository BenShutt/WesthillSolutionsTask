//
//  MRZCandidate.swift
//  RealtimeNumberReader
//
//  Created by Ben Shutt on 28/08/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
import Vision

/// Group the results of recognised text into lines of the same count that may be a valid MRZ
struct MRZCandidate {

    /// Map the results into lines of text.
    /// Group these lines when they match the line count of the line above and have
    /// a character count of a valid MRZ.
    /// - Parameter results: Camera observed text results
    /// - Returns: Groups of lines which may be a valid MRZ
    static func groupLines(results: [VNRecognizedTextObservation]) -> [[String]] {
        let maximumCandidates = MRZParser.lineCounts.upperBound
        let lines = results.flatMap { visionResult in
            visionResult.topCandidates(maximumCandidates)
                .map { $0.string }
        }

        var groups: [[String]] = []
        var currentGroup: [String] = []
        var lastLineCharacterCount: Int?

        lines.forEach { line in
            if line.count == lastLineCharacterCount {
                // Same character count as the line before.
                // Add to group and move onto the next line
                currentGroup.append(line)
                return
            }

            // Line count different to the one above, we are onto a new group.
            // Commit any existing groups
            if !currentGroup.isEmpty {
                groups.append(currentGroup)
            }

            if MRZParser.lineCharacterCounts.contains(line.count) {
                // Different line character count to before but a valid line.
                // Start a new group
                lastLineCharacterCount = line.count
                currentGroup = [line]
            } else {
                // Invalid line, reset properties
                lastLineCharacterCount = nil
                currentGroup = []
            }
        }

        // Commit any existing groups
        if !currentGroup.isEmpty {
            groups.append(currentGroup)
        }

        return groups
    }
}
