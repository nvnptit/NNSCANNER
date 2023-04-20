//
//  UIViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 19/04/2023.
//

import Foundation
import UIKit
import PDFKit

extension UIViewController {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
        return
    }

    func setUpNavigationBar(color: UIColor){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color

        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = titleAttribute
        appearance.largeTitleTextAttributes = titleAttribute

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func presentPDFView(with document: PDFDocument) {
        let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100))
        pdfView.autoScales = true
        pdfView.document = document
        view.addSubview(pdfView)
    }

}
