//
//  MainServeyListViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 22/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class MainServeyListViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var subServeyList: SubServeyListViewController?
    
    var storeFormNameArray: [DataSnapshot] = []
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
        formNameArray.removeAll()
        for i in 0 ..< (storeFormNameArray.count) {
            self.ref.child("\(appDelegate.uniqueID!)\(storeFormNameArray[i].key)/Servey").queryOrderedByKey().observe(.value){ (snapshot) in
                //self.formNameArray.removeAll()
                for event in snapshot.children.allObjects {

                    self.formNameArray.append(event as! DataSnapshot)
                    print(self.formNameArray)
                }
                LoadingIndicatorView.hide()
            }
        }
        print(self.formNameArray)
        self.tableView.reloadData()
        LoadingIndicatorView.hide()
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainServeyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeFormNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainServeyListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainServeyListTableViewCell", for: indexPath) as! MainServeyListTableViewCell
        if storeFormNameArray.count > 0 {

            cell.formName.text = self.storeFormNameArray[indexPath.row].key as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.storeFormName = (self.storeFormNameArray[indexPath.row].key as? String)!
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let subServeyListViewController = storyboard.instantiateViewController(withIdentifier: "SubServeyListViewController") as? SubServeyListViewController
        self.navigationController?.pushViewController(subServeyListViewController!, animated: true)
        self.present(subServeyListViewController!, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
          let path: String = "\(appDelegate.uniqueID!)\(storeFormNameArray[indexPath.row].key)"
          self.ref.child(path).child("Servey").removeValue()
          self.getData()
      }
    }
    
}
