//
//  SharedPeopleTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 2/1/23.
//

import UIKit

class SharedPeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usersName: UILabel!{
        didSet{
            self.usersName.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var userNameFirstLetter: UILabel!{
        didSet{
            self.userNameFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var contactNumber: UILabel!{
        didSet{
            self.contactNumber.font = UIFont(name: "Barlow-Regular", size: 12.0)
        }
    }
    
    @IBOutlet weak var userNameFirstLetterView: UIView!{
        didSet{
            userNameFirstLetterView.layer.cornerRadius = userNameFirstLetterView.frame.size.height/2
        }
    }
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func toggoleBtnChanged(_ sender: Any) {
        didUpdate(statusSwitch.tag)
    }
    
}
