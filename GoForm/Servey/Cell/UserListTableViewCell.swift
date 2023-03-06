//
//  UserListTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 31/1/23.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userContactNumber: UILabel!
    @IBOutlet weak var userNameFirstLetter: UILabel!
    @IBOutlet weak var userNameFirstLetterView: UIView!{
        didSet{
            userNameFirstLetterView.layer.cornerRadius = userNameFirstLetterView.frame.size.height/2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

}
