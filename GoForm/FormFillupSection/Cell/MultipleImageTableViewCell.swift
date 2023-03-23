//
//  MultipleImageTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 14/3/23.
//

import UIKit

class MultipleImageTableViewCell: UITableViewCell {

    @IBOutlet weak var nonImageView: UIView!{
        didSet{
            nonImageView.layer.borderWidth = 1
            nonImageView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            nonImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var withImageView: UIView!{
        didSet{
            withImageView.layer.borderWidth = 1
            withImageView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            withImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imageEditView: UIView!{
        didSet{
            imageEditView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imageDeleteView: UIView!{
        didSet{
            imageDeleteView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var cellImageView: UIImageView!{
        didSet{
            cellImageView.layer.cornerRadius = 10
        }
    }
    
    
    @IBOutlet weak var photoUploadBtn: UIButton!
    @IBOutlet weak var photoEditBtn: UIButton!
    @IBOutlet weak var photoDeleteBtn: UIButton!
    
    var storeIndex: [Int] = []
    var didUpload: (Int) -> ()  = { _ in }
    var didEdit: (Int) -> ()  = { _ in }
    var didDelete: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func photoEditBtnPressed(_ sender: Any) {
        didEdit(photoEditBtn.tag)
    }
    
    @IBAction func photoDeleteBtnPressed(_ sender: Any) {
        didDelete(photoDeleteBtn.tag)
    }
    
    @IBAction func photoUploadBtnPressed(_ sender: Any) {
        didUpload(photoUploadBtn.tag)
    }
}
