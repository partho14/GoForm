//
//  MyServeyDetailsTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 22/12/22.
//

import UIKit

class MyServeyDetailsTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var formQuestion: UILabel!
    @IBOutlet weak var formQuestionAns: UITextField!
    @IBOutlet weak var addFileView: UIView!{
        didSet{
            addFileView.layer.cornerRadius = 10
            addFileView.layer.borderWidth = 1
            addFileView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var pdfNameLbl: UILabel!
    @IBOutlet weak var pdfShowBtn: UIButton!
    var didSaveText: (Int) -> ()  = { _ in }
    var didPdfShow: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formQuestionAns.delegate = self
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
    
    
    @IBAction func pdfShowClicked(_ sender: Any) {
        didPdfShow(pdfShowBtn.tag)
    }
    
}
