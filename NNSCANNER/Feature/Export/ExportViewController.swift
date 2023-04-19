//
//  ExportViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 18/04/2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PDFKit

class ExportViewController: UIViewController {
    var pdfData: Data!
    var isMultiPage: Bool = false
    var listPDFData: [Data] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isMultiPage {
            savePDFToDisk(pdfData: pdfData)
        } else {
            saveListPDFToDisk(listPDFData: listPDFData)
        }
    }

    func savePDFToDisk(pdfData: Data) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HHmmss"
        let fileName = "Scan-\(dateFormatter.string(from: Date())).pdf"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try pdfData.write(to: fileURL)
            print("Dữ liệu PDF đã được lưu tại \(fileURL.path)")
            self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
        } catch {
            print("Lỗi khi lưu dữ liệu PDF: \(error.localizedDescription)")
        }
    }

    func saveListPDFToDisk(listPDFData: [Data]) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HHmmss"
        let fileName = "Scan-\(dateFormatter.string(from: Date())).pdf"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let pdfDocument = PDFDocument()
        
        for pdfData in listPDFData {
            if let pdfDocumentToAdd = PDFDocument(data: pdfData) {
                for pageNum in 0 ..< pdfDocumentToAdd.pageCount {
                    let pdfPage = pdfDocumentToAdd.page(at: pageNum)
                    pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
                }
            }
        }
        do {
            try pdfDocument.dataRepresentation()?.write(to: fileURL)
            print("Dữ liệu PDF đã được lưu tại \(fileURL.path)")
            self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
        } catch {
            print("Lỗi khi lưu dữ liệu PDF: \(error.localizedDescription)")
        }
    }
}
