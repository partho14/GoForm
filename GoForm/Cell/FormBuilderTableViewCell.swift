//
//  FormBuilderTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 8/12/22.
//

import UIKit

class FormBuilderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionName: UILabel!{
        didSet{
            self.questionName.font = UIFont(name: "Barlow-Bold", size: 14.0)
            questionName.numberOfLines = 1
            questionName.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var ansTextField: UITextField!
    @IBOutlet weak var deteteButton: UIButton!
    @IBOutlet weak var cellEditBtn: UIButton!
    @IBOutlet weak var cellEditBtnView: UIView!{
        didSet{
            cellEditBtnView.layer.borderWidth = 1
            cellEditBtnView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            cellEditBtnView.layer.cornerRadius = cellEditBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var cellDeleteBtnView: UIView!{
        didSet{
            cellDeleteBtnView.layer.borderWidth = 1
            cellDeleteBtnView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            cellDeleteBtnView.layer.cornerRadius = cellDeleteBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var cellBorderView: UIView!{
        didSet{
            cellBorderView.layer.borderWidth = 1
            cellBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            cellBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var textFieldView: UIView!{
        didSet{
            textFieldView.layer.borderWidth = 1
            textFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            textFieldView.layer.cornerRadius = 10
        }
    }
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    @IBAction func cellEditBtn(_ sender: Any) {
        
        didUpdate(cellEditBtn.tag)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        didDelete(deteteButton.tag)
        //appDelegate.formBuilderViewController?.removeCell(index: self.deteteButton.tag)
        
        print(self.deteteButton.tag - 1)
        
    }
}
