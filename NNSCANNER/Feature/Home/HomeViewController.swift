//
//  HomeViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 17/04/2023.
//

import UIKit
import PDFKit

private enum SortType: String {
    case name
    case size
    case date
}

public enum SortOrder: String {
    case ASC
    case DESC

    mutating func toggle() {
        switch self {
        case .ASC:
            self = .DESC
        case .DESC:
            self = .ASC
        }
    }
}

class HomeViewController: UIViewController{
    var pdfFiles: [URL] = []
    var filteredPDFFiles: [URL] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!


    private var sortAttribute: SortType = .date {
        didSet {
            self.sortOrder = .DESC
        }
    }

    var sortOrder: SortOrder = .DESC {
        didSet {
            self.setupBarButton()
            self.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        loadData()

        setupBarButton()
        setUpSearchBar()
        setUpTableView()
    }

    private func configureNavigationBar(){
        self.title = "Files"
        self.setUpNavigationBar(color: UIColor(hex6: "#185AC3")!)
        self.navigationController?.navigationBar.tintColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)

    }
    @objc func hideKeyboard() {
        searchBar.resignFirstResponder()
    }

    private func loadData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let pdfFileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                .sorted { (url1, url2) -> Bool in
                    let creationDate1 = try url1.resourceValues(forKeys: [.creationDateKey]).creationDate!
                    let creationDate2 = try url2.resourceValues(forKeys: [.creationDateKey]).creationDate!
                    return creationDate1 > creationDate2
                }
            pdfFiles = pdfFileURLs
            filteredPDFFiles = pdfFiles
        } catch {
            print("Error access Documents: \(error.localizedDescription)")
        }
    }
}

extension HomeViewController {
    func reloadData(){
        switch self.sortAttribute {
            case .name:
                self.filteredPDFFiles = self.filteredPDFFiles.sorted(by: { (url1, url2) -> Bool in
                    let name1 = url1.lastPathComponent
                    let name2 = url2.lastPathComponent
                    if self.sortOrder == .ASC {
                        return name1 < name2
                    }
                    else {
                        return name1 > name2
                    }
                })
                reloadTableView()
            case .date:
                self.filteredPDFFiles = self.filteredPDFFiles.sorted(by: { (url1, url2) -> Bool in
                    guard let creationDate1 = try? url1.resourceValues(forKeys: [.creationDateKey]).creationDate else { return false }
                    guard let creationDate2 = try? url2.resourceValues(forKeys: [.creationDateKey]).creationDate else { return true }
                    if self.sortOrder == .ASC {
                        return creationDate1 < creationDate2
                    } else {
                        return creationDate1 > creationDate2
                    }
                })
                reloadTableView()
            case .size:
                self.filteredPDFFiles = self.filteredPDFFiles.sorted(by: { (url1, url2) -> Bool in
                    let attributes1 = try? url1.resourceValues(forKeys: [.fileSizeKey])
                    let attributes2 = try? url2.resourceValues(forKeys: [.fileSizeKey])
                    let fileSize1 = attributes1?.fileSize ?? 0
                    let fileSize2 = attributes2?.fileSize ?? 0
                    if self.sortOrder == .ASC {
                        return fileSize1 < fileSize2
                    } else {
                        return fileSize1 > fileSize2
                    }
                })
                reloadTableView()
        }
    }
    private func getSortIcon(type: SortType)-> UIImage? {
        if self.sortAttribute == type {
            let image = self.sortOrder == .ASC ? UIImage(systemName: "arrow.up") : UIImage(systemName: "arrow.down")
            return image?.withTintColor(.black)
        }
        return nil
    }
    func setupBarButton(){
        let nameSortActState: UIMenuElement.State = self.sortAttribute == .name ? .on : .off
        let sizeSortActState: UIMenuElement.State = self.sortAttribute == .size ? .on : .off
        let dateSortActState: UIMenuElement.State = self.sortAttribute == .date ? .on : .off

        let nameSort = UIAction(title: "Name", image: self.getSortIcon(type: .name), state: nameSortActState) { [weak self] action in
            guard let self = self else { return }
            if self.sortAttribute != .name {
                self.sortAttribute = .name
                self.sortOrder = .ASC
            }
            else {
                self.sortOrder.toggle()
            }
        }

        let sizeSort = UIAction(title: "Size", image: self.getSortIcon(type: .size), state: sizeSortActState) { [weak self] action in
            guard let self = self else { return }
            if self.sortAttribute != .size {
                self.sortAttribute = .size
                self.sortOrder = .ASC
            }
            else {
                self.sortOrder.toggle()
            }
        }

        let dateSort = UIAction(title: "Date", image: self.getSortIcon(type: .date), state: dateSortActState) { [weak self] action in
            guard let self = self else { return }
            if self.sortAttribute != .date {
                self.sortAttribute = .date
                self.sortOrder = .ASC
            }
            else {
                self.sortOrder.toggle()
            }
        }

        let sortMenu = UIMenu(title: "", options: .displayInline, children: [nameSort, dateSort, sizeSort])

        let menuBarButton = UIBarButtonItem(
            title: nil,
            image:  UIImage(systemName: "list.bullet")?.withTintColor(.white),
            primaryAction: nil,
            menu: sortMenu
        )
        self.navigationItem.rightBarButtonItem = menuBarButton
    }
}
