//
//  PreviewViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import UIKit

class PreviewViewController: UIViewController {

    var dataImage: [UIImage] = []
    var scannedImageData: [Data] = []

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        convertImageToData()

        self.setUpNavigationBar(color: UIColor(hex6: "#185AC3")!)
        let nib = UINib(nibName: "PreviewCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true

        // Cấu hình layout cho UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16

        let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let safeAreaInsets = view.safeAreaInsets
        let margin: CGFloat = 16

        let width = UIScreen.main.bounds.width - safeAreaInsets.left - safeAreaInsets.right - 2 * margin
        let height = UIScreen.main.bounds.height - safeAreaInsets.top - navigationBarHeight - 0.25 * navigationBarHeight - safeAreaInsets.bottom - 2 * margin

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: safeAreaInsets.top + margin, left: margin, bottom: margin, right:  margin)

        // Thiết lập layout cho UICollectionView
        collectionView.collectionViewLayout = layout
    }
    @IBAction func didTapExportPDF(_ sender: UIButton, forEvent event: UIEvent) {
            convertImageToData()
            let vc = ExportViewController()
            vc.isMultiPage = true
            vc.listPDFData = self.scannedImageData
            self.navigationController?.setViewControllers([vc], animated: true)
    }

    @IBAction func didTapScanMore(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = ScanViewController()
        vc.dataImage = self.dataImage
        vc.dataScan = self.scannedImageData
        vc.isMore = true
        vc.option = 1
        self.navigationController?.setViewControllers([vc], animated: true)
    }

    func convertImageToData() {
        self.scannedImageData.removeAll()
        for item in dataImage {
            if let imageData = item.pdfA4Page() {
                self.scannedImageData.append(imageData)
            }
        }
    }

    @objc func deleteImage() {
        guard let index = collectionView.indexPathsForVisibleItems.first?.item else {
            return
        }
        dataImage.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension PreviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataImage.count

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreviewCollectionViewCell

        cell.imageView.image = dataImage[indexPath.item]
        // Thiết lập tag cho nút xóa để xác định chỉ số của cell
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)

        return cell
    }

    @objc func deleteImage(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < dataImage.count else {
            return
        }
        dataImage.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        if (dataImage.count == 0) {
            self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
        }
    }

}
