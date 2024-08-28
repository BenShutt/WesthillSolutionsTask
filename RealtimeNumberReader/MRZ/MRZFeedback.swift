//
//  MRZFeedback.swift
//  RealtimeNumberReader
//
//  Created by Ben Shutt on 28/08/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit

/// Feedback UI given to the user while they scan their MRZ.
///
/// # Note
/// At this stage, this entity is undoubtedly over-engineered.
/// In the future, it will become the observable model that publishes the state as feedback to the user.
/// Also, at this stage, the structure could be replaced by a `Result`.
enum MRZFeedback {

    /// The scan was successful and returned the given text
    case success(MRZ)

    /// The scan was unsuccessful with the given error message
    case failure(String)

    /// State title text, localized
    var title: String {
        switch self {
        case let .success(mrz): mrz
        case let .failure(string): string
        }
    }

    /// Overlay text color
    var textColor: UIColor {
        switch self {
        case .success: .darkGreen
        case .failure: .red
        }
    }
}
