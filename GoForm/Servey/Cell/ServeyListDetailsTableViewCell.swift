//
//  ServeyListDetailsTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 23/12/22.
//

import UIKit

class ServeyListDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var formQuestion: UILabel!
    @IBOutlet weak var formQuestionAns: UITextField!
    
    @IBOutlet weak var pdfShowBtn: UIButton!
    @IBOutlet weak var pdfnameLbl: UILabel!
    @IBOutlet weak var addFileView: UIView!{
        didSet{
            addFileView.layer.cornerRadius = 10
            addFileView.layer.borderWidth = 1
            addFileView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    var didPdfShow: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func pdfShowClicked(_ sender: Any) {
        didPdfShow(pdfShowBtn.tag)
    }
    
}
