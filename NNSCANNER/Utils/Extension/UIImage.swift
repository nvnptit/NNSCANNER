//
//  UIImage.swift
//  NNSCANNER
//  Modified by Nhat on 18/04/2023.
//  Created by Bobo on 5/25/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// Draws a new cropped and scaled (zoomed in) image.
    ///
    /// - Parameters:
    ///   - point: The center of the new image.
    ///   - scaleFactor: Factor by which the image should be zoomed in.
    ///   - size: The size of the rect the image will be displayed in.
    /// - Returns: The scaled and cropped image.
    func scaledImage(atPoint point: CGPoint, scaleFactor: CGFloat, targetSize size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let scaledSize = CGSize(width: size.width / scaleFactor, height: size.height / scaleFactor)
        let midX = point.x - scaledSize.width / 2.0
        let midY = point.y - scaledSize.height / 2.0
        let newRect = CGRect(x: midX, y: midY, width: scaledSize.width, height: scaledSize.height)

        guard let croppedImage = cgImage.cropping(to: newRect) else {
            return nil
        }

        return UIImage(cgImage: croppedImage)
    }

    /// Scales the image to the specified size in the RGB color space.
    ///
    /// - Parameters:
    ///   - scaleFactor: Factor by which the image should be scaled.
    /// - Returns: The scaled image.
    func scaledImage(scaleFactor: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let customColorSpace = CGColorSpaceCreateDeviceRGB()

        let width = CGFloat(cgImage.width) * scaleFactor
        let height = CGFloat(cgImage.height) * scaleFactor
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo.rawValue

        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: customColorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }

        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))

        return context.makeImage().flatMap { UIImage(cgImage: $0) }
    }

    /// Returns the data for the image in the PDF format
    func pdfData() -> Data? {
        // Typical Letter PDF page size and margins
        let pageBounds = CGRect(x: 0, y: 0, width: 595, height: 842)
        let margin: CGFloat = 40

        let imageMaxWidth = pageBounds.width - (margin * 2)
        let imageMaxHeight = pageBounds.height - (margin * 2)

        let image = scaledImage(scaleFactor: size.scaleFactor(forMaxWidth: imageMaxWidth, maxHeight: imageMaxHeight)) ?? self
        let renderer = UIGraphicsPDFRenderer(bounds: pageBounds)

        let data = renderer.pdfData { ctx in
            ctx.beginPage()

            ctx.cgContext.interpolationQuality = .high

            image.draw(at: CGPoint(x: margin, y: margin))
        }

        return data
    }
    func convertToPDF() -> Data? {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: self.size))

        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()

            let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            self.draw(in: imageRect)
        }

        return pdfData
    }
    func pdfA4Page() -> Data? {
        // kích thước A4 theo đơn vị điểm ảnh
            let image = self
            let margin: CGFloat = 40 // canh lề

            let pageWidth: CGFloat = 595
            let pageHeight: CGFloat = 842

            let pageBounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

            let renderer = UIGraphicsPDFRenderer(bounds: pageBounds)

            let data = renderer.pdfData { context in
                context.beginPage()

                context.cgContext.interpolationQuality = .high

                // Tính toán kích thước hình ảnh để vẽ với tỷ lệ giữa chiều rộng và chiều cao giống như ban đầu.
                let imageSize = image.size
                let maxWidth = pageWidth - margin * 2
                let maxHeight = pageHeight - margin * 2
                let scaleFactor = min(maxWidth / imageSize.width, maxHeight / imageSize.height)
                let targetSize = CGSize(width: imageSize.width * scaleFactor, height: imageSize.height * scaleFactor)

                // Vẽ hình ảnh vào tài liệu PDF
                let imageX = (pageWidth - targetSize.width) / 2
                let imageY = (pageHeight - targetSize.height) / 2
                let imageRect = CGRect(x: imageX, y: imageY, width: targetSize.width, height: targetSize.height)
                image.draw(in: imageRect)
            }

            return data
    }

    func pdfSimplePage() -> Data? {
        //sử dụng kích thước hình ảnh ban đầu để vẽ vào tài liệu PDF với một khoảng cách lề
        let image = self
        let margin: CGFloat = 40 // canh lề

        let pageWidth = image.size.width + margin * 2
        let pageHeight = image.size.height + margin * 2

        let pageBounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageBounds)

        let data = renderer.pdfData { context in
            context.beginPage()

            context.cgContext.interpolationQuality = .high

            image.draw(at: CGPoint(x: margin, y: margin))
        }

        return data
    }

    /// Function gathered from [here](https://stackoverflow.com/questions/44462087/how-to-convert-a-uiimage-to-a-cvpixelbuffer)
    /// to convert UIImage to CVPixelBuffer
    ///
    /// - Returns: new [CVPixelBuffer](apple-reference-documentation://hsVf8OXaJX)
    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        var pixelBufferOpt: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBufferOpt
        )
        guard status == kCVReturnSuccess, let pixelBuffer = pixelBufferOpt else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }

        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }

    /// Creates a UIImage from the specified CIImage.
    static func from(ciImage: CIImage) -> UIImage {
        if let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            return UIImage(ciImage: ciImage, scale: 1.0, orientation: .up)
        }
    }
}
