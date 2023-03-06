//
//  MyServeyViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 22/12/22.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class MyServeyViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyformLbl: UILabel!{
        didSet{
            self.emptyformLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    @IBOutlet weak var headerTittleTextLbl: UILabel!{
        didSet{
            self.headerTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    var questionArray: [DataSnapshot] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().removeAllObservers()
        questionArray.removeAll()
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.getData()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Database.database().reference().removeAllObservers()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData(){
        questionArray.removeAll()
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/mysubmit").queryOrderedByKey().observe(.value){ (snapshot) in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {

                self.questionArray.append(event as! DataSnapshot)
            }
            if(self.questionArray.count == 0){
                self.emptyformLbl.alpha = 1
                self.scrollView.alpha = 0
                
            }else{
                self.emptyformLbl.alpha = 0
                self.scrollView.alpha = 1
    
            }
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
        }
    }

}

extension MyServeyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyServeyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyServeyTableViewCell", for: indexPath) as! MyServeyTableViewCell
        if questionArray.count > 0 {
            let index = self.questionArray[indexPath.row].key.index(self.questionArray[indexPath.row].key.startIndex, offsetBy: 28)
            let subString = self.questionArray[indexPath.row].key.substring(from: index)
            cell.fullFormName.text = subString as? String
            
            cell.formNameFirstLetter.text = subString.first?.description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.isFillupFormViewingView = true
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
        appDelegate.currentNav?.pushViewController(formFillupViewController!, animated: true)
        appDelegate.isFillupFormViewingFormName = self.questionArray[indexPath.row].key as? String
        self.navigationController?.pushViewController(formFillupViewController!, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
          let path: String = "\(appDelegate.uniqueID!)/\("Servey")/\(questionArray[indexPath.row].key)"
          let path2: String = "\(appDelegate.uniqueID!)\(questionArray[indexPath.row].key)"
          self.ref.child(path).removeValue()
          self.ref.child(path2).removeValue()
          self.getData()
      }
    }
    
}

