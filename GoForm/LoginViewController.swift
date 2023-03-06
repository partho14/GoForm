//
//  LoginViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 6/12/22.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextLbl: UILabel!{
        didSet{
            loginTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            loginTextLbl.numberOfLines = 1
            loginTextLbl.adjustsFontSizeToFitWidth = true
            //loginTextLbl.sizeToFit()
            loginTextLbl.textAlignment = .center
        }
    }
    
    @IBOutlet weak var gmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTextFieldview: UIView!{
        didSet{
            passwordTextFieldview.layer.borderWidth = 1
            passwordTextFieldview.layer.cornerRadius = 10
            passwordTextFieldview.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var gmailTextFieldView: UIView!{
        didSet{
            gmailTextFieldView.layer.borderWidth = 1
            gmailTextFieldView.layer.cornerRadius = 10
            gmailTextFieldView.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var loginBtnView: UIView!{
        didSet{
            loginBtnView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var orTextView: UIView!{
        didSet{
            orTextView.layer.borderWidth = 1
            orTextView.layer.borderColor = UIColor(red: 245/255, green: 234/255, blue: 232/255, alpha: 1).cgColor
            orTextView.layer.cornerRadius = orTextView.frame.size.height/2
            
            
        }
    }
    @IBOutlet weak var loginCredientialBorderView: UIView!{
        didSet{
            loginCredientialBorderView.layer.borderWidth = 1
            loginCredientialBorderView.layer.borderColor = UIColor(red: 251/255, green: 182/255, blue: 161/255, alpha: 1).cgColor
            loginCredientialBorderView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var facebookBorderView: UIView!{
        didSet{
            facebookBorderView.layer.borderWidth = 1
            facebookBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            facebookBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var emailBorderView: UIView!{
        didSet{
            emailBorderView.layer.borderWidth = 1
            emailBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            emailBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var googleBorderView: UIView!{
        didSet{
            googleBorderView.layer.borderWidth = 1
            googleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            googleBorderView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var forgotPasswordTextLbl: UILabel!{
        didSet{
            forgotPasswordTextLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
            forgotPasswordTextLbl.numberOfLines = 1
            //forgotPasswordTextLbl.sizeToFit()
            //forgotPasswordTextLbl.adjustsFontSizeToFitWidth = true
            forgotPasswordTextLbl.textAlignment = .left
        }
    }
    @IBOutlet weak var loginBtnTextLbl: UILabel!{
        didSet{
            loginBtnTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            loginBtnTextLbl.numberOfLines = 1
            //loginBtnTextLbl.sizeToFit()
            //loginBtnTextLbl.adjustsFontSizeToFitWidth = true
            loginBtnTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var createAccountTextLbl: UILabel!{
        didSet{
            createAccountTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            createAccountTextLbl.numberOfLines = 1
            //createAccountTextLbl.sizeToFit()
            //createAccountTextLbl.adjustsFontSizeToFitWidth = true
            createAccountTextLbl.textAlignment = .right
        }
    }
    @IBOutlet weak var signInWithTextLbl: UILabel!{
        didSet{
            signInWithTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            signInWithTextLbl.numberOfLines = 1
            //signInWithTextLbl.sizeToFit()
            //signInWithTextLbl.adjustsFontSizeToFitWidth = true
            signInWithTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var orTextLbl: UILabel!{
        didSet{
            orTextLbl.font = UIFont(name: "Barlow-Bold", size: 18.0)
            orTextLbl.numberOfLines = 1
            //orTextLbl.sizeToFit()
            //orTextLbl.adjustsFontSizeToFitWidth = true
            orTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var googleTextLbl: UILabel!{
        didSet{
            googleTextLbl.font = UIFont(name: "Barlow-Regular", size: 16.0)
            googleTextLbl.numberOfLines = 1
            //googleTextLbl.sizeToFit()
            googleTextLbl.adjustsFontSizeToFitWidth = true
            googleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var facebookTextLbl: UILabel!{
        didSet{
            facebookTextLbl.font = UIFont(name: "Barlow-Regular", size: 16.0)
            facebookTextLbl.numberOfLines = 1
            //facebookTextLbl.sizeToFit()
            facebookTextLbl.adjustsFontSizeToFitWidth = true
            facebookTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var emailTextLbl: UILabel!{
        didSet{
            emailTextLbl.font = UIFont(name: "Barlow-Regular", size: 16.0)
            emailTextLbl.numberOfLines = 1
            //emailTextLbl.sizeToFit()
            emailTextLbl.adjustsFontSizeToFitWidth = true
            emailTextLbl.textAlignment = .center
        }
    }
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gmailTextField.delegate = self
        passwordTextField.delegate = self
        loginTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        loginTextLbl.numberOfLines = 1
        loginTextLbl.adjustsFontSizeToFitWidth = true
        loginTextLbl.sizeToFit()
        loginTextLbl.textAlignment = .center
        self.ref = Database.database().reference()
//        if (self.view.frame.width == 320) {
//
//            loginTextLbl.font = UIFont(name: loginTextLbl.font.fontName, size: 16)
//
//        } else if (self.view.frame.width == 375) {
//
//            loginTextLbl.font = UIFont(name: loginTextLbl.font.fontName, size: 20)
//
//        } else if (self.view.frame.width == 414) {
//
//            loginTextLbl.font = UIFont(name: loginTextLbl.font.fontName, size: 20)
//
//        }else if (self.view.frame.width == 430) {
//
//            loginTextLbl.font = UIFont(name: loginTextLbl.font.fontName, size: 22)
//
//        }
        
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
        
        guard let gmailText = gmailTextField.text, !gmailText.isEmpty else {return}
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {return}
        docRef = Firestore.firestore().document("loginCradiential/\(gmailTextField.text!)")
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
    
    
    @IBAction func googleLoginBtnPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookLoginBtnPressed(_ sender: Any) {
    }
    
    @IBAction func emailLoginBtnPressed(_ sender: Any) {
        let nonce = randomNonceString()
                currentNonce = nonce
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
    }
    
    @IBAction func createAccountBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(signUpViewController!, animated: true)
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgorPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgorPasswordViewController") as? ForgorPasswordViewController
        self.navigationController?.pushViewController(forgorPasswordViewController!, animated: true)

    }
    
    func saveToDatabase(value: String){
        
//        let credential = ["Uuid" : value]
//        self.ref.child(value).setValue(credential)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
}

extension LoginViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil{
            guard let idToken = user.authentication.idToken else {return}
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            appDelegate.prefs.setValue(user.profile.email, forKey: "login_email")
            if Auth.auth().currentUser != nil {
                        if let name = Auth.auth().currentUser?.displayName {
                            appDelegate.prefs.setValue(name, forKey: "userName")
                            }
                        }
            Auth.auth().signIn(with: credentials, completion: { user, error in
                if let err = error {
                    print("Failed")
                    return
                }
                appDelegate.prefs.setValue(user?.user.uid, forKey: "uniqueID")
                print(user?.credential)
                
                appDelegate.initializeViewController()
            })
        }
    }
    
    /**
         * Called when 'return' key pressed. return NO to ignore.
         */
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }


       /**
        * Called when the user click on the view (outside the UITextField).
        */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { [self] (authResult, error) in
                if Auth.auth().currentUser != nil {
                            if let name = Auth.auth().currentUser?.displayName {
                                appDelegate.prefs.setValue(name, forKey: "userName")
                                appDelegate.prefs.setValue("Yes", forKey: "AppleSignIn")
                            }
                }else{
                    appDelegate.prefs.setValue("Null", forKey: "userName")
                    appDelegate.prefs.setValue("Yes", forKey: "AppleSignIn")
                }
                if let err = error {
                    print("Failed")
                    return
                }
                
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                appDelegate.prefs.setValue(email, forKey: "login_email")
                appDelegate.prefs.setValue(Auth.auth().currentUser?.uid, forKey: "uniqueID")
                if let name = Auth.auth().currentUser?.displayName {
                    appDelegate.prefs.setValue(name, forKey: "userName")
                    appDelegate.prefs.setValue("Yes", forKey: "AppleSignIn")
                }else{
                    appDelegate.prefs.setValue("Null", forKey: "userName")
                    appDelegate.prefs.setValue("Yes", forKey: "AppleSignIn")
                }
                appDelegate.initializeViewController()
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                db.collection("User").document(uid).setData([
                    "email": email,
                    "displayName": displayName,
                    "uid": uid
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("the user has sign up or is logged in")
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
