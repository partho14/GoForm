//
//  FormServeyListTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 23/2/23.
//

import UIKit

class FormServeyListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!{
        didSet{
            self.userName.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    @IBOutlet weak var userNameFirstLetter: UILabel!{
        didSet{
            self.userNameFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var firstletterView: UIView!{
        didSet{
            firstletterView.layer.cornerRadius = firstletterView.frame.size.height/2
        }
    }
    @IBOutlet weak var detailsCircleView: UIView!{
        didSet{
            detailsCircleView.layer.cornerRadius = detailsCircleView.frame.size.height/2
        }
    }
    
    @IBOutlet weak var detailsCircleBtn: UIButton!
    
    var didUpdate: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func detailsCircleBtnPressed(_ sender: Any) {
        didUpdate(detailsCircleBtn.tag)
    }
    
}
