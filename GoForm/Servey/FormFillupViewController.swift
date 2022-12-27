//
//  FormFillupViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 9/12/22.
//

import UIKit
import GoogleSignIn
import Firebase

class FormFillupViewController: UIViewController {
    
    @IBOutlet weak var formNameSmallView: UIView!{
        didSet{
            formNameSmallView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formNameView: UIView!
    @IBOutlet weak var formNameTextField: UITextField!
    @IBOutlet weak var formNameField: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    var splitUrl: String = ""
    var filterFormName: String = ""
    
    var questionArray : [DataSnapshot] = []
    var questionArray2 : [String] = []
    var combineArray = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.formNameView.alpha = 1
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        self.scrollView.addSubview(tableView)
        let tapGesture = UITapGestureRecognizer(target: self,
                                 action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
        if appDelegate.urlForm == 1 {
            self.handleDeepLink()
        }
    }
    
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideKeyboard()
    }
    
    func getData(){
        
        questionArray.removeAll()
        print(formNameTextField.text!)
        self.ref.child(splitUrl).child("data").queryOrderedByKey().observe(.value){ (snapshot) in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {

                self.questionArray.append(event as! DataSnapshot)
            }
            self.questionArray2 = Array(repeating: "", count: self.questionArray.count)
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
        }
    }
    
    func getDataForUrl(){
        
        questionArray.removeAll()
        self.ref.child(appDelegate.splitUrl).child("data").queryOrderedByKey().observe(.value){ (snapshot) in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {

                self.questionArray.append(event as! DataSnapshot)
            }
            self.questionArray2 = Array(repeating: "", count: self.questionArray.count)
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
        }
    }
    
    func handleDeepLink(){
        self.formNameView.alpha = 0
        let index = appDelegate.splitUrl.index(appDelegate.splitUrl.startIndex, offsetBy: 21)
        let subString = appDelegate.splitUrl.substring(from: index)
        self.formNameField.text = subString
        print(appDelegate.splitUrl)
        self.getDataForUrl()
    }
    
    
    @IBAction func formNameSubmitBtn(_ sender: Any) {
        
        if formNameTextField.text?.count == 0 {
            
        }else{
            self.formNameView.alpha = 0
            let splitUrlFUll = formNameTextField.text?.components(separatedBy: "=")
            self.splitUrl = splitUrlFUll?.last ?? ""
            let index = self.splitUrl.index(self.splitUrl.startIndex, offsetBy: 21)
            let subString = self.splitUrl.substring(from: index)
            self.formNameField.text = subString
            hideKeyboard()
            self.getData()
        }
        
    }
    
    @IBAction func formNameCancelBtn(_ sender: Any) {
        self.formNameView.alpha = 1
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func formSubmitBtn(_ sender: Any) {
        
        for i in 0 ..< questionArray.count {
            combineArray.append(["\(questionArray[i].value!)" : "\(questionArray2[i])"])
        }
        LoadingIndicatorView.show()
        if appDelegate.urlForm == 1 {
            let serveyPath: String = "\(appDelegate.uniqueID!)/\("Servey")/\(appDelegate.splitUrl)"
            let path: String = "\(appDelegate.splitUrl)"
            let path2: String = "\(appDelegate.uniqueID!)"
            let credential = ["data" : combineArray]
            for i in 0 ..< questionArray.count {
                self.ref.child(path).child("Servey").child(path2).child("UniqueName").child("Name").setValue("\(appDelegate.currentUserName)")
                self.ref.child(path).child("Servey").child(path2).child("Data").child("\(questionArray[i].value!)").setValue("\(questionArray2[i])")
                self.ref.child(serveyPath).child("\(questionArray[i].value!)").setValue("\(questionArray2[i])")
            }
//            self.ref.child(path).child(path2).setValue(credential)
//            self.ref.child(serveyPath).setValue(credential)
        }else{
            let serveyPath: String = "\(appDelegate.uniqueID!)/\("Servey")/\(self.splitUrl)"
            let path: String = "\(self.splitUrl)"
            let path2: String = "\(appDelegate.uniqueID!)"
            let credential = ["data" : combineArray]
            for i in 0 ..< questionArray.count {
                self.ref.child(path).child("Servey").child(path2).child("UniqueName").child("Name").setValue("\(appDelegate.currentUserName)")
                self.ref.child(path).child("Servey").child(path2).child("Data").child("\(questionArray[i].value!)").setValue("\(questionArray2[i])")
                self.ref.child(serveyPath).child("\(questionArray[i].value!)").setValue("\(questionArray2[i])")
            }
//            self.ref.child(path).child(path2).setValue(credential)
//            self.ref.child(serveyPath).setValue(credential)
        }
        LoadingIndicatorView.hide()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension FormFillupViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FormFillupTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupTableViewCell", for: indexPath) as! FormFillupTableViewCell
        if questionArray.count > 0 {
            cell.question.text = self.questionArray[indexPath.row].value as? String
            cell.textField.tag = indexPath.row
            cell.didSaveText = { [weak self] tag in
                self?.index = 0
                self?.index = indexPath.row
                print(self?.index)
                self?.questionArray2.remove(at: self!.index)
                self?.questionArray2.insert((cell.textField.text)!, at: self!.index)
                //self?.questionArray2.remove(at: self!.index + 1)
                //self?.tableView.reloadData()
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
