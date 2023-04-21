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
    @IBOutlet weak var miniCollectionView: UICollectionView!
    var currentIndexPath: IndexPath?

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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let margin = 16
        let collectionViewWidth = UIScreen.main.bounds.width
        let collectionViewHeight = UIScreen.main.bounds.height - miniCollectionView.bounds.height - CGFloat((2 * margin))

        let safeAreaInsets = view.safeAreaInsets
        let cellWidth = collectionViewWidth - safeAreaInsets.left - safeAreaInsets.right
        let cellHeight = collectionViewHeight - safeAreaInsets.top - safeAreaInsets.bottom - 32 // subtract an additional 16 from top and bottom

        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: safeAreaInsets.top, left: safeAreaInsets.left, bottom: safeAreaInsets.bottom , right: safeAreaInsets.right)
        collectionView.collectionViewLayout = layout

        let miniNib = UINib(nibName: "MiniCollectionViewCell", bundle: nil)
        miniCollectionView.register(miniNib, forCellWithReuseIdentifier: "miniCell")
        miniCollectionView.dataSource = self
        miniCollectionView.delegate = self
        miniCollectionView.isPagingEnabled = true

        // Config Mini
        let miniLayout = UICollectionViewFlowLayout()
        miniLayout.scrollDirection = .horizontal
        miniLayout.minimumLineSpacing = 8 // khoảng cách giữa các dòng
        miniLayout.minimumInteritemSpacing = 8 // khoảng cách giữa các item trong cùng một dòng
        miniCollectionView.collectionViewLayout = miniLayout

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

}

extension PreviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataImage.count

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.collectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreviewCollectionViewCell

            cell.imageView.image = dataImage[indexPath.item]
            // Thiết lập tag cho nút xóa để xác định chỉ số của cell
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            return cell
        }
        else if (collectionView == self.miniCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniCell", for: indexPath) as! MiniCollectionViewCell

            if indexPath == currentIndexPath {
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.clear.cgColor
            }

            cell.imageView.image = dataImage[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }

    @objc func deleteImage(_ sender: UIButton) {
        guard let index = collectionView.indexPathsForVisibleItems.first?.item else {
            return
        }
        //        let index = sender.tag
        guard index >= 0 && index < dataImage.count else {
            return
        }
        dataImage.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        if (dataImage.count == 0) {
            self.navigationController?.setViewControllers([HomeTabBarViewController()], animated: true)
        }
        self.miniCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == miniCollectionView {
            currentIndexPath = indexPath
            self.collectionView.scrollToItem(at:indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
extension PreviewViewController: UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
                currentIndexPath = indexPath
                self.miniCollectionView.reloadData()
            }
        }
    }
}
