//
//  MainViewController.swift
//  GoForm
//
//  Created by Partha Pratim Das on 8/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class MainViewController: UIViewController {

    @IBOutlet weak var addVIEW: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerAddBtn: UIButton!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var successUrlText: UILabel!
    
    var fullFormViewViewController: FullFormViewViewController?
    var navigationDrawer:NavigationDrawer!
    var retrievedEvent: [String] = []
    
    var questionArray: [DataSnapshot] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var totalForm: Int = 0
    var shareUrl: String = ""
    var exectURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
                    if let name = Auth.auth().currentUser?.displayName {
                        appDelegate.prefs.setValue(name, forKey: "userName")
                        }
                    }
        if appDelegate.urlForm == 1 {
            self.handleDeepLink()
        }
        questionArray.removeAll()
        self.popView.alpha = 0
        self.successView.alpha = 0
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        
        let options = NavigationDrawerOptions()
        options.navigationDrawerType = .leftDrawer
        options.navigationDrawerOpenDirection = .anyWhere
        options.navigationDrawerYPosition = 0
        options.navigationDrawerAnchorController = .window
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
        navigationDrawer = NavigationDrawer.instance
        navigationDrawer.setup(withOptions: options)
        navigationDrawer.setNavigationDrawerController(viewController: vc)
        NavigationDrawer.instance.initialize(forViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NavigationDrawer.instance.initialize(forViewController: self)
        DispatchQueue.main.async {
            self.getData()
            //self.getData2()
        }
    }
    
    func getData(){
        questionArray.removeAll()
        self.ref.child("\(appDelegate.uniqueID!)/Form").queryOrderedByKey().observe(.value){ (snapshot) in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {

                self.questionArray.append(event as! DataSnapshot)
            }
            if(self.questionArray.count == 0){
                
                self.headerAddBtn.alpha = 0
                self.addVIEW.layer.cornerRadius = 25
                self.scrollView.alpha = 0
                self.addVIEW.alpha = 1
            }else{
                
                self.headerAddBtn.alpha = 1
                self.addVIEW.layer.cornerRadius = 25
                self.scrollView.alpha = 1
                self.addVIEW.alpha = 0
            }
            self.tableView.reloadData()
            appDelegate.formNameArray = self.questionArray
            LoadingIndicatorView.hide()
        }
        
    }
    
    func getData2(){
//        self.ref.queryOrderedByKey().observe(.value){ (snapshot) in
//            for event in snapshot.children{
//                for i in event{
//                    print(i)
//                }
//            }
//        }
    }
    
    @IBAction func successOkBtn(_ sender: Any) {
        self.successView.alpha = 0
        UIPasteboard.general.string = self.shareUrl
        self.exectURL = URL(string: "\(self.shareUrl)")
        print(self.exectURL ?? "")
    }
    

    @IBAction func emptyViewAddBtn(_ sender: Any) {
        
        self.popView.alpha = 1
    }
    
    @IBAction func headerAddButton(_ sender: Any) {
        
        self.popView.alpha = 1
    }
    
    @IBAction func sideMenuOpenBtn(_ sender: Any) {
        NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
    }
    
    
    @IBAction func serveyViewBtn(_ sender: Any) {
        self.popView.alpha = 0
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
        self.navigationController?.pushViewController(formFillupViewController!, animated: true)
    }
    @IBAction func newFormAddBtn(_ sender: Any) {
        self.popView.alpha = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
        self.navigationController?.pushViewController(formBuilderViewController!, animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.popView.alpha = 0
    }
    
    func handleDeepLink(){
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let formFillupViewController = storyboard.instantiateViewController(withIdentifier: "FormFillupViewController") as? FormFillupViewController
        self.navigationController?.pushViewController(formFillupViewController!, animated: true)
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainViewTableViewCell", for: indexPath) as! MainViewTableViewCell
        if questionArray.count > 0 {
            cell.shareBtn.tag = indexPath.row + 1
            cell.didShare = { [weak self] tag in
                self?.shareUrl = "com.goform://id=\(appDelegate.uniqueID!)\(self!.questionArray[indexPath.row].key)"
                self?.successView.alpha = 0
                
                self!.exectURL = URL(string: "\(self!.shareUrl)")
                let sharedObjects:[AnyObject] = [self!.exectURL as AnyObject]
                print(sharedObjects)
                let activityViewController = UIActivityViewController(activityItems: sharedObjects , applicationActivities: nil)
                activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook, .postToTwitter, .mail]
                activityViewController.isModalInPresentation = true
                activityViewController.popoverPresentationController?.sourceView = UIView()
                self?.present(activityViewController, animated: true, completion: nil)
                //self?.successUrlText.text = self?.shareUrl

            }
            cell.formName.text = self.questionArray[indexPath.row].key
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fullFormViewViewController = storyboard.instantiateViewController(withIdentifier: "FullFormViewViewController") as? FullFormViewViewController
        self.navigationController?.pushViewController(fullFormViewViewController!, animated: true)
        appDelegate.formNameText = self.questionArray[indexPath.row].key
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
          let path: String = "\(appDelegate.uniqueID!)/\("Form")/\(questionArray[indexPath.row].key)"
          let path2: String = "\(appDelegate.uniqueID!)\(questionArray[indexPath.row].key)"
          self.ref.child(path).removeValue()
          self.ref.child(path2).removeValue()
          self.getData()
      }
    }
    
}
