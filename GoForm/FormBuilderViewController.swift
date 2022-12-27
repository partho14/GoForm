//
//  FormBuilderViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 8/12/22.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class FormBuilderViewController: UIViewController {

    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var questionView: UIView!{
        didSet{
            questionView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var questionField: UITextField!
    
    @IBOutlet weak var formEditBigView: UIView!
    
    @IBOutlet weak var formNameView: UIView!
    @IBOutlet weak var formNameSmallView: UIView!{
        didSet{
            formNameSmallView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formNameField: UITextField!
    
    
    @IBOutlet weak var formEditView: UIView!{
        didSet{
            formEditView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formEditTextField: UITextField!
    
    @IBOutlet weak var formNameErrorText: UILabel!
    @IBOutlet weak var questionEditErrorText: UILabel!
    @IBOutlet weak var questionAddErrorText: UILabel!
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    
    
    var questionArray : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        
        self.formNameView.alpha = 1
        self.scrollView.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                 action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    func removeCell(index: Int){
        
        self.questionArray.remove(at: index)
        print(self.questionArray)
        self.tableView.reloadData()
    }
    
    @IBAction func itemAddBtn(_ sender: Any) {
        
        self.questionField.text = ""
        self.shadowView.alpha = 1
        
    }
    @IBAction func questionSubmitBtn(_ sender: Any) {
        
        if questionField.text?.count == 0 {
            self.questionAddErrorText.alpha = 1
        }else{
            self.questionAddErrorText.alpha = 0
            print(questionArray)
            questionArray.append(questionField.text ?? "Empty")
            self.shadowView.alpha = 0
            questionField.resignFirstResponder()
            tableView.reloadData()
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
        self.shadowView.alpha = 0
    }
    @IBAction func formnameSubmitBtn(_ sender: Any) {
        
        if formNameField.text?.count == 0{
            self.formNameErrorText.alpha = 1
        }else{
            formNameField.resignFirstResponder()
            self.formNameErrorText.alpha = 0
            self.formName.text  = (self.formNameField.text?.replacingOccurrences(of: " ", with: ""))!
            self.formNameView.alpha = 0
        }
        
    }
    @IBAction func formNameCancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func formSubmisionButton(_ sender: Any) {
        
        LoadingIndicatorView.show()
        var path: String = "\(appDelegate.uniqueID!)/\("Form")/\((self.formNameField.text?.replacingOccurrences(of: " ", with: ""))!)"
        var path2: String = "\(appDelegate.uniqueID!)\((self.formNameField.text?.replacingOccurrences(of: " ", with: ""))!)"
        let credential = ["data" : questionArray]
        self.ref.child(path).setValue(credential)
        self.ref.child(path2).setValue(credential)
        LoadingIndicatorView.hide()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func formEditSubmitBtn(_ sender: Any) {
        if formEditTextField.text?.count == 0 {
            self.questionEditErrorText.alpha = 1
        }else{
            self.questionEditErrorText.alpha = 0
            self.formEditView.alpha = 0
            self.formEditBigView.alpha = 0
            self.questionArray.insert((formEditTextField.text as? String)!, at: self.index)
            self.questionArray.remove(at:index + 1)
            self.tableView.reloadData()
        }
        
    }
    @IBAction func formEditCancelBtn(_ sender: Any) {
        self.formEditBigView.alpha = 0
        self.formEditView.alpha = 0
    }
    
    
    
    
}



extension FormBuilderViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
        if questionArray.count > 0{
            cell.deteteButton.tag = indexPath.row + 1
            cell.cellEditBtn.tag = indexPath.row + 1
            cell.didDelete = { [weak self] tag in
               self?.questionArray.remove(at:tag - 1)
               self?.tableView.reloadData()
            }
            cell.didUpdate = { [weak self] tag in
                self?.index = indexPath.row
                self?.formEditBigView.alpha = 1
                self?.formEditView.alpha = 1
                self?.formEditTextField.text = self?.questionArray[indexPath.row]
            }
            cell.questionName.text = questionArray[indexPath.row] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
