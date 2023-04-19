//
//  HomeView+PDFKit.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import Foundation
import PDFKit

extension HomeViewController {
     func renamePDF(_ oldURL: URL, to newName: String) {
        let newURL = oldURL.deletingLastPathComponent().appendingPathComponent(newName)
        do {
            try FileManager.default.moveItem(at: oldURL, to: newURL)
            // Cập nhật danh sách tài liệu PDF
            if let index = pdfFiles.firstIndex(of: oldURL) {
                pdfFiles[index] = newURL
            }
            reloadTableView()
        } catch {
            print("Error rename PDF file: \(error.localizedDescription)")
        }
    }
     func deletePDF(at indexPath: IndexPath) {
        do {
            try FileManager.default.removeItem(at: pdfFiles[indexPath.row])
            pdfFiles.remove(at: indexPath.row)
            reloadTableView()
        } catch {
            print("Error delete PDF file: \(error.localizedDescription)")
        }
    }

     func showPDF(url: URL) {
        let pdfDocument = PDFDocument(url: url)
        let pdfViewController = PDFViewController()
        pdfViewController.pdfDocument = pdfDocument
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }

}
