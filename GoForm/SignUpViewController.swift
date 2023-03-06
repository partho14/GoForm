//
//  SignUpViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 27/1/23.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var container: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpTextLbl: UILabel!{
        didSet{
            signUpTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            signUpTextLbl.numberOfLines = 1
            signUpTextLbl.adjustsFontSizeToFitWidth = true
            //loginTextLbl.sizeToFit()
            signUpTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var loginTextLbl: UILabel!{
        didSet{
            loginTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            loginTextLbl.numberOfLines = 1
            loginTextLbl.textAlignment = .right
        }
    }
    @IBOutlet weak var facebookTextLbl: UILabel!{
        didSet{
            facebookTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            facebookTextLbl.numberOfLines = 1
            facebookTextLbl.adjustsFontSizeToFitWidth = true
            facebookTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var googleTextLbl: UILabel!{
        didSet{
            googleTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            googleTextLbl.numberOfLines = 1
            googleTextLbl.adjustsFontSizeToFitWidth = true
            googleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var emailTextLbl: UILabel!{
        didSet{
            emailTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            emailTextLbl.numberOfLines = 1
            emailTextLbl.adjustsFontSizeToFitWidth = true
            emailTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var orTextLbl: UILabel!{
        didSet{
            orTextLbl.font = UIFont(name: "Barlow-Bold", size: 18.0)
            orTextLbl.numberOfLines = 1
            orTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var termsAndConditionTextLbl: UILabel!{
        didSet{
            termsAndConditionTextLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
            termsAndConditionTextLbl.numberOfLines = 1
            termsAndConditionTextLbl.textAlignment = .left
        }
    }
    @IBOutlet weak var signupBtnTextLbl: UILabel!{
        didSet{
            signupBtnTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            signupBtnTextLbl.numberOfLines = 1
            signupBtnTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var signupWithTextLbl: UILabel!{
        didSet{
            signupWithTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            signupWithTextLbl.numberOfLines = 1
            
            signupWithTextLbl.textAlignment = .center
        }
    }
    
    
    @IBOutlet weak var signUpCredintialBorderView: UIView!{
        didSet{
            signUpCredintialBorderView.layer.borderWidth = 1
            signUpCredintialBorderView.layer.borderColor = UIColor(red: 251/255, green: 182/255, blue: 161/255, alpha: 1).cgColor
            signUpCredintialBorderView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var orTextView: UIView!{
        didSet{
            orTextView.layer.borderWidth = 1
            orTextView.layer.borderColor = UIColor(red: 245/255, green: 234/255, blue: 232/255, alpha: 1).cgColor
            orTextView.layer.cornerRadius = orTextView.frame.size.height/2
            
            
        }
    }
    @IBOutlet weak var facebookView: UIView!{
        didSet{
            facebookView.layer.borderWidth = 1
            facebookView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            facebookView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var emailView: UIView!{
        didSet{
            emailView.layer.borderWidth = 1
            emailView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            emailView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var googleView: UIView!{
        didSet{
            googleView.layer.borderWidth = 1
            googleView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            googleView.layer.cornerRadius = 10
            
        }
    }
    
    
    
    @IBOutlet weak var confirmTextFieldView: UIView!{
        didSet{
            confirmTextFieldView.layer.borderWidth = 1
            confirmTextFieldView.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
            confirmTextFieldView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var passwordTextFieldView: UIView!{
        didSet{
            passwordTextFieldView.layer.borderWidth = 1
            passwordTextFieldView.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
            passwordTextFieldView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var emailTextFieldView: UIView!{
        didSet{
            emailTextFieldView.layer.borderWidth = 1
            emailTextFieldView.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
            emailTextFieldView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var nameTextFieldView: UIView!{
        didSet{
            nameTextFieldView.layer.borderWidth = 1
            nameTextFieldView.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
            nameTextFieldView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var signUpBtnView: UIView!{
        didSet{
            signUpBtnView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var checkBoxView: UIView!{
        didSet{
            checkBoxView.layer.borderWidth = 1
            checkBoxView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            checkBoxView.layer.cornerRadius = 5
            
        }
    }
    @IBOutlet weak var termsCheckImage: UIImageView!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var termsCheck = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termsCheckImage.image = UIImage(named:"")
        self.container.frame.size.width = self.view.frame.size.width
        self.container.frame.size.height = 839
        self.view.addSubview(scrollView)
//        self.scrollView.frame.size.width = self.view.frame.size.width
//        self.scrollView.frame.size.height = self.view.frame.size.height
        self.scrollView.addSubview(container)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: container.frame.size.height)
        signUpTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        signUpTextLbl.numberOfLines = 1
        signUpTextLbl.sizeToFit()
        signUpTextLbl.adjustsFontSizeToFitWidth = true
        signUpTextLbl.textAlignment = .center
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func textFieldDidEndEditing(textField: UITextField) -> Bool
    {
        userNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsAndConditionBtnPressed(_ sender: Any) {
        if termsCheck == 0{
            termsCheck = 1
            self.termsCheckImage.image = UIImage(named:"icon_ok")
            
        }else{
            termsCheck = 0
            self.termsCheckImage.image = UIImage(named:"")
            
        }
    }
    
    /**
         * Called when 'return' key pressed. return NO to ignore.
         */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
