//
//  MultipleChoiceOptionTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 27/1/23.
//

import UIKit

class MultipleChoiceOptionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var multipleChoiceOptionNameLbl: UILabel!
    @IBOutlet weak var multipleChoiceOptionRemoveBtn: UIButton!
    var didDelete: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func multipleChoiceOptionRemoveBtnPressed(_ sender: Any) {
        didDelete(multipleChoiceOptionRemoveBtn.tag)
    }
    
}
