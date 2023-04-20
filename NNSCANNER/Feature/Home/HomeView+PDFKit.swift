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
            if let index = filteredPDFFiles.firstIndex(of: oldURL) {
                filteredPDFFiles[index] = newURL
                reloadData()
            }
        } catch {
            print("Error rename PDF file: \(error.localizedDescription)")
        }
    }
     func deletePDF(at indexPath: IndexPath) {
        do {
            try FileManager.default.removeItem(at: filteredPDFFiles[indexPath.row])
            filteredPDFFiles.remove(at: indexPath.row)
            reloadData()
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
