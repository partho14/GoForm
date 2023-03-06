//
//  FormServeyListViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 23/2/23.
//

import UIKit
import Firebase
import GoogleSignIn

class FormServeyListViewController: UIViewController {

    @IBOutlet weak var headerTitleTextLbl: UILabel!{
        didSet{
            headerTitleTextLbl.font = UIFont(name: "Barlow-Bold", size: 20)

        }
    }
    @IBOutlet weak var emptyScreenTextLbl: UILabel!{
        didSet{
            emptyScreenTextLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)

        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var storeFormName: String = ""
    var formNameArray: [DataSnapshot] = []
    var formUserNameArray: [String] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formNameArray.removeAll()
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.peopleServeyScreenView = true
        formNameArray.removeAll()
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        self.emptyScreenTextLbl.alpha = 0
        DispatchQueue.main.async {
            self.getData()
        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //appDelegate.sharedFormTotalView = false
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        appDelegate.peopleServeyScreenView = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData(){
        if appDelegate.sharedFormTotalView {
            formNameArray.removeAll()
                print(appDelegate.peopleServeyScreenFormName)
            self.ref.child("GlobalForms").child(appDelegate.peopleServeyScreenFormName).child("Servey").queryOrderedByKey().observe(.value){ (snapshot) in
                        self.formNameArray.removeAll()
                        for event in snapshot.children.allObjects {

                            self.formNameArray.append(event as! DataSnapshot)
                            print(self.formNameArray)
                        }
                        self.getUserNameData()
                        //self.tableView.reloadData()
                        //LoadingIndicatorView.hide()
                    }
        }else{
            formNameArray.removeAll()
                print(appDelegate.peopleServeyScreenFormName)
            self.ref.child("UserDetails").child(appDelegate.uniqueID!).child("Form").child(appDelegate.peopleServeyScreenFormName).child("Servey").queryOrderedByKey().observe(.value){ (snapshot) in
                        self.formNameArray.removeAll()
                        for event in snapshot.children.allObjects {

                            self.formNameArray.append(event as! DataSnapshot)
                            print(self.formNameArray)
                        }
                        self.getUserNameData()
                        //self.tableView.reloadData()
                        //LoadingIndicatorView.hide()
                    }
        }
        
        //self.tableView.reloadData()
        //LoadingIndicatorView.hide()
    }
    
    func getUserNameData(){
        if(self.formNameArray.count == 0){
            self.emptyScreenTextLbl.alpha = 1
            self.scrollView.alpha = 0
            
        }else{
            self.emptyScreenTextLbl.alpha = 0
            self.scrollView.alpha = 1

        }
        self.formUserNameArray.removeAll()
            for i in 0 ..< (formNameArray.count){
                print(formNameArray[i].key)
                self.ref.child("UserDetails").child(formNameArray[i].key).child("UniqueName").queryOrderedByKey().observe(.value){ (snapshot) in
                    print(snapshot.value!)
                    self.formUserNameArray.append(snapshot.value! as! String)
                    print(self.formNameArray.count)
                    if(self.formNameArray.count == 0){
                        self.emptyScreenTextLbl.alpha = 1
                        self.scrollView.alpha = 0
                        
                    }else{
                        self.emptyScreenTextLbl.alpha = 0
                        self.scrollView.alpha = 1
            
                    }
                    self.tableView.reloadData()
                }
            }
            //self.tableView.reloadData()
            LoadingIndicatorView.hide()
    }
}
extension FormServeyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formUserNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FormServeyListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormServeyListTableViewCell", for: indexPath) as! FormServeyListTableViewCell
        if formUserNameArray.count > 0 {
            print(formUserNameArray.count)
            print(self.formUserNameArray[indexPath.row])
            cell.userName.text = self.formUserNameArray[indexPath.row]
            cell.userNameFirstLetter.text = self.formUserNameArray[indexPath.row].first?.description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if appDelegate.sharedFormTotalView {
            appDelegate.peoplwServeyUniqueId = self.formNameArray[indexPath.row].key
            appDelegate.sharedFormTotalView = true
            appDelegate.peopleServeyScreenView = false
            appDelegate.isFillupFormViewingView = false
            let storyboard = UIStoryboard(name: "Form", bundle: nil)
            let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
            self.navigationController?.pushViewController(formFillupViewController!, animated: true)
        }else{
            appDelegate.peoplwServeyUniqueId = self.formNameArray[indexPath.row].key
            appDelegate.peopleServeyScreenView = true
            appDelegate.isFillupFormViewingView = false
            let storyboard = UIStoryboard(name: "Form", bundle: nil)
            let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
            self.navigationController?.pushViewController(formFillupViewController!, animated: true)
        }
    }
    
}
