//
//  NavViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 7/12/22.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class NavViewController: UIViewController {
    
    var email: String?
    
    @IBOutlet var bigView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginCredentialView: UIView!
    @IBOutlet weak var userEmail: UILabel!
    
    
    @IBOutlet weak var profileView: UIView!{
        didSet{
            profileView.layer.cornerRadius = profileView.frame.size.height/2
        }
    }
    @IBOutlet weak var userName: UILabel!{
        didSet{
            self.userName.font = UIFont(name: "Barlow-Regular", size: 16.0)
            userName.numberOfLines = 1
            userName.sizeToFit()
            userName.adjustsFontSizeToFitWidth = true
            userName.textAlignment = .center
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var elementName = ["Take Servey", "My Submission", "Create Form", "Shared Form", "Log Out"]
    var elementImage = ["icon_myform","icon_mysubmission","icon_createform","icon_sharedform","icon_logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeFromParent()
        self.bigView?.bounds.size.width = UIScreen.main.bounds.size.width * 1/8
        profileImageView?.layer.cornerRadius = 25
        self.bigView?.bounds.size.height = UIScreen.main.bounds.size.height
        self.mainView?.bounds.size.width = UIScreen.main.bounds.size.width * 1/8
        self.mainView?.bounds.size.height = UIScreen.main.bounds.size.height
        //self.bigView.backgroundColor = UIColor.cyan
        self.userEmail?.text = appDelegate.email
        self.userName?.text = appDelegate.email
    }
    
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signOut()
        appDelegate.prefs.setValue("", forKey: "login_email")
        appDelegate.prefs.setValue("", forKey: "userName")
        appDelegate.initializeViewController()
    }
    
    @IBAction func ServeyButton(_ sender: Any) {
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
    
    
    @IBAction func fileUploadDemo(_ sender: Any) {
        NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fileUploadDemoViewController = storyboard.instantiateViewController(withIdentifier: "FileUploadDemoViewController") as? FileUploadDemoViewController
        appDelegate.currentNav?.pushViewController(fileUploadDemoViewController!, animated: true)
        UIApplication.shared.keyWindow?.rootViewController?.present(fileUploadDemoViewController!, animated: true, completion: nil)
    }
    
    
}


extension NavViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: self.view.frame.size.width/3.75, height: self.view.frame.size.width/3.75)
        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width * 1/15, bottom: 0, right: UIScreen.main.bounds.size.width * 1/15)
//        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NavViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NavViewCollectionViewCell", for: indexPath) as! NavViewCollectionViewCell
        
        cell.cellTittle.text = elementName[indexPath.row]
        cell.cellIcon.image = UIImage(named:"\(elementImage[indexPath.row])")
        cell.cellTittle.font = UIFont(name: "Barlow-Bold", size: 12.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            appDelegate.isFormFillupView = true
            NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
            let storyboard = UIStoryboard(name: "Form", bundle: nil)
            let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
            appDelegate.window?.visibleViewController()?.navigationController?.pushViewController(formFillupViewController!, animated: true)
            //UIApplication.shared.keyWindow?.rootViewController?.present(formFillupViewController!, animated: true, completion: nil)
        }
        else if indexPath.row == 1{
            NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
            let storyboard = UIStoryboard(name: "User", bundle: nil)
            let myServeyViewController = storyboard.instantiateViewController(withIdentifier: "MyServeyViewController") as? MyServeyViewController
            appDelegate.window?.visibleViewController()?.navigationController?.pushViewController(myServeyViewController!, animated: true)
            //UIApplication.shared.keyWindow?.rootViewController?.present(myServeyViewController!, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
            appDelegate.window?.visibleViewController()?.navigationController?.pushViewController(formBuilderViewController!, animated: true)
            //UIApplication.shared.keyWindow?.rootViewController?.present(formBuilderViewController!, animated: true, completion: nil)
        }
        else if indexPath.row == 3{
            NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
            let storyboard = UIStoryboard(name: "Shared", bundle: nil)
            let sharedFormViewController = storyboard.instantiateViewController(withIdentifier: "SharedFormViewController") as? SharedFormViewController
            appDelegate.window?.visibleViewController()?.navigationController?.pushViewController(sharedFormViewController!, animated: true)
        }
        else if indexPath.row == 4{
            GIDSignIn.sharedInstance().signOut()
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                appDelegate.prefs.setValue("", forKey: "AppleSignIn")
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
            appDelegate.prefs.setValue("", forKey: "login_email")
            appDelegate.prefs.setValue("", forKey: "userName")
            appDelegate.initializeViewController()
        
        }
        else{
            
        }
    }
    
    
}
