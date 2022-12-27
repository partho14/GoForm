//
//  MyServeyTableViewCell.swift
//  GoForm
//
//  Created by Partha Pratim Das on 22/12/22.
//

import UIKit

class MyServeyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 10
            cellView.layer.borderWidth = 1
            cellView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
