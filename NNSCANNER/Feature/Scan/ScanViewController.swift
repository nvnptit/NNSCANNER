//
//  ScanViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 17/04/2023.
//

import UIKit
import WeScan
import PDFKit
import MobileCoreServices
import UniformTypeIdentifiers

class ScanViewController: UIViewController{
    var dataScan: [Data] = []
    var isMultiPage: Bool = false
    var option = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataScan.removeAll()
        switch option {
            case 0:
                self.isMultiPage = false
                self.scanImage()
                break
            case 1:
                self.isMultiPage = true
                self.scanImage()
                break
            case 2:
                self.selectImage()
                break
            default:
                break
        }
    }
    @objc func showCameraOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takeOnePageAction = UIAlertAction(title: "Take One Page", style: .default) { _ in
            self.dataScan.removeAll()
            self.isMultiPage = false
            self.scanImage()
        }
        let takeMultiPageAction = UIAlertAction(title: "Take Multiple Page", style: .default) { _ in
            self.dataScan.removeAll()
            self.isMultiPage = true
            self.scanImage()
        }

        let choosePhotoAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.dataScan.removeAll()
            self.selectImage()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0 // chuyển đến tab thứ hai

            }
        })

        alertController.addAction(takeOnePageAction)
        alertController.addAction(takeMultiPageAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension ScanViewController: ImageScannerControllerDelegate, UIDocumentPickerDelegate {
    func savePDFToDisk(pdfData: Data) {

        let documentPicker =
        UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)

        // Lưu dữ liệu PDF tạm thời
        UserDefaults.standard.set(pdfData, forKey: "PDFData")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        print("URL: \(url)")
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Xóa dữ liệu PDF tạm thời nếu người dùng hủy bỏ tác vụ
        UserDefaults.standard.removeObject(forKey: "PDFData")
    }
    func imageScannerController(_ scanner: WeScan.ImageScannerController, didFinishScanningWithResults results: WeScan.ImageScannerResults) {
        print("Xử lý pdf!")
        if (self.isMultiPage){
            self.dataScan.append(results.croppedScan.image.pdfData1()!)
            scanner.resetScanner()
        }else {
            scanner.dismiss(animated: false, completion: {
                let vc = ExportViewController()
                vc.pdfData =  results.croppedScan.image.pdfData1()
                //self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.setViewControllers([vc], animated: true)

            })
        }
    }

    func imageScannerControllerDidCancel(_ scanner: WeScan.ImageScannerController) {
        scanner.dismiss(animated: true, completion: {
            print("isMulti: \(self.isMultiPage)")
            if (!self.isMultiPage){
                self.showCameraOptions()
            }else {
                let vc = ExportViewController()
                vc.isMultiPage = true
                vc.listPDFData = self.dataScan
    //            self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        })

    }

    func imageScannerController(_ scanner: WeScan.ImageScannerController, didFailWithError error: Error) {
        assertionFailure("Error occurred: \(error)")
    }
}
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func scanImage() {
        let scannerVC = ImageScannerController(delegate: self)
        scannerVC.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            scannerVC.navigationBar.tintColor = .white
        } else {
            scannerVC.navigationBar.tintColor = .black
        }
        present(scannerVC, animated: true)
    }

    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        present(scannerViewController, animated: true)
    }
}
