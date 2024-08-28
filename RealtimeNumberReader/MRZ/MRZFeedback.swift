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
/// Not currently used as, at this stage, it is undoubtedly over-engineering.
/// In the future, it would become the observable model that publishes the state as feedback to the user.
/// Also, at this stage, the structure could be replaced by a `Result`.
enum MRZFeedback {

    /// The scan was successful and returned the given text
    case success(MRZ)

    /// The scan was unsuccessful
    case failure(String)

    /// Overlay title text
    var title: String {
        switch self {
        case let .success(mrz): mrz
        case let .failure(string): string
        }
    }

    /// Overlay text color
    var textColor: UIColor {
        switch self {
        case .success: .green
        case .failure: .red
        }
    }
}
