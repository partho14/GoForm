//
//  SingleChoiceSubTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 6/2/23.
//

import UIKit

class SingleChoiceSubTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tittleLbl: UILabel!{
        didSet{
            self.tittleLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            tittleLbl.numberOfLines = 1
            tittleLbl.adjustsFontSizeToFitWidth = true
            tittleLbl.textAlignment = .left
        }
    }
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var optionSelectBtn: UIButton!
    
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func optionSelectBtnPressed(_ sender: Any) {
        didUpdate(optionSelectBtn.tag)
    }
}
