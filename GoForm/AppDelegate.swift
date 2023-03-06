//
//  AppDelegate.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 6/12/22.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import DropDown

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
    let myDatePicker: MyDatePicker = MyDatePicker()
    var loginViewController: LoginViewController?
    var currentNav: UINavigationController?
    var navViewController: NavViewController?
    var loadingIndicatorView: LoadingIndicatorView?
    var mainViewController: MainViewController?
    var formBuilderViewController: FormBuilderViewController?
    var navigationDrawer: NavigationDrawer?
    var navigationDrawerOption: NavigationDrawerOptions?
    var drawerViewController: NavViewController?
    var drawerController: KYDrawerController?
    var email: String?
    var uniqueID: String?
    var formNameText: String?
    var pdfFileUrl: String?
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    
    var formNameArray: [DataSnapshot] = []
    var sharedFormArray: [DataSnapshot] = []
    var allGmailArray: [DataSnapshot] = []
    var storeFormName: String = ""
    var splitUrl: String = ""
    var uniqueId: String = ""
    var currentUserName: String = ""
    var sharedPeopleViewFormName: String = ""
    var myFormPdfShowID: String = ""
    var peopleServeyScreenFormName: String = ""
    var peopleServeyScreenView: Bool = false
    var peoplwServeyUniqueId : String = ""
    var sharedFormTotalView: Bool = false
    var appleSignIn : String = ""
    
    var urlForm: Int = 0
    var check: Int = 0
    var verifiedEmail: String = ""
    let prefs = UserDefaults.standard
    
    var isShared: Bool = false
    var isSharedSubServey: Bool = false
    var isSharedSubServeyDetails: Bool = false
    
    var combineArray = [[String:Any]]()
    
    //for Form servey question store
    var formQuestionArray : [String] = []
    var formNameStore: String = ""
    
    var sharedFormUniqueId: String = ""
    var shared: Bool = false
    var isFullFormView: Bool = false
    var isSharedFormView: Bool = false
    var isFormFillupView: Bool = false
    var isFillupFormViewingView: Bool = false
    var isFillupFormViewingFormName: String?
    
    var sharedUniqueId: String = ""
    var pdfOpenFromServeyList: Bool = false
    
    var formBuilderSingleChoice: [String] = []
    var formBuilderMultipleChoice: [String] = []
    var singleChoiceAnsIndex = 0
    var multipleChoiceStoreIndex: [Int] = []

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
        DropDown.startListeningToKeyboard()
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "366024794907-pvbd095jbl2ujnbdtp33jah1ta049087.apps.googleusercontent.com"
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        _ = Firestore.firestore()
        if Auth.auth().currentUser != nil {
                    if let name = Auth.auth().currentUser?.displayName {
                            prefs.setValue(name, forKey: "userName")
                        }
                    }
        //getAndStoreAllGmail()
        initializeViewController()
        return true
    }
    
    func getAndStoreAllGmail(){
        self.check = 0
        self.verifiedEmail = (Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "%"))!
        LoadingIndicatorView.show()
        allGmailArray.removeAll()
        self.ref.child("AllUsers").queryOrderedByKey().observe(.value){ (snapshot) in
            self.allGmailArray.removeAll()
            for event in snapshot.children.allObjects {

                self.allGmailArray.append(event as! DataSnapshot)
            }
            print(self.allGmailArray)
            
            if self.allGmailArray.count > 0{
                for i in 0 ..< self.allGmailArray.count{
                    if (self.allGmailArray[i].key == self.verifiedEmail){
                        self.check = 1
                    }
                }
            }
            if self.check == 0 {
                self.ref.child("AllUsers").child(self.verifiedEmail).setValue(appDelegate.uniqueID)
                self.ref.child("UserDetails").child(self.uniqueID!).child("UniqueName").setValue(self.currentUserName)
            }
        }
    }
    
    func initializeViewController(){
        
        appDelegate.appleSignIn = (prefs.value(forKey: "AppleSignIn") != nil) ? prefs.value(forKey: "AppleSignIn") as! String : ""
        
        print(appDelegate.appleSignIn)
        if GIDSignIn.sharedInstance().hasPreviousSignIn(){
            GIDSignIn.sharedInstance().restorePreviousSignIn()
            appDelegate.currentUserName = (prefs.value(forKey: "userName") != nil) ? prefs.value(forKey: "userName") as! String : ""
            appDelegate.email = (prefs.value(forKey: "login_email") != nil) ? prefs.value(forKey: "login_email") as! String : ""
            appDelegate.uniqueID = (prefs.value(forKey: "uniqueID") != nil) ? prefs.value(forKey: "uniqueID") as! String : ""
            getAndStoreAllGmail()
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        
            let navCon = UINavigationController.init(rootViewController: loginVC!)
            navCon.navigationBar.isHidden = true
            navCon.toolbar.isHidden = true
            self.window?.rootViewController = navCon
            self.window?.makeKeyAndVisible()
            
        }else if(appDelegate.appleSignIn == "Yes"){
            appDelegate.currentUserName = (prefs.value(forKey: "userName") != nil) ? prefs.value(forKey: "userName") as! String : ""
            appDelegate.email = (prefs.value(forKey: "login_email") != nil) ? prefs.value(forKey: "login_email") as! String : ""
            appDelegate.uniqueID = (prefs.value(forKey: "uniqueID") != nil) ? prefs.value(forKey: "uniqueID") as! String : ""
            getAndStoreAllGmail()
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController

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
    }
    
    func initializeHomeView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        self.window?.addSubview((self.mainViewController?.view)!)
        self.window?.bringSubviewToFront((self.mainViewController?.view)!)
    }


}

