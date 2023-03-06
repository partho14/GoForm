//
//  UserListViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 31/1/23.
//

import UIKit
import Firebase
import GoogleSignIn

class UserListViewController: UIViewController {
    
    
    @IBOutlet weak var headerTittleLbl: UILabel!{
        didSet{
            self.headerTittleLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchView: UIView!{
        didSet{
            searchView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    
    var userIdArray: [DataSnapshot] = []
    var userNameArray: [String] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdArray.removeAll()
        userNameArray.removeAll()
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
        userIdArray.removeAll()
            
        self.ref.child("AllUsers").queryOrderedByKey().observe(.value){ (snapshot) in
                    self.userIdArray.removeAll()
                    for event in snapshot.children.allObjects {

                        self.userIdArray.append(event as! DataSnapshot)
                    }
                    self.getUserNameData()
                    //self.tableView.reloadData()
                    //LoadingIndicatorView.hide()
                }
        
        //self.tableView.reloadData()
        //LoadingIndicatorView.hide()
    }
    
    func getUserNameData(){
        
        if (userIdArray.count > 1){
            self.userNameArray.removeAll()
                for i in 1 ..< (userIdArray.count){
                    print(userIdArray[i].value)
                    self.ref.child(userIdArray[i].value as! String).child("UniqueName").queryOrderedByKey().observe(.value){ (snapshot) in
                        print(snapshot.value!)
                        self.userNameArray.append(snapshot.value! as! String)
                        self.tableView.reloadData()
                    }
                }
                //self.tableView.reloadData()
                LoadingIndicatorView.hide()
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell
        if userNameArray.count > 0 {
            cell.userName.text = userNameArray[indexPath.row]
            cell.userNameFirstLetter.text = self.userNameArray[indexPath.row].first?.description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        appDelegate.formNameText = self.formNameArray[indexPath.row].key
    //        let storyboard = UIStoryboard(name: "User", bundle: nil)
    //        let serveyListDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ServeyListDetailsViewController") as? ServeyListDetailsViewController
    //        self.navigationController?.pushViewController(serveyListDetailsViewController!, animated: true)
    //        self.present(serveyListDetailsViewController!, animated: true, completion: nil)
    //    }
}

