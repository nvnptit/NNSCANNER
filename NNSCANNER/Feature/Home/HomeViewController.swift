//
//  HomeViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 17/04/2023.
//

import UIKit

class HomeViewController: UIViewController{ //, UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return fileURLs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = fileURLs[indexPath.row].lastPathComponent
//        return cell
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        view.addSubview(tableView)

        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        let fileURLs = try! fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)

        for file in fileURLs {
            print(file.lastPathComponent)
        }

    }
}
