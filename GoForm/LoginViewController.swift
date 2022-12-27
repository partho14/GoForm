//
//  LoginViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 6/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    
    @IBOutlet weak var gmail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        googleLogIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        }
    func reloadData(){
        self.listener = docRef.addSnapshotListener { (DocumentSnapshot, error) in
            guard let DocumentSnapshot = DocumentSnapshot, DocumentSnapshot.exists else {return}
            let MyData = DocumentSnapshot.data()
            let gmail = MyData?["fName"] as? String ?? ""
            let password = MyData?["lName"] as? String ?? ""
        }
    }
    
    func googleLogIn(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //listener.remove()
    }

    @IBAction func loginBtn(_ sender: Any) {
        
        guard let gmailText = gmail.text, !gmailText.isEmpty else {return}
        guard let passwordText = password.text, !passwordText.isEmpty else {return}
        docRef = Firestore.firestore().document("loginCradiential/\(gmail.text!)")
        let dataToSave: [String: Any] = ["gmail": gmailText, "password": passwordText]
        docRef.setData(dataToSave) { (error) in
            if error != nil {
                print("Oh No, Error")
            }else{
                print("Data Saved Successfully")
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeViewController!, animated: true)
    }
    
    
    @IBAction func googleLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func saveToDatabase(value: String){
        
//        let credential = ["Uuid" : value]
//        self.ref.child(value).setValue(credential)
    }
    
}

extension LoginViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        print(idToken)
        saveToDatabase(value: user.userID)
        appDelegate.prefs.setValue(user.userID, forKey: "uniqueID")
        appDelegate.prefs.setValue(user.profile.email, forKey: "login_email")
        Auth.auth().signIn(with: credentials, completion: { user, error in
            if let err = error {
                print("Failed")
                return
            }
            
            print(user?.credential)
            
            appDelegate.initializeViewController()
        })
    }
    
    
}
