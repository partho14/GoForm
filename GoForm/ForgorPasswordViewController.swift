//
//  ForgorPasswordViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 30/1/23.
//

import UIKit

class ForgorPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextFieldBorderView: UIView!{
        didSet{
            emailTextFieldBorderView.layer.borderWidth = 1
            emailTextFieldBorderView.layer.borderColor = UIColor(red: 251/255, green: 182/255, blue: 161/255, alpha: 1).cgColor
            emailTextFieldBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var emailTextFieldView: UIView!{
        didSet{
            emailTextFieldView.layer.borderWidth = 1
            emailTextFieldView.layer.cornerRadius = 10
            emailTextFieldView.layer.borderColor = UIColor(red: 252/255, green: 203/255, blue: 188/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var forgorPasswordBtnView: UIView!{
        didSet{
            forgorPasswordBtnView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var forgotPasswordTextLbl: UILabel!{
        didSet{
            forgotPasswordTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            forgotPasswordTextLbl.numberOfLines = 1
            forgotPasswordTextLbl.sizeToFit()
            forgotPasswordTextLbl.adjustsFontSizeToFitWidth = true
            forgotPasswordTextLbl.textAlignment = .center
        }
    }
    
    @IBOutlet weak var forgotPasswordBtnTextLbl: UILabel!{
        didSet{
            forgotPasswordBtnTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            forgotPasswordBtnTextLbl.numberOfLines = 1
            forgotPasswordBtnTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var loginTextLbl: UILabel!{
        didSet{
            loginTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            loginTextLbl.numberOfLines = 1
            loginTextLbl.textAlignment = .right
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        forgotPasswordTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        forgotPasswordTextLbl.numberOfLines = 1
        forgotPasswordTextLbl.sizeToFit()
        forgotPasswordTextLbl.adjustsFontSizeToFitWidth = true
        forgotPasswordTextLbl.textAlignment = .center
        // Do any additional setup after loading the view.
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
