//
//  MultipleChoiceTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 3/2/23.
//

import UIKit

class MultipleChoiceTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var multipleChoiceBorderView: UIView!{
        didSet{
            multipleChoiceBorderView.layer.borderWidth = 1
            multipleChoiceBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            multipleChoiceBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var cellBigView: UIView!
    @IBOutlet weak var cellBigSubView: UIView!
    @IBOutlet weak var cellSmallView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var multipleChoiceEditBtnView: UIView!{
        didSet{
            multipleChoiceEditBtnView.layer.borderWidth = 1
            multipleChoiceEditBtnView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            multipleChoiceEditBtnView.layer.cornerRadius = multipleChoiceEditBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var multipleChoiceDeleteBtnView: UIView!{
        didSet{
            multipleChoiceDeleteBtnView.layer.borderWidth = 1
            multipleChoiceDeleteBtnView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            multipleChoiceDeleteBtnView.layer.cornerRadius = multipleChoiceDeleteBtnView.frame.size.height/2
        }
    }
    
    @IBOutlet weak var multipleChoiceDeleteViewBtn: UIButton!
    @IBOutlet weak var multipleChoiceEditViewBtn: UIButton!
    @IBOutlet weak var multipleChoiceTittle: UILabel!{
        didSet{
            self.multipleChoiceTittle.font = UIFont(name: "Barlow-Bold", size: 14.0)
            multipleChoiceTittle.numberOfLines = 1
            multipleChoiceTittle.adjustsFontSizeToFitWidth = true
            multipleChoiceTittle.textAlignment = .center
        }
    }
    
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    var totalItem: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellSmallView.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.isHidden = false
    }
    
    @IBAction func multipleChoiceDeleteBtnPressed(_ sender: Any) {
        didDelete(multipleChoiceDeleteViewBtn.tag)
    }
    
    @IBAction func multipleChoiceEditBtnPressed(_ sender: Any) {
        didUpdate(multipleChoiceEditViewBtn.tag)
    }
    
    func loadData(){
        self.totalItem = []
        self.totalItem = appDelegate.formBuilderMultipleChoice
        print(self.totalItem)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MultipleChoiceSubTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultipleChoiceSubTableViewCell", for: indexPath) as! MultipleChoiceSubTableViewCell
        print(totalItem[indexPath.row])
        cell.optionSelectBtn.tag = indexPath.row + 1
        cell.selectViewImage.tag = indexPath.row + 1
        cell.didUpdate = { [weak self] tag in
        }
        cell.cellView.frame.size.height = CGFloat(totalItem.count * 40)
        cell.tittleLbl.text = totalItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    


}
