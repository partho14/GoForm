//
//  FormBuilderTableViewCell.swift
//  GoForm
//
//  Created by Partha Pratim Das on 8/12/22.
//

import UIKit

class FormBuilderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionName: UILabel!
    @IBOutlet weak var ansTextField: UITextField!
    @IBOutlet weak var deteteButton: UIButton!
    @IBOutlet weak var cellEditBtn: UIButton!
    
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
        appDelegate.formBuilderViewController?.removeCell(index: self.deteteButton.tag)
        
        print(self.deteteButton.tag - 1)
        
    }
}
