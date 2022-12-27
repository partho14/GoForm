//
//  AppDelegate.swift
//  GoForm
//
//  Created by Partha Pratim Das on 6/12/22.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

let appDelegate = UIApplication.shared.delegate as! AppDelegate

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
                
            } else {
                return vc;
            }
        }
    }
}


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var loginViewController: LoginViewController?
    var currentNav: UINavigationController?
    var navViewController: NavViewController?
    var loadingIndicatorView: LoadingIndicatorView?
    var mainViewController: MainViewController?
    var formBuilderViewController: FormBuilderViewController?
    var fullFormViewViewController: FullFormViewViewController?
    var formFillupViewController: FormFillupViewController?
    var navigationDrawer: NavigationDrawer?
    var email: String?
    var uniqueID: String?
    var formNameText: String?
    
    var formNameArray: [DataSnapshot] = []
    var storeFormName: String = ""
    var splitUrl: String = ""
    var uniqueId: String = ""
    var currentUserName: String = ""
    
    var urlForm: Int = 0
    
    let prefs = UserDefaults.standard

    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url)
        self.urlForm = 1
        if let scheme = url.scheme,
                scheme.localizedCaseInsensitiveCompare("com.goform") == .orderedSame,
                let view = url.host {
            let array = view.components(separatedBy: "=")
            self.splitUrl = array.last ?? ""
            print(self.splitUrl)
        }
        self.initializeViewController()
        return true
    }
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "366024794907-pvbd095jbl2ujnbdtp33jah1ta049087.apps.googleusercontent.com"

        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
                    if let name = Auth.auth().currentUser?.displayName {
                            prefs.setValue(name, forKey: "userName")
                        }
                    }
        initializeViewController()
        return true
    }
    
    func initializeViewController(){
        
        if GIDSignIn.sharedInstance().hasPreviousSignIn() {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
            appDelegate.currentUserName = (prefs.value(forKey: "userName") != nil) ? prefs.value(forKey: "userName") as! String : ""
            appDelegate.email = (prefs.value(forKey: "login_email") != nil) ? prefs.value(forKey: "login_email") as! String : ""
            appDelegate.uniqueID = (prefs.value(forKey: "uniqueID") != nil) ? prefs.value(forKey: "uniqueID") as! String : ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            
            let navCon = UINavigationController.init(rootViewController: loginVC!)
            navCon.navigationBar.isHidden = true
            navCon.toolbar.isHidden = true
            self.window?.rootViewController = navCon
            self.window?.makeKeyAndVisible()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController

            let navCon = UINavigationController.init(rootViewController: loginVC!)
            navCon.navigationBar.isHidden = true
            navCon.toolbar.isHidden = true
            self.window?.rootViewController = navCon
            self.window?.makeKeyAndVisible()
        }
        //self.window?.addSubview((self.loginViewController?.view)!)
       // self.window?.bringSubviewToFront((self.loginViewController?.view)!)
        //self.window?.makeKeyAndVisible()
        initializePopups()
        
    }
    
    func initializePopups(){
        
        if (formFillupViewController != nil){
            formFillupViewController?.view.removeFromSuperview()
        }
        
        var storyboard = UIStoryboard(name: "User", bundle: nil)
        formFillupViewController = storyboard.instantiateViewController (withIdentifier: "FormFillupViewController") as? FormFillupViewController
        formFillupViewController?.view.alpha = 0
        self.window?.addSubview((formFillupViewController?.view)!)
    }



}

