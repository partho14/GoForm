//
//  UploadFileTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 1/2/23.
//

import UIKit

class UploadFileTableViewCell: UITableViewCell {

    @IBOutlet weak var fileUploadBorderView: UIView!{
        didSet{
            fileUploadBorderView.layer.borderWidth = 1
            fileUploadBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            fileUploadBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var fileuploadView: UIView!{
        didSet{
            fileuploadView.layer.borderWidth = 1
            fileuploadView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            fileuploadView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var editView: UIView!{
        didSet{
            editView.layer.borderWidth = 1
            editView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            editView.layer.cornerRadius = editView.frame.size.height/2
        }
    }
    @IBOutlet weak var deleteView: UIView!{
        didSet{
            deleteView.layer.borderWidth = 1
            deleteView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            deleteView.layer.cornerRadius = deleteView.frame.size.height/2
        }
    }
    
    @IBOutlet weak var uploadFileMaxSize: UILabel!{
        didSet{
            self.uploadFileMaxSize.font = UIFont(name: "Barlow-Regular", size: 14.0)
            uploadFileMaxSize.numberOfLines = 1
            uploadFileMaxSize.adjustsFontSizeToFitWidth = true
            uploadFileMaxSize.textAlignment = .left
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var fileUploadTittleLbl: UILabel!{
        didSet{
            self.fileUploadTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            fileUploadTittleLbl.numberOfLines = 1
            fileUploadTittleLbl.adjustsFontSizeToFitWidth = true
            //fileUploadTittleLbl.sizeToFit()
            fileUploadTittleLbl.textAlignment = .center
        }
    }
    
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func cellEditBtn(_ sender: Any) {
        didUpdate(editBtn.tag)
    }
    @IBAction func deleteBtn(_ sender: Any) {
        didDelete(deleteBtn.tag)
        //appDelegate.formBuilderViewController?.removeCell(index: self.deleteBtn.tag)
    }
}
