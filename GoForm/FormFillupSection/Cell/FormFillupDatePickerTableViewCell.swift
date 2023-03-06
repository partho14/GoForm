//
//  FormFillupDatePickerTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import UIKit

class FormFillupDatePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePickerBorderView: UIView!{
        didSet{
            datePickerBorderView.layer.borderWidth = 1
            datePickerBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            datePickerBorderView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var datePickerView: UIView!{
        didSet{
            datePickerView.layer.borderWidth = 1
            datePickerView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            datePickerView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var datePickerTittleLbl: UILabel!{
        didSet{
            self.datePickerTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            datePickerTittleLbl.numberOfLines = 1
            datePickerTittleLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var dateTextLbl: UILabel!{
        didSet{
            self.dateTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            dateTextLbl.numberOfLines = 1
            dateTextLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    
    @IBOutlet weak var datePickerBtn: UIButton!
    var didUpdate: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func datePickerBtnPressed(_ sender: Any) {
        didUpdate(datePickerBtn.tag)
    }
    
}
