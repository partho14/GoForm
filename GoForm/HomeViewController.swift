//
//  ViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 6/12/22.
//

import UIKit
import Firebase
import GoogleSignIn


class HomeViewController: UIViewController {
    
//    var navigationDrawer:NavigationDrawer!
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var firstName: String?
    var lastName: String?
    
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var sendedData: UILabel!
    @IBOutlet weak var userName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        getData()
//        let options = NavigationDrawerOptions()
//        options.navigationDrawerType = .leftDrawer
//        options.navigationDrawerOpenDirection = .anyWhere
//        options.navigationDrawerYPosition = 0
//        options.navigationDrawerAnchorController = .window
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
//        navigationDrawer = NavigationDrawer.instance
//        navigationDrawer.setup(withOptions: options)
//        navigationDrawer.setNavigationDrawerController(viewController: vc)
    }
    
    func getData(){
        self.ref.child(appDelegate.uniqueID!).queryOrderedByKey().observe(.value){ (snapshot) in
            self.firstName = snapshot.childSnapshot(forPath: "Firstname").value as! String
            self.lastName = snapshot.childSnapshot(forPath: "Lastname").value as! String
            
            self.fName.text = self.firstName
            self.lName.text = self.lastName
            
            LoadingIndicatorView.hide()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NavigationDrawer.instance.initialize(forViewController: self)
        
        }
    func reloadData(fName: String, lName: String){
//        self.listener = docRef.addSnapshotListener { (DocumentSnapshot, error) in
//            guard let DocumentSnapshot = DocumentSnapshot, DocumentSnapshot.exists else {return}
//            let MyData = DocumentSnapshot.data()
//            let fName = MyData?["fName"] as? String ?? ""
//            let lName = MyData?["lName"] as? String ?? ""
//
//            self.sendedData.text = "\(fName) \(lName)"
//        }
        
        let credential = ["Firstname" : fName , "Lastname" : lName]
        self.ref.child(appDelegate.uniqueID!).setValue(credential)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // listener.remove()
    }
    @IBAction func sendBtn(_ sender: Any) {
        
        guard let fNameText = fName.text, !fNameText.isEmpty else {return}
        guard let lNameText = lName.text, !lNameText.isEmpty else {return}
//        uName = userName.text!
//        docRef = Firestore.firestore().document("sampleData/\(userName.text!)")
//        let dataToSave: [String: Any] = ["fName": fNameText, "lName": lNameText]
//        docRef.setData(dataToSave) { (error) in
//            if error != nil {
//                print("Oh No, Error")
//            }else{
//                print("Data Saved Successfully")
//            }
//        }
        reloadData(fName: fNameText, lName: lNameText)
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        appDelegate.prefs.setValue("", forKey: "login_email")
        appDelegate.initializeViewController()
    }

}

