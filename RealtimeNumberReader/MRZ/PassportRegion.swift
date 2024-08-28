//
//  PassportRegion.swift
//  RealtimeNumberReader
//
//  Created by Ben Shutt on 28/08/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit

// Note: A structure is perhaps over-engineering for this simplified use case.
// A static function would be enough, but added for future configuration.

/// Compute the desired masked region size for scanning a passport.
/// Width and height components represent a scale in `[0, 1]`.
/// The device orientation is taken into account.
struct PassportRegion {

    /// Maximum amount of space to take along an axis
    private static let maxPortraitScale = 0.8

    /// Width (short-side) over height (long-side) aspect ratio of a passport.
    /// ISO/IEC 7810 ID-3 standard, (height) 125 × 88 (width) in mm
    private static let passportAspectRatio: CGFloat = 88.0 / 125

    /// Width of the masked region
    private let width: Double

    /// Height of the masked region
    private let height: Double

    /// Map width and height properties to `CGSize`
    var size: CGSize {
        .init(width: width, height: height)
    }

    /// Initialize by scaling the width and height linearly by the passport aspect ratio
    /// - Warning: The `uiRotationTransform` changes what is considered "width' and "height"
    init(orientation: UIDeviceOrientation) {
        if orientation.isPortrait || orientation == .unknown {
            width = Self.maxPortraitScale
            height = width * Self.passportAspectRatio
        } else {
            height = Self.maxPortraitScale
            width = height * Self.passportAspectRatio
        }
    }
}
