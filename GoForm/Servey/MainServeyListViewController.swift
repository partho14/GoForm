//
//  MainServeyListViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 22/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class MainServeyListViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var subServeyList: SubServeyListViewController?
    
    var storeFormNameArray: [DataSnapshot] = []
    var sharedFormArray: [DataSnapshot] = []
    var formNameArray: [DataSnapshot] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeFormNameArray = appDelegate.formNameArray
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
    
    func getData(){
        sharedFormArray.removeAll()
        self.ref.child("\(appDelegate.uniqueID!)").child("Shared").queryOrderedByKey().observe(.value){ (snapshot) in
                self.sharedFormArray.removeAll()
                for event in snapshot.children.allObjects {

                    self.sharedFormArray.append(event as! DataSnapshot)
                }
                self.tableView.reloadData()
                LoadingIndicatorView.hide()
            }
        
        self.tableView.reloadData()
        LoadingIndicatorView.hide()
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainServeyListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sharedFormArray.count == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "My Form"
        }else{
            return "Shared Form"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return storeFormNameArray.count
        }else{
            return sharedFormArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainServeyListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainServeyListTableViewCell", for: indexPath) as! MainServeyListTableViewCell
        if indexPath.section == 0 {
            if storeFormNameArray.count > 0 {

                cell.formName.text = self.storeFormNameArray[indexPath.row].key as? String
            }
            return cell
        }else{
            if sharedFormArray.count > 0 {
                let index = self.sharedFormArray[indexPath.row].key.index(self.sharedFormArray[indexPath.row].key.startIndex, offsetBy: 21)
                let subString = self.sharedFormArray[indexPath.row].key.substring(from: index)
                cell.formName.text = subString
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            appDelegate.isSharedSubServey = false
            appDelegate.isSharedSubServeyDetails = false
            appDelegate.myFormPdfShowID = appDelegate.uniqueID!
            appDelegate.storeFormName = (self.storeFormNameArray[indexPath.row].key as? String)!
            let storyboard = UIStoryboard(name: "User", bundle: nil)
            let subServeyListViewController = storyboard.instantiateViewController(withIdentifier: "SubServeyListViewController") as? SubServeyListViewController
            self.navigationController?.pushViewController(subServeyListViewController!, animated: true)
            self.present(subServeyListViewController!, animated: true, completion: nil)
        }else{
            appDelegate.isSharedSubServey = true
            appDelegate.isSharedSubServeyDetails = true
            appDelegate.myFormPdfShowID = ""
            appDelegate.storeFormName = (self.sharedFormArray[indexPath.row].key as? String)!
            let storyboard = UIStoryboard(name: "User", bundle: nil)
            let subServeyListViewController = storyboard.instantiateViewController(withIdentifier: "SubServeyListViewController") as? SubServeyListViewController
            self.navigationController?.pushViewController(subServeyListViewController!, animated: true)
            self.present(subServeyListViewController!, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        if indexPath.section == 0{
            if editingStyle == .delete {
              print("Deleted")
                let path: String = "\(appDelegate.uniqueID!)\(storeFormNameArray[indexPath.row].key)"
                self.ref.child(path).child("Servey").removeValue()
                self.getData()
            }
        }else{
           
        }
    }
    
}
