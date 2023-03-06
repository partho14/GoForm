//
//  SubServeyListViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 23/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class SubServeyListViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var storeFormName: String = ""
    var formNameArray: [DataSnapshot] = []
    var formUserNameArray: [DataSnapshot] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeFormName = appDelegate.storeFormName
        formNameArray.removeAll()
        self.tableView.reloadData()
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
        appDelegate.pdfOpenFromServeyList = false
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func getData(){
        formNameArray.removeAll()

        if appDelegate.isSharedSubServey == true{
            
            self.ref.child("\(self.storeFormName)/Servey").queryOrderedByKey().observe(.value){ (snapshot) in
                    self.formNameArray.removeAll()
                    for event in snapshot.children.allObjects {

                        self.formNameArray.append(event as! DataSnapshot)
                        print(self.formNameArray)
                    }
                    print(self.formNameArray)
                    self.getUserNameData()
                    //self.tableView.reloadData()
                    //LoadingIndicatorView.hide()
                }

        }else{
            print(self.storeFormName)
            print("\(appDelegate.uniqueID!)\(self.storeFormName)/Servey")
            self.ref.child("\(appDelegate.uniqueID!)\(self.storeFormName)/Servey").queryOrderedByKey().observe(.value){ (snapshot) in
                    self.formNameArray.removeAll()
                    for event in snapshot.children.allObjects {

                        self.formNameArray.append(event as! DataSnapshot)
                        print(self.formNameArray)
                    }
                    print(self.formNameArray)
                    self.getUserNameData()
                    //self.tableView.reloadData()
                    //LoadingIndicatorView.hide()
                }

        }
        //self.tableView.reloadData()
        //LoadingIndicatorView.hide()
    }
    
    func getUserNameData(){
        self.formUserNameArray.removeAll()
        if appDelegate.isSharedSubServey == true{
            for i in 0 ..< (formNameArray.count){
                self.ref.child("\(self.storeFormName)/Servey").child(formNameArray[i].key).child("UniqueName").queryOrderedByKey().observe(.value){ (snapshot) in
                        //self.formUserNameArray.removeAll()
                        for event in snapshot.children.allObjects {

                            self.formUserNameArray.append(event as! DataSnapshot)
                            print(self.formUserNameArray)
                        }
                        print(self.formUserNameArray)
                        self.tableView.reloadData()
                        LoadingIndicatorView.hide()
                }
            }
        }else{
            for i in 0 ..< (formNameArray.count){
                self.ref.child("\(appDelegate.uniqueID!)\(self.storeFormName)/Servey").child(formNameArray[i].key).child("UniqueName").queryOrderedByKey().observe(.value){ (snapshot) in
                        //self.formUserNameArray.removeAll()
                        for event in snapshot.children.allObjects {

                            self.formUserNameArray.append(event as! DataSnapshot)
                            print(self.formUserNameArray)
                        }
                        print(self.formUserNameArray)
                        self.tableView.reloadData()
                        LoadingIndicatorView.hide()
                }
            }
        }
        self.tableView.reloadData()
        LoadingIndicatorView.hide()
    }


}

extension SubServeyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formUserNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubServeyListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SubServeyListTableViewCell", for: indexPath) as! SubServeyListTableViewCell
        if formNameArray.count > 0 {

            cell.formName.text = self.formUserNameArray[indexPath.row].value as! String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.pdfOpenFromServeyList = true
        appDelegate.formNameText = self.formNameArray[indexPath.row].key
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let serveyListDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ServeyListDetailsViewController") as? ServeyListDetailsViewController
        self.navigationController?.pushViewController(serveyListDetailsViewController!, animated: true)
        self.present(serveyListDetailsViewController!, animated: true, completion: nil)
    }

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//      if editingStyle == .delete {
//        print("Deleted")
//          let path: String = "\("\(appDelegate.uniqueID!)\(self.storeFormName)/Servey")/\(formNameArray[indexPath.row].key)"
//          //let path2: String = "\(appDelegate.uniqueID!)\(formNameArray[indexPath.row].key)"
//          self.ref.child(path).removeValue()
//         // self.ref.child(path2).removeValue()
//          self.getData()
//      }
//    }
    
}
