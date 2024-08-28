//
//  UILabel+Extensions.swift
//  RealtimeNumberReader
//
//  Created by Ben Shutt on 28/08/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit

extension UILabel {

    /// Update the height of the frame to fit the content it is showing.
    /// - Note: This is very old and this workaround is only required due to the existing implementation.
    /// Even for an app like this, I would have done it with a top and width constraint so that the
    /// label resizes itself
    /// - Parameter padding: Additional vertical padding
    func heightToFit(padding: CGFloat = 10) {
        // Compute the content height without modifying the width
        let height = sizeThatFits(.init(
            width: frame.width,
            height: .greatestFiniteMagnitude
        )).height

        // Set the new height on the frame
        frame.size.height = height + padding
    }
}
