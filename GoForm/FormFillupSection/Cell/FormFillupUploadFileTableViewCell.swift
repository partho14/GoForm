//
//  FormFillupUploadFileTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import UIKit

class FormFillupUploadFileTableViewCell: UITableViewCell {

    @IBOutlet weak var uploadFileBorderView: UIView!{
        didSet{
            uploadFileBorderView.layer.borderWidth = 1
            uploadFileBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            uploadFileBorderView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var uploadFileTittleLbl: UILabel!{
        didSet{
            self.uploadFileTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            uploadFileTittleLbl.numberOfLines = 1
            uploadFileTittleLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var uploadFileView: UIView!{
        didSet{
            uploadFileView.layer.borderWidth = 1
            uploadFileView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            uploadFileView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var uploadFileMaxSizeLbl: UILabel!{
        didSet{
            self.uploadFileMaxSizeLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            uploadFileMaxSizeLbl.numberOfLines = 1
            uploadFileMaxSizeLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var fileUploadBtn: UIButton!
    @IBOutlet weak var chooseFileTextLbl: UILabel!{
        didSet{
            self.chooseFileTextLbl.font = UIFont(name: "Barlow-Regular", size: 12.0)
            chooseFileTextLbl.numberOfLines = 1
            chooseFileTextLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    
    var didUpload: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func fileUploadBtnPressed(_ sender: Any) {
        didUpload(fileUploadBtn.tag)
    }
    
}
