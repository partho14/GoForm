//
//  MainViewTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 8/12/22.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var inviteView: UIView!{
        didSet{
            inviteView.layer.cornerRadius = inviteView.frame.size.height/2
        }
    }
    @IBOutlet weak var editView: UIView!{
        didSet{
            editView.layer.cornerRadius = editView.frame.size.height/2
        }
    }
    @IBOutlet weak var shareView: UIView!{
        didSet{
            shareView.layer.cornerRadius = shareView.frame.size.height/2
        }
    }
    @IBOutlet weak var detailsButtonView: UIView!{
        didSet{
            detailsButtonView.layer.cornerRadius = detailsButtonView.frame.size.height/2
        }
    }
    @IBOutlet weak var firstLetterView: UIView!{
        didSet{
            firstLetterView.layer.cornerRadius = firstLetterView.frame.size.height/2
        }
    }
    
    @IBOutlet weak var shareSmallBtnView: UIView!{
        didSet{
            shareSmallBtnView.layer.cornerRadius = shareSmallBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var shareSmallBtnView2: UIView!{
        didSet{
            shareSmallBtnView2.layer.cornerRadius = shareSmallBtnView2.frame.size.height/2
        }
    }
    
    
    
    @IBOutlet weak var expiredFirstLetterView: UIView!{
        didSet{
            expiredFirstLetterView.layer.cornerRadius = expiredFirstLetterView.frame.size.height/2
        }
    }
    @IBOutlet weak var expiredEditView: UIView!{
        didSet{
            expiredEditView.layer.cornerRadius = expiredEditView.frame.size.height/2
        }
    }
    @IBOutlet weak var expiredViewFirstLetter: UILabel!{
        didSet{
            self.expiredViewFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var expiredViewFormReceivedCount: UILabel!
    @IBOutlet weak var expiredViewFormName: UILabel!{
        didSet{
            self.expiredViewFormName.font = UIFont(name: "Barlow-Medium", size: 20.0)
        }
    }
    @IBOutlet weak var expiredCellView: UIView!
    @IBOutlet weak var expiredCellDetailsView: UIView!{
        didSet{
            expiredCellDetailsView.layer.cornerRadius = expiredCellDetailsView.frame.size.height/2
        }
    }
    
    @IBOutlet weak var totalViewdView: UIView!
    @IBOutlet weak var expiredView: UIView!
    @IBOutlet weak var publishedLbl: UILabel!{
        didSet{
            self.publishedLbl.font = UIFont(name: "Barlow-Regular", size: 12.0)
        }
    }
    @IBOutlet weak var publishedDateLbl: UILabel!{
        didSet{
            self.publishedDateLbl.font = UIFont(name: "Barlow-Medium", size: 12.0)
        }
    }
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var formName: UILabel!{
        didSet{
            self.formName.font = UIFont(name: "Barlow-Medium", size: 20.0)
        }
    }
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var propleCountBtn: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var notExpiredFirstLetter: UILabel!{
        didSet{
            self.notExpiredFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var showBtn: UIButton!
    
    @IBOutlet weak var notExpiredTotalReceiveTextLbl: UILabel!{
        didSet{
            self.notExpiredTotalReceiveTextLbl.font = UIFont(name: "Barlow-Regular", size: 10.0)
        }
    }
    @IBOutlet weak var notExpiredTotalValue: UILabel!{
        didSet{
            self.notExpiredTotalValue.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    @IBOutlet weak var expiredTotalReceiveTextLbl: UILabel!{
        didSet{
            self.expiredTotalReceiveTextLbl.font = UIFont(name: "Barlow-Regular", size: 10.0)
        }
    }
    @IBOutlet weak var expiredTotalValue: UILabel!{
        didSet{
            self.expiredTotalValue.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    var didShare: (Int) -> ()  = { _ in }
    var didAdd: (Int) -> ()  = { _ in }
    var didCount: (Int) -> ()  = { _ in }
    var didShow: (Int) -> ()  = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        didShare(shareBtn.tag)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        didAdd(addBtn.tag)
    }
    
    @IBAction func peopleCountBtnClicked(_ sender: Any) {
        didCount(propleCountBtn.tag)
    }
    
    @IBAction func expiredTotalServeyViewBtnClicked(_ sender: Any) {
        didShow(showBtn.tag)
    }
    
    
}
