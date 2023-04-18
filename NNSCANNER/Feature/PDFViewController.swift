//
//  PDFViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 18/04/2023.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    let pdfView = PDFView()

    init(pdfUrl: URL) {
        super.init(nibName: nil, bundle: nil)

        let pdfDocument = PDFDocument(url: pdfUrl)
        pdfView.document = pdfDocument
        pdfView.autoScales = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
