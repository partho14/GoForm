//
//  DropdownOptionTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 26/1/23.
//

import UIKit

class DropdownOptionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dropdownOptionNameLbl: UILabel!
    
    @IBOutlet weak var dropdownOptionRemoveBtn: UIButton!
    
    var didDelete: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func dropDownOptionRemoveBtnPressed(_ sender: Any) {
        didDelete(dropdownOptionRemoveBtn.tag)
    }
    
}
