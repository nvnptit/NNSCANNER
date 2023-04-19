//
//  PDFViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 18/04/2023.
//
import UIKit
import PDFKit

class PDFViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var outputURL: URL!
    var pdfView: PDFView!
    var pdfDocument: PDFDocument?
    var documentFiltered: PDFDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = pdfDocument?.documentURL?.lastPathComponent.prefix(15) {
            self.title = String(describing: title)
        }
        self.navigationController?.navigationBar.tintColor = .white
        configurePDFView()
        configureShareButton()
    }

    private func configurePDFView() {
        pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(pdfView)

        if let document = pdfDocument {
            pdfView.document = document
        }
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.autoScales = true
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
    }

    private func configureShareButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [shareButton]
    }

    @objc func shareButtonTapped(_ sender: Any) {
        guard let documentURL = pdfDocument?.documentURL else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [documentURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func exportPDF() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HHmmss"
        let fileName = "Filtered-\(dateFormatter.string(from: Date())).pdf"
        let outputURL = documentsDirectory.appendingPathComponent(fileName)
        documentFiltered?.write(to: outputURL)
        self.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
}
