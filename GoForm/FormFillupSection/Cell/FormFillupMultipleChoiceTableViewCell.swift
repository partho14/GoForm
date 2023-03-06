//
//  FormFillupMultipleChoiceTableViewCell.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import UIKit

class FormFillupMultipleChoiceTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var multipleChoiceBigView: UIView!
    @IBOutlet weak var multipleChoiceBorderView: UIView!{
        didSet{
            multipleChoiceBorderView.layer.borderWidth = 1
            multipleChoiceBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            multipleChoiceBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var multipleChoiceSmallView: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var multipleChoiceTittleLbl: UILabel!{
        didSet{
            self.multipleChoiceTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            multipleChoiceTittleLbl.numberOfLines = 1
            multipleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
            multipleChoiceTittleLbl.textAlignment = .center
        }
    }
    var totalItem: [String] = []
    var storeIndex: [Int] = []
    var check = 0
    var didUpdate: (Int) -> ()  = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.multipleChoiceSmallView.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.isHidden = false
    }
    
    func loadData(){
        self.totalItem = []
        self.totalItem = appDelegate.formBuilderMultipleChoice
        print(self.totalItem)
        tableView.reloadData()
    }
    
    func loadDataForShow(){
        self.storeIndex = appDelegate.multipleChoiceStoreIndex
        self.totalItem = []
        self.totalItem = appDelegate.formBuilderMultipleChoice
        print(self.totalItem)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FormFillupMultipleChoiceSubTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupMultipleChoiceSubTableViewCell", for: indexPath) as! FormFillupMultipleChoiceSubTableViewCell
        cell.optionSelectBtn.tag = indexPath.row + 1
        cell.optionSelectImage.tag = indexPath.row + 1
        cell.optionSelectImage.image = UIImage(named:"")
        print(self.storeIndex)
        for i in 0 ..< self.storeIndex.count{
            if self.storeIndex[i] == indexPath.row{
                if self.storeIndex.count >= 1 {
                    print(self.storeIndex.count)
                    cell.optionSelectImage.image = UIImage(named:"icon_ok")
                }else{
                    cell.optionSelectImage.image = UIImage(named:"")
                }
            }else{
            }
        }
        cell.didUpdate = { [weak self] tag in
            print(self!.check)
            for i in 0 ..< self!.storeIndex.count{
                print(self!.storeIndex.count)
                if self!.storeIndex[i] == indexPath.row{
                    self?.storeIndex.remove(at: i)
                    print(self!.storeIndex.count)
                    self!.check = 1
                    if self?.storeIndex.count == 0{
                        self!.check = 0
                        self?.storeIndex = []
                        print(self?.storeIndex.count)
                        break
                    }
                    break
                }else{
                    self!.check = 0
                }
            }
            if self!.check == 0{
                self?.storeIndex.append(indexPath.row)
            }
            self?.didUpdate(tableView.tag)
            self?.tableView.reloadData()
        }
        cell.cellView.frame.size.height = CGFloat(totalItem.count * 40)
        cell.tittleLbl.text = totalItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
