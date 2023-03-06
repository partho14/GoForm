//
//  MainServeyListTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 22/12/22.
//

import UIKit

class MainServeyListTableViewCell: UITableViewCell {

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
