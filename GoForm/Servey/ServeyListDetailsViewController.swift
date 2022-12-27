//
//  ServeyListDetailsViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 23/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class ServeyListDetailsViewController: UIViewController {

    @IBOutlet weak var formname: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var formNameText: String? = ""
    var storeFormName: String = ""
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    
    var questionArray : [String] = []
    var ansArray: [String] = []
    var questionArray2: [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeFormName = appDelegate.storeFormName
        self.formname.text = appDelegate.storeFormName
        self.formNameText = appDelegate.formNameText
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
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
        DispatchQueue.main.async {
            self.getData()
        }
    }
    
    func getData(){
        questionArray.removeAll()
        ansArray.removeAll()
        self.ref.child("\(appDelegate.uniqueID!)\(self.storeFormName)/Servey/").child(formNameText!).child("Data").queryOrderedByKey().observe(.value){ (snapshot)  in
            self.questionArray.removeAll()
            self.ansArray.removeAll()
            self.questionArray2.removeAll()
            for event in snapshot.children.allObjects {
    
                self.questionArray2.append(event as! DataSnapshot)
            }
            print(self.questionArray2)
            self.questionArray.removeAll()
            self.ansArray.removeAll()
            for i in 0 ..< (self.questionArray2.count) {
                self.questionArray.append((self.questionArray2[i].key) as! String)
                self.ansArray.append((self.questionArray2[i].value) as! String)
            }
            
            print(self.questionArray)
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
        }
        
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ServeyListDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServeyListDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ServeyListDetailsTableViewCell", for: indexPath) as! ServeyListDetailsTableViewCell
        if questionArray.count > 0{
//            cell.deteteButton.tag = indexPath.row + 1
//            cell.cellEditBtn.tag = indexPath.row + 1
//            cell.didDelete = { [weak self] tag in
//               self?.questionArray.remove(at:tag - 1)
//               self?.tableView.reloadData()
//            }
//            cell.didUpdate = { [weak self] tag in
//                self?.index = indexPath.row
//                self?.formEditView.alpha = 1
//                self?.formEditTextField.text = self?.questionArray[indexPath.row]
//            }
            cell.formQuestion.text = questionArray[indexPath.row] as? String
            cell.formQuestionAns.text = ansArray[indexPath.row] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}