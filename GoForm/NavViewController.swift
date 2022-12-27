//
//  NavViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 7/12/22.
//

import UIKit
import GoogleSignIn

class NavViewController: UIViewController {
    
    var email: String?
    
    @IBOutlet var bigView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginCredentialView: UIView!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bigView.bounds.size.width = UIScreen.main.bounds.size.width * 1/8
        profileImageView.layer.cornerRadius = 25
        self.bigView.bounds.size.height = UIScreen.main.bounds.size.height
        //self.bigView.backgroundColor = UIColor.cyan
        self.userEmail.text = appDelegate.email
    }
    
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        appDelegate.prefs.setValue("", forKey: "login_email")
        appDelegate.prefs.setValue("", forKey: "userName")
        appDelegate.initializeViewController()
    }
    
    @IBAction func ServeyButton(_ sender: Any) {
        
        NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
        appDelegate.currentNav?.pushViewController(formFillupViewController!, animated: true)
        UIApplication.shared.keyWindow?.rootViewController?.present(formFillupViewController!, animated: true, completion: nil)
    }
    
    @IBAction func myServerListBtn(_ sender: Any) {
        NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let myServeyViewController = storyboard.instantiateViewController(withIdentifier: "MyServeyViewController") as? MyServeyViewController
        appDelegate.currentNav?.pushViewController(myServeyViewController!, animated: true)
        UIApplication.shared.keyWindow?.rootViewController?.present(myServeyViewController!, animated: true, completion: nil)
    }
    
    
    @IBAction func serveyListBtn(_ sender: Any) {
        NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let mainServeyListViewController = storyboard.instantiateViewController(withIdentifier: "MainServeyListViewController") as? MainServeyListViewController
        appDelegate.currentNav?.pushViewController(mainServeyListViewController!, animated: true)
        UIApplication.shared.keyWindow?.rootViewController?.present(mainServeyListViewController!, animated: true, completion: nil)
    }
    
    
}
