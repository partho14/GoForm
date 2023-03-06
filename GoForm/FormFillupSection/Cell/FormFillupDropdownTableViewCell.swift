//
//  FormFillupDropdownTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import UIKit
import DropDown

class FormFillupDropdownTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownBorderView: UIView!{
        didSet{
            dropDownBorderView.layer.borderWidth = 1
            dropDownBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            dropDownBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var dropDownView: UIView!{
        didSet{
            dropDownView.layer.borderWidth = 1
            dropDownView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            dropDownView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var dropDownOptionTextLbl: UITextField!
    @IBOutlet weak var dropDownTittleLbl: UILabel!{
        didSet{
            self.dropDownTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            dropDownTittleLbl.numberOfLines = 1
            dropDownTittleLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    
    
    @IBOutlet weak var dropDownBtn: UIButton!
    
    let dropdownOptionDropdown = DropDown()
    var didOption: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func dropDownBtnPressed(_ sender: Any) {
        dropdownOptionDropdown.anchorView = self.dropDownView
        dropdownOptionDropdown.direction = .bottom
        didOption(dropDownBtn.tag)
    }
}
