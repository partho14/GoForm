//
//  FormFillupTextFieldTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import UIKit

class FormFillupTextFieldTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textFieldBorderView: UIView!{
        didSet{
            textFieldBorderView.layer.borderWidth = 1
            textFieldBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            textFieldBorderView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var textFieldTittleLbl: UILabel!{
        didSet{
            self.textFieldTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            textFieldTittleLbl.numberOfLines = 1
            textFieldTittleLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var textFieldView: UIView!{
        didSet{
            textFieldView.layer.borderWidth = 1
            textFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            textFieldView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    var didSaveText: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        textField.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didSaveText(textField.tag)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(textField.text ?? "")")
        print(textField.tag)
        return true
    }

}
