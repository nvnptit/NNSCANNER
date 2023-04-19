//
//  ScanView+ImagePicker.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import Foundation
import UIKit
import WeScan

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

    func openPhotoPicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: false, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false)
        self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        present(scannerViewController, animated: true)
    }
}
