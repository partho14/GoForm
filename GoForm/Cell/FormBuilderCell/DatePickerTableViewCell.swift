//
//  DatePickerTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 2/2/23.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePickerCellRoundView: UIView!{
        didSet{
            datePickerCellRoundView.layer.borderWidth = 1
            datePickerCellRoundView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            datePickerCellRoundView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var datePickerTextFieldView: UIView!{
        didSet{
            datePickerTextFieldView.layer.borderWidth = 1
            datePickerTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            datePickerTextFieldView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var datepickerCellTittle: UILabel!{
        didSet{
            self.datepickerCellTittle.font = UIFont(name: "Barlow-Bold", size: 14.0)
            datepickerCellTittle.numberOfLines = 1
            datepickerCellTittle.adjustsFontSizeToFitWidth = true
            datepickerCellTittle.textAlignment = .center
        }
    }
    @IBOutlet weak var datePickerEditView: UIView!{
        didSet{
            datePickerEditView.layer.borderWidth = 1
            datePickerEditView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            datePickerEditView.layer.cornerRadius = datePickerEditView.frame.size.height/2
        }
    }
    @IBOutlet weak var dateTextField: UILabel!{
        didSet{
            self.dateTextField.font = UIFont(name: "Barlow-Regular", size: 14.0)
        }
    }
    @IBOutlet weak var datePickerDeleteBtn: UIButton!
    @IBOutlet weak var datePickerEditBtn: UIButton!
    @IBOutlet weak var datePickerDeleteView: UIView!{
        didSet{
            datePickerDeleteView.layer.borderWidth = 1
            datePickerDeleteView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            datePickerDeleteView.layer.cornerRadius = datePickerDeleteView.frame.size.height/2
        }
    }
    
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func datePickerDeleteBtnPressed(_ sender: Any) {
        didDelete(datePickerDeleteBtn.tag)
        //appDelegate.formBuilderViewController?.removeCell(index: self.datePickerDeleteBtn.tag)
    }
    
    @IBAction func datePickerEditBtnPressed(_ sender: Any) {
        didUpdate(datePickerEditBtn.tag)
    }
}
