//
//  MyServeyTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 22/12/22.
//

import UIKit

class MyServeyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formNameFirstLetter: UILabel!{
        didSet{
            self.formNameFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var fullFormName: UILabel!{
        didSet{
            self.fullFormName.font = UIFont(name: "Barlow-Medium", size: 20.0)
        }
    }
    
    
    @IBOutlet weak var submittedTextLbl: UILabel!{
        didSet{
            self.submittedTextLbl.font = UIFont(name: "Barlow-Bold", size: 12.0)
        }
    }
    @IBOutlet weak var submissionDate: UILabel!{
        didSet{
            self.submissionDate.font = UIFont(name: "Barlow-Regular", size: 12.0)
        }
    }
    @IBOutlet weak var cellDetailsbtnView: UIView!{
        didSet{
            cellDetailsbtnView.layer.cornerRadius = cellDetailsbtnView.frame.size.height/2
        }
    }
    
    @IBOutlet weak var formFirstLetterView: UIView!{
        didSet{
            formFirstLetterView.layer.cornerRadius = formFirstLetterView.frame.size.height/2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
