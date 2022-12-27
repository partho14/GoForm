//
//  MainViewTableViewCell.swift
//  GoForm
//
//  Created by Partha Pratim Das on 8/12/22.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 10
            cellView.layer.borderWidth = 1
            cellView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var didShare: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        didShare(shareBtn.tag)
    }
}
