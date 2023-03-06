//
//  SharedPeopleViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 2/1/23.
//

import UIKit
import Firebase
import GoogleSignIn

class SharedPeopleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var headerTittleTextLbl: UILabel!{
        didSet{
            headerTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 20)

        }
    }
    
    var storeFormName: String = ""
    var formNameArray: [DataSnapshot] = []
    var formUserNameArray: [String] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.formName.text = appDelegate.sharedPeopleViewFormName
        formNameArray.removeAll()
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
            
        self.ref.child("UserDetails").child(appDelegate.uniqueID!).child("Form").child(appDelegate.sharedPeopleViewFormName).child("Shared").queryOrderedByKey().observe(.value){ (snapshot) in
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
        
        //self.tableView.reloadData()
        //LoadingIndicatorView.hide()
    }
    
    func getUserNameData(){
        print(formNameArray.count)
        self.formUserNameArray.removeAll()
            for i in 0 ..< (formNameArray.count){
                print(formNameArray[i].key)
                self.ref.child("UserDetails").child(formNameArray[i].key).child("UniqueName").queryOrderedByKey().observe(.value){ (snapshot) in
                    print(snapshot.value!)
                    self.formUserNameArray.append(snapshot.value! as! String)
                    self.tableView.reloadData()
                }
            }
            //self.tableView.reloadData()
            LoadingIndicatorView.hide()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SharedPeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formUserNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SharedPeopleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SharedPeopleTableViewCell", for: indexPath) as! SharedPeopleTableViewCell
        if formUserNameArray.count > 0 {
            print(formUserNameArray.count)
            print(self.formUserNameArray[indexPath.row])
            cell.usersName.text = self.formUserNameArray[indexPath.row]
            cell.userNameFirstLetter.text = self.formUserNameArray[indexPath.row].first?.description
            
            if ("\(self.formNameArray[indexPath.row].value!)" == "Yes"){
                cell.statusSwitch.setOn(true, animated: false)
            }else{
                cell.statusSwitch.setOn(false, animated: false)
            }
            
            cell.didUpdate = { [weak self] tag in
                print(self!.formUserNameArray[indexPath.row])
                let path: String = "UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.sharedPeopleViewFormName)/Shared/\(self!.formNameArray[indexPath.row].key)"
                let path2: String = "UserDetails/\(self!.formNameArray[indexPath.row].key)/Shared/\(appDelegate.uniqueID!)\(appDelegate.sharedPeopleViewFormName)"
                if cell.statusSwitch.isOn {
                    self!.ref.child(path).setValue("Yes")
                    self!.ref.child(path2).setValue("Yes")
                }else{
                    self!.ref.child(path).setValue("No")
                    self!.ref.child(path2).setValue("No")
                }
            }
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
          print("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.sharedPeopleViewFormName)/Shared/\(formNameArray[indexPath.row].key)")
          print("\(formNameArray[indexPath.row].key)/Shared/\(appDelegate.uniqueID!)\(appDelegate.sharedPeopleViewFormName)")
          let path: String = "UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.sharedPeopleViewFormName)/Shared/\(formNameArray[indexPath.row].key)"
          let path2: String = "UserDetails/\(formNameArray[indexPath.row].key)/Shared/\(appDelegate.uniqueID!)\(appDelegate.sharedPeopleViewFormName)"
          self.formNameArray.remove(at: indexPath.row)
          self.formUserNameArray.remove(at: indexPath.row)
          self.ref.child(path).removeValue()
          self.ref.child(path2).removeValue()
          self.tableView.reloadData()
      }
    }
    
}
