//
//  CGSize.swift
//  NNSCANNER
//
//  Created by Nhat on 18/04/2023.
//

import Foundation

extension CGSize {
    /// Calculates an appropriate scale factor which makes the size fit inside both the `maxWidth` and `maxHeight`.
    /// - Parameters:
    ///   - maxWidth: The maximum width that the size should have after applying the scale factor.
    ///   - maxHeight: The maximum height that the size should have after applying the scale factor.
    /// - Returns: A scale factor that makes the size fit within the `maxWidth` and `maxHeight`.
    func scaleFactor(forMaxWidth maxWidth: CGFloat, maxHeight: CGFloat) -> CGFloat {
        if width < maxWidth && height < maxHeight { return 1 }

        let widthScaleFactor = 1 / (width / maxWidth)
        let heightScaleFactor = 1 / (height / maxHeight)

        // Use the smaller scale factor to ensure both the width and height are below the max
        return min(widthScaleFactor, heightScaleFactor)
    }
}
