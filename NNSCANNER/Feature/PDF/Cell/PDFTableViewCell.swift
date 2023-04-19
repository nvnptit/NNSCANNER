//
//  PDFTableViewCell.swift
//  NNSCANNER
//
//  Created by Nhat on 18/04/2023.
//

import UIKit
import PDFKit

class PDFTableViewCell: UITableViewCell {

    @IBOutlet weak var pdfName: UILabel!

    @IBOutlet weak var thumbImage: UIImageView!

    @IBOutlet weak var pdfDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with pdfDocument: PDFDocument) {
        guard let documentURL = pdfDocument.documentURL, let pdfPage = pdfDocument.page(at: 0) else {
            pdfName.text = "Unknown"
            pdfDate.text = ""
            thumbImage.image = UIImage(named: "placeholder")
            return
        }
        // set thumbnail
        thumbImage.image = pdfPage.thumbnail(of: thumbImage.bounds.size, for: .trimBox)
        // set name & date
        pdfName.text = String(documentURL.lastPathComponent.prefix(20))
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: documentURL.path)
        if let creationDate = fileAttributes?[FileAttributeKey.creationDate] as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            pdfDate.text = dateFormatter.string(from: creationDate)
        }
    }
}
