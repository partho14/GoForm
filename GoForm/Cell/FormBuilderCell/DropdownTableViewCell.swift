//
//  DropdownTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 2/2/23.
//

import UIKit
import DropDown

class DropdownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dropdownBorderView: UIView!{
        didSet{
            dropdownBorderView.layer.borderWidth = 1
            dropdownBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            dropdownBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var dropdownTittleLbl: UILabel!{
        didSet{
            self.dropdownTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            dropdownTittleLbl.numberOfLines = 1
            dropdownTittleLbl.adjustsFontSizeToFitWidth = true
            dropdownTittleLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var dropdownDeleteView: UIView!{
        didSet{
            dropdownDeleteView.layer.borderWidth = 1
            dropdownDeleteView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            dropdownDeleteView.layer.cornerRadius = dropdownDeleteView.frame.size.height/2
        }
    }
    @IBOutlet weak var dropdownEditView: UIView!{
        didSet{
            dropdownEditView.layer.borderWidth = 1
            dropdownEditView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            dropdownEditView.layer.cornerRadius = dropdownEditView.frame.size.height/2
        }
    }
    @IBOutlet weak var dropdownOptionView: UIView!{
        didSet{
            dropdownOptionView.layer.borderWidth = 1
            dropdownOptionView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            dropdownOptionView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var dropdownOptionTextField: UITextField!
    @IBOutlet weak var dropdownDeleteBtn: UIButton!
    @IBOutlet weak var dropdownEditBtn: UIButton!
    @IBOutlet weak var dropdownOptionBtn: UIButton!
    
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    var didOption: (Int) -> ()  = { _ in }
    
    let dropdownOptionDropdown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func dropdownEditBtnPressed(_ sender: Any) {
        didUpdate(dropdownEditBtn.tag)
    }
    
    @IBAction func dropdownDeleteBtnPressed(_ sender: Any) {
        didDelete(dropdownDeleteBtn.tag)
        //appDelegate.formBuilderViewController?.removeCell(index: self.dropdownDeleteBtn.tag)
    }
    
    @IBAction func dropdownBtnPressed(_ sender: Any) {
        dropdownOptionDropdown.anchorView = self.dropdownOptionView
        dropdownOptionDropdown.direction = .bottom
        didOption(dropdownOptionBtn.tag)
    }
}
