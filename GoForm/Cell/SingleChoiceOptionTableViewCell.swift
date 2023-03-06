//
//  SingleChoiceOptionTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 26/1/23.
//

import UIKit

class SingleChoiceOptionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var singleChoiceOptionNameLbl: UILabel!
    
    @IBOutlet weak var singleChoiceOptionRemoveBtn: UIButton!
    
    var didDelete: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func singleChoiceOptionRemoveBtnPressed(_ sender: Any) {
        didDelete(singleChoiceOptionRemoveBtn.tag)
    }
}
