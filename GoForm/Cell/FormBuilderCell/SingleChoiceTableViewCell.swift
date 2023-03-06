//
//  SingleChoiceTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 3/2/23.
//

import UIKit

class SingleChoiceTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subCellView: UIView!
    @IBOutlet weak var subCellView2: UIView!
    @IBOutlet weak var singleChoiceBorderView: UIView!{
        didSet{
            singleChoiceBorderView.layer.borderWidth = 1
            singleChoiceBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            singleChoiceBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var singleChoiceTittleLbl: UILabel!{
        didSet{
            self.singleChoiceTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            singleChoiceTittleLbl.numberOfLines = 1
            singleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
            singleChoiceTittleLbl.textAlignment = .center
        }
    }
    
    @IBOutlet weak var singleChoiceEditBtnView: UIView!{
        didSet{
            singleChoiceEditBtnView.layer.borderWidth = 1
            singleChoiceEditBtnView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            singleChoiceEditBtnView.layer.cornerRadius = singleChoiceEditBtnView.frame.size.height/2
        }
    }
    @IBOutlet weak var singleChoiceDeleteBtnView: UIView!{
        didSet{
            singleChoiceDeleteBtnView.layer.borderWidth = 1
            singleChoiceDeleteBtnView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            singleChoiceDeleteBtnView.layer.cornerRadius = singleChoiceDeleteBtnView.frame.size.height/2
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var singleChoiceDeleteBtn: UIButton!
    @IBOutlet weak var singleChoiceEditBtn: UIButton!
    
    var didDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    var totalItem: [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subCellView2.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.isHidden = false
        //self.totalItem = appDelegate.formBuilderSingleChoice
    }
    func loadData(){
        self.totalItem = []
        self.totalItem = appDelegate.formBuilderSingleChoice
        print(self.totalItem)
        tableView.reloadData()
    }
    
    @IBAction func singleChoiceDeleteBtnPressed(_ sender: Any) {
        didDelete(singleChoiceDeleteBtn.tag)
       // appDelegate.formBuilderViewController?.removeCell(index: self.singleChoiceDeleteBtn.tag)
    }
    
    @IBAction func singleChoiceEditBtnPressed(_ sender: Any) {
        didUpdate(singleChoiceEditBtn.tag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SingleChoiceSubTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleChoiceSubTableViewCell", for: indexPath) as! SingleChoiceSubTableViewCell
        print(totalItem[indexPath.row])
        cell.optionSelectBtn.tag = indexPath.row + 1
        cell.radioImage.tag = indexPath.row + 1
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

