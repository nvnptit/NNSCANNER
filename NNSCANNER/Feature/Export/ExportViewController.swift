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

class ExportViewController: UIViewController, UIDocumentPickerDelegate {
    var pdfData: Data!
    var isMultiPage: Bool = false
    var listPDFData: [Data] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        !isMultiPage ? savePDFToDisk(pdfData: pdfData) : saveListPDFToDisk(listPDFData: listPDFData)
    }

    func openDocumentPicker(){
        let supportedTypes: [UTType] = [.image, .text, .archive, .audio, .video, .pdf, .zip, .gif, .heic, .json, .livePhoto, .presentation, .sourceCode, .plainText, .mp3, .mpeg4Movie, .movie ,. mpeg4Movie, .utf8PlainText, .utf16PlainText, .swiftSource, .delimitedText, .tabSeparatedText, .commaSeparatedText, .utf8TabSeparatedText, .utf16ExternalPlainText, .folder]
        let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        pickerViewController.delegate = self
        pickerViewController.allowsMultipleSelection = true
        pickerViewController.shouldShowFileExtensions = true
        self.present(pickerViewController, animated: true, completion: nil)
    }
    func savePDFToDisk(pdfData: Data) {
        let documentPicker =
        UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        // Present the document picker.
        present(documentPicker, animated: true, completion: nil)

        // Lưu dữ liệu PDF tạm thời
        UserDefaults.standard.set(pdfData, forKey: "PDFData")
    }
    func saveListPDFToDisk(listPDFData: [Data]) {
        let documentPicker =
        UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        // Present the document picker.
        present(documentPicker, animated: true, completion: nil)

        // Lưu dữ liệu PDF tạm thời
        UserDefaults.standard.set(listPDFData, forKey: "listPDFData")
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        // Kiểm tra quyền truy cập tệp
        guard url.startAccessingSecurityScopedResource() else {
            return
        }
        do {
            if (!isMultiPage) {
                // Lấy dữ liệu PDF tạm thời
                guard let pdfData = UserDefaults.standard.data(forKey: "PDFData") else {
                    return
                }
                // Lưu dữ liệu PDF thành file tại URL đã chọn
                let dateFormatter = DateFormatter()
                  dateFormatter.dateFormat = "dd_MM_yyyy_HHmmss"
                  let fileName = "MyPDF-\(dateFormatter.string(from: Date())).pdf"
                let urlFile = url.appendingPathComponent(fileName)
                try pdfData.write(to: urlFile, options: .atomic)
                print("Dữ liệu PDF đã được lưu tại \(url.path)")
                urlFile.stopAccessingSecurityScopedResource()
                self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
                // Xóa dữ liệu PDF tạm thời
                UserDefaults.standard.removeObject(forKey: "PDFData")
            } else {
                let pdfDocument = PDFDocument()
                // Thêm các trang PDF vào tài liệu mới
                for pdfData in listPDFData {
                    if let pdfDocumentToAdd = PDFDocument(data: pdfData) {
                        for pageNum in 0 ..< pdfDocumentToAdd.pageCount {
                            let pdfPage = pdfDocumentToAdd.page(at: pageNum)
                            pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
                        }
                    }
                }
                let dateFormatter = DateFormatter()
                  dateFormatter.dateFormat = "dd_MM_yyyy_HHmmss"
                  let fileName = "MyPDF-\(dateFormatter.string(from: Date())).pdf"
                let urlFile = url.appendingPathComponent(fileName)
                try pdfDocument.dataRepresentation()?.write(to: urlFile, options: .atomic)
                print("Dữ liệu PDF đã được lưu tại \(url.path)")
                urlFile.stopAccessingSecurityScopedResource()
                self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
            }
        } catch {
            print("Lỗi khi lưu dữ liệu PDF: \(error.localizedDescription)")
        }
    }

}
