//
//  UIView.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import Foundation
import UIKit

extension UIView {
    func corner(radius: CGFloat = 25) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func cornerVN(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
       self.layer.addSublayer(border)
   }

   func addRightBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
       self.layer.addSublayer(border)
   }

   func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
       self.layer.addSublayer(border)
   }

   func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
       self.layer.addSublayer(border)
    }
}

