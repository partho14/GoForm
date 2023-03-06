//
//  SharedFormTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 22/2/23.
//

import UIKit

class SharedFormTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var notExpiredView: UIView!
    @IBOutlet weak var expiredView: UIView!
    
    @IBOutlet weak var publishedTextLbl: UILabel!{
        didSet{
            self.publishedTextLbl.font = UIFont(name: "Barlow-Medium", size: 12.0)
        }
    }
    @IBOutlet weak var inviteView: UIView!{
        didSet{
            inviteView.layer.cornerRadius = inviteView.frame.size.height/2
        }
    }
    @IBOutlet weak var emailShareView: UIView!{
        didSet{
            emailShareView.layer.cornerRadius = emailShareView.frame.size.height/2
        }
    }
    @IBOutlet weak var firstLetterView: UIView!{
        didSet{
            firstLetterView.layer.cornerRadius = firstLetterView.frame.size.height/2
        }
    }
    @IBOutlet weak var notExpiredFirstLetter: UILabel!{
        didSet{
            self.notExpiredFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var socialShareView: UIView!{
        didSet{
            socialShareView.layer.cornerRadius = socialShareView.frame.size.height/2
        }
    }
    @IBOutlet weak var notExpiredFormName: UILabel!{
        didSet{
            self.notExpiredFormName.font = UIFont(name: "Barlow-Medium", size: 20.0)
        }
    }
    @IBOutlet weak var notExpiredFormCreateDate: UILabel!{
        didSet{
            self.notExpiredFormCreateDate.font = UIFont(name: "Barlow-Medium", size: 12.0)
        }
    }
    @IBOutlet weak var notExpiredDatailsBtnView: UIView!{
        didSet{
            notExpiredDatailsBtnView.layer.cornerRadius = notExpiredDatailsBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var notExpiredTotalRecieveCount: UILabel!{
        didSet{
            self.notExpiredTotalRecieveCount.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    @IBOutlet weak var expiredFormName: UILabel!{
        didSet{
            self.expiredFormName.font = UIFont(name: "Barlow-Medium", size: 20.0)
        }
    }
    @IBOutlet weak var expiredFirstLetterView: UIView!{
        didSet{
            expiredFirstLetterView.layer.cornerRadius = expiredFirstLetterView.frame.size.height/2
        }
    }
    @IBOutlet weak var expiredFirstLetter: UILabel!{
        didSet{
            self.expiredFirstLetter.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var expiredDatailsBtnView: UIView!{
        didSet{
            expiredDatailsBtnView.layer.cornerRadius = expiredDatailsBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var expiredInviteView: UIView!{
        didSet{
            expiredInviteView.layer.cornerRadius = expiredInviteView.frame.size.height/2
        }
    }
    @IBOutlet weak var expiredTotalRecieveCount: UILabel!{
        didSet{
            self.expiredTotalRecieveCount.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    @IBOutlet weak var notExpiredTotalReceiveTextLbl: UILabel!{
        didSet{
            self.notExpiredTotalReceiveTextLbl.font = UIFont(name: "Barlow-Regular", size: 10.0)
        }
    }
    @IBOutlet weak var expiredTotalReceiveTextLbl: UILabel!{
        didSet{
            self.expiredTotalReceiveTextLbl.font = UIFont(name: "Barlow-Regular", size: 10.0)
        }
    }
    
    @IBOutlet weak var notExpiredEmailSmallShareView: UIView!{
        didSet{
            notExpiredEmailSmallShareView.layer.cornerRadius = notExpiredEmailSmallShareView.frame.size.height/2
        }
    }
    @IBOutlet weak var notExpiredSocialSmallShareView: UIView!{
        didSet{
            notExpiredSocialSmallShareView.layer.cornerRadius = notExpiredSocialSmallShareView.frame.size.height/2
        }
    }
    
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var propleCountBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
    
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
    
    @IBAction func showBtnPressed(_ sender: Any) {
        didShow(showBtn.tag)
    }
}
