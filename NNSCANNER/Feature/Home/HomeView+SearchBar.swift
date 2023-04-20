//
//  HomeView+SearchBar.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import Foundation
import UIKit
extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(with: searchText)
        reloadTableView()
    }

    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "Search here..."
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .white
    }

    private func filterData(with searchText: String) {
        if searchText.isEmpty {
            // Nếu không có nội dung trong ô tìm kiếm thì hiển thị tất cả các tệp PDF
            filteredPDFFiles = pdfFiles
        } else {
            // Lọc danh sách tệp PDF dựa trên tên tệp
            filteredPDFFiles = pdfFiles.filter { $0.lastPathComponent.lowercased().contains(searchText.lowercased()) }
        }
        reloadTableView()
    }

}
