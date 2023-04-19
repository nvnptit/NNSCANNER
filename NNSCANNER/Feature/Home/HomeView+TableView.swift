//
//  HomeView+TableView.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import Foundation
import UIKit
import PDFKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PDFTableViewCell", bundle: nil), forCellReuseIdentifier: "PDFTableViewCell")
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    @objc private func editButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PDFTableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let alertController = UIAlertController(title: "Edit PDF Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = self.pdfFiles[indexPath.row].lastPathComponent
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            guard let newName = alertController.textFields?.first?.text, !newName.isEmpty else {
                return
            }
            let oldURL = self.pdfFiles[indexPath.row]
            self.renamePDF(oldURL, to: newName)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDFTableViewCell", for: indexPath) as! PDFTableViewCell
        guard let pdfDocument = PDFDocument(url: pdfFiles[indexPath.row]) else { return cell }
        cell.configure(with: pdfDocument)
        // Add edit button to cell
        let editButton = UIButton(type: .system)
        editButton.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        cell.contentView.addSubview(editButton)
        // center y, trailing
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDFTableViewCell", for: indexPath) as! PDFTableViewCell
        cell.selectionStyle = .none
        let url = pdfFiles[indexPath.row]
        showPDF(url: url)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePDF(at: indexPath)
        }
    }
}
