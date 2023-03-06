//
//  MultipleChoiceSubTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 6/2/23.
//

import UIKit

class MultipleChoiceSubTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tittleLbl: UILabel!{
        didSet{
            self.tittleLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            tittleLbl.numberOfLines = 1
            tittleLbl.adjustsFontSizeToFitWidth = true
            tittleLbl.textAlignment = .left
        }
    }
    @IBOutlet weak var optionSelectBtn: UIButton!
    @IBOutlet weak var selectView: UIView!{
        didSet{
            selectView.layer.borderWidth = 1
            selectView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            selectView.layer.cornerRadius = 5
            
        }
    }
    @IBOutlet weak var selectViewImage: UIImageView!
    
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func optionSelectBtnPressed(_ sender: Any) {
        didUpdate(optionSelectBtn.tag)
    }

}
