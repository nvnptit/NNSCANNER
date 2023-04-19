//
//  HomeViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 17/04/2023.
//

import UIKit
import PDFKit

class HomeViewController: UIViewController{
    var pdfFiles: [URL] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Files"
        self.setUpNavigationBar(color: UIColor(hex6: "#185AC3")!)
        loadData()
        setUpTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    private func loadData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let pdfFileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                .filter { $0.pathExtension == "pdf" }
                .sorted { (url1, url2) -> Bool in
                    let creationDate1 = try url1.resourceValues(forKeys: [.creationDateKey]).creationDate!
                    let creationDate2 = try url2.resourceValues(forKeys: [.creationDateKey]).creationDate!
                    return creationDate1 > creationDate2
                }
            pdfFiles = pdfFileURLs
        } catch {
            print("Lỗi khi truy cập vào thư mục Documents: \(error.localizedDescription)")
        }
    }

}
