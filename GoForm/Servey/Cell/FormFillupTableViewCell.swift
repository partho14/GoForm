//
//  FormFillupTableViewCell.swift
//  GoForm
//
//  Created by Partha Pratim Das on 12/12/22.
//

import UIKit

class FormFillupTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var didSaveText: (Int) -> ()  = { _ in }
    
    var array: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
       // textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
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
