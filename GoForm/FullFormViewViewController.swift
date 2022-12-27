//
//  FullFormViewViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 9/12/22.
//
import UIKit
import Firebase
import GoogleSignIn

class FullFormViewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var formEditView: UIView!{
        didSet{
            formEditView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formNameView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var formNameField: UITextField!
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var questionView: UIView!{
        didSet{
            questionView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formEditTextField: UITextField!
    
    @IBOutlet weak var questionEditText: UILabel!
    @IBOutlet weak var formNameErrorText: UILabel!
    @IBOutlet weak var questioneditErrorText: UILabel!
    
    
    var formNameText: String? = ""
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    
    var questionArray : [String] = []
    var questionArray2: [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formName.text = appDelegate.formNameText
        self.formNameText = appDelegate.formNameText
        print(formNameText)
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        
        self.formNameView.alpha = 0
        self.scrollView.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                 action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData(){
        questionArray.removeAll()
        self.ref.child(appDelegate.uniqueID!).child("Form").child(formNameText!).child("data").queryOrderedByKey().observe(.value){ (snapshot)  in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {
    
                self.questionArray2.append(event as! DataSnapshot)
            }
    
            for i in 0 ..< (self.questionArray2.count) {
                self.questionArray.append((self.questionArray2[i].value) as! String)
            }
            
            print(self.questionArray)
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
        }
        
    }
    
    func removeCell(index: Int){
        
        self.questionArray.remove(at: index)
        print(self.questionArray)
        self.tableView.reloadData()
    }
    
    @IBAction func itemAddBtn(_ sender: Any) {
        
        self.shadowView.alpha = 1
        self.questionField.text = ""
        
    }
    
    @IBAction func questionSubmitBtn(_ sender: Any) {
        
        if questionField.text?.count == 0 {
            self.questionEditText.alpha = 1
        }else{
            print(questionArray)
            questionArray.append(questionField.text ?? "Empty")
            self.questionEditText.alpha = 0
            self.shadowView.alpha = 0
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
            self.formName.text  = self.formNameField.text ?? "Empty"
            self.formNameErrorText.alpha = 0
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
        let path: String = "\(appDelegate.uniqueID!)/\("Form")/\(formNameText!)"
        let path2: String = "\(appDelegate.uniqueID!)\(formNameText!)"
        let credential = ["data" : questionArray]
        self.ref.child(path).setValue(credential)
        self.ref.child(path2).setValue(credential)
        LoadingIndicatorView.hide()
        self.navigationController?.popViewController(animated: true)
        
    }
    

    @IBAction func formEditSubmitBtn(_ sender: Any) {
        
        if formEditTextField.text?.count == 0 {
            self.questioneditErrorText.alpha = 1
        }else{
            self.questioneditErrorText.alpha = 0
            self.formEditView.alpha = 0
            self.questionArray.insert((formEditTextField.text as? String)!, at: self.index)
            self.questionArray.remove(at:index + 1)
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func formEditCancelBtn(_ sender: Any) {        self.formEditView.alpha = 0
    }
    
}



extension FullFormViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FullFormViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FullFormViewTableViewCell", for: indexPath) as! FullFormViewTableViewCell
        if questionArray.count > 0{
            cell.deteteButton.tag = indexPath.row + 1
            cell.cellEditBtn.tag = indexPath.row + 1
            cell.didDelete = { [weak self] tag in
               self?.questionArray.remove(at:tag - 1)
               self?.tableView.reloadData()
            }
            cell.didUpdate = { [weak self] tag in
                self?.index = indexPath.row
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

