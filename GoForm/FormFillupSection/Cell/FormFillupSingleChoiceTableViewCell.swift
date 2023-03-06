//
//  FormFillupSingleChoiceTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import UIKit

class FormFillupSingleChoiceTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var singleChoiceBigView: UIView!
    @IBOutlet weak var singleChoiceBorderView: UIView!{
        didSet{
            singleChoiceBorderView.layer.borderWidth = 1
            singleChoiceBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            singleChoiceBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var singleChoiceSmallView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var singleChoiceTittleLbl: UILabel!{
        didSet{
            self.singleChoiceTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            singleChoiceTittleLbl.numberOfLines = 1
            singleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
            singleChoiceTittleLbl.textAlignment = .center
        }
    }
    var totalItem: [String] = []
    var index = -1
    var didUpdate: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.singleChoiceSmallView.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.isHidden = false
    }
    
    func loadData(){
        self.totalItem = []
        self.totalItem = appDelegate.formBuilderSingleChoice
        print(self.totalItem)
        tableView.reloadData()
    }
    
    func loadDataForShow(){
        self.index = appDelegate.singleChoiceAnsIndex
        self.totalItem = []
        self.totalItem = appDelegate.formBuilderSingleChoice
        print(self.totalItem)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FormFillupSingleChoiceSubTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupSingleChoiceSubTableViewCell", for: indexPath) as! FormFillupSingleChoiceSubTableViewCell
        print(totalItem[indexPath.row])
        cell.optionSelectBtn.tag = indexPath.row + 1
        cell.radioImage.tag = indexPath.row + 1
        if (index == indexPath.row){
            cell.radioImage.image = UIImage(named:"radio_button_select")
        }else{
            cell.radioImage.image = UIImage(named:"radio_button_unselect")
        }
        cell.didUpdate = { [weak self] tag in
            self?.index = indexPath.row
            self?.didUpdate(tableView.tag)
            tableView.reloadData()
            //cell.radioImage.image = UIImage(named:"radio_button_select")
        }
        cell.cellView.frame.size.height = CGFloat(totalItem.count * 40)
        cell.tittleLbl.text = totalItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
