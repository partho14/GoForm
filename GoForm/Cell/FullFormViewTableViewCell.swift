//
//  FullFormViewTableViewCell.swift
//  GoForm
//
//  Created by Partha Pratim Das on 9/12/22.
//

import UIKit

class FullFormViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionName: UILabel!
    @IBOutlet weak var ansTextField: UITextField!
    @IBOutlet weak var deteteButton: UIButton!
    @IBOutlet weak var cellEditBtn: UIButton!
    
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editButton(_ sender: Any) {
        didUpdate(cellEditBtn.tag)
    }
    @IBAction func deleteButton(_ sender: Any) {
        didDelete(deteteButton.tag)
    }
    

}
