//
//  ScanViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 17/04/2023.
//

import UIKit
import WeScan
import PDFKit

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
                self.openPhotoPicker()
                break
            default:
                break
        }
    }
}

extension ScanViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: WeScan.ImageScannerController, didFinishScanningWithResults results: WeScan.ImageScannerResults) {
        let docMode = UserDefaults.standard.integer(forKey: "DocMode")
        let scanMode = UserDefaults.standard.integer(forKey: "ScanMode")
        //docMode = 1 là .pdfData() và docMode = 2 là .pdfA4Page() và docMode = 3 là .pdfSimplePage()
        //scanMode = 1 là .croppedScan và scanMode = 2 là .enhancedScan
        switch docMode {
            case 1: //pdfData
                if (scanMode == 1){
                    if (self.isMultiPage){
                        self.dataScan.append(results.croppedScan.image.pdfData()!)
                        scanner.resetScanner()
                    }else {
                        let vc = ExportViewController()
                        vc.pdfData = results.croppedScan.image.pdfData()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        scanner.dismiss(animated: false, completion: nil)
                    }
                }else {
                    if (self.isMultiPage){
                        if let enhanced = results.enhancedScan{
                            self.dataScan.append(enhanced.image.pdfData()!)
                            scanner.resetScanner()
                        }
                    }else {
                        let vc = ExportViewController()
                        if  let enhanced = results.enhancedScan{
                            vc.pdfData = enhanced.image.pdfData()
                            self.navigationController?.setViewControllers([vc], animated: true)
                            scanner.dismiss(animated: false, completion: nil)
                        }
                    }
                }
                break
            case 2: //pdfA4Page
                if (scanMode == 1){
                    if (self.isMultiPage){
                        self.dataScan.append(results.croppedScan.image.pdfA4Page()!)
                        scanner.resetScanner()
                    }else {
                        let vc = ExportViewController()
                        vc.pdfData = results.croppedScan.image.pdfA4Page()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        scanner.dismiss(animated: false, completion: nil)
                    }
                }else {
                    if (self.isMultiPage){
                        if let enhanced = results.enhancedScan{
                            self.dataScan.append(enhanced.image.pdfA4Page()!)
                            scanner.resetScanner()
                        }
                    }else {
                        let vc = ExportViewController()
                        if  let enhanced = results.enhancedScan{
                            vc.pdfData = enhanced.image.pdfA4Page()
                            self.navigationController?.setViewControllers([vc], animated: true)
                            scanner.dismiss(animated: false, completion: nil)
                        }
                    }
                }
                break
            case 3: //pdfSimplePage
                if (scanMode == 1){
                    if (self.isMultiPage){
                        self.dataScan.append(results.croppedScan.image.pdfSimplePage()!)
                        scanner.resetScanner()
                    }else {
                        let vc = ExportViewController()
                        vc.pdfData = results.croppedScan.image.pdfSimplePage()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        scanner.dismiss(animated: false, completion: nil)
                    }
                }else {
                    if (self.isMultiPage){
                        if let enhanced = results.enhancedScan{
                            self.dataScan.append(enhanced.image.pdfSimplePage()!)
                            scanner.resetScanner()
                        }
                    }else {
                        let vc = ExportViewController()
                        if  let enhanced = results.enhancedScan{
                            vc.pdfData = enhanced.image.pdfSimplePage()
                            self.navigationController?.setViewControllers([vc], animated: true)
                            scanner.dismiss(animated: false, completion: nil)
                        }
                    }
                }
                break
            default:
                break
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: WeScan.ImageScannerController) {
        if (!self.isMultiPage){
            self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
        }else {
            let vc = ExportViewController()
            vc.isMultiPage = true
            vc.listPDFData = self.dataScan
            self.navigationController?.setViewControllers([vc], animated: true)
        }
        scanner.dismiss(animated: false, completion:nil)
    }
    
    func imageScannerController(_ scanner: WeScan.ImageScannerController, didFailWithError error: Error) {
        print("Error occurred: \(error)")
    }
}

