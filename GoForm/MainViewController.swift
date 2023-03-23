//
//  MainViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 8/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var tittleFont: UILabel!{
        didSet{
            tittleFont.font = UIFont(name: "Barlow-Bold", size: 20)

        }
    }
    
    
    

    @IBOutlet weak var addVIEW: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerAddBtn: UIButton!
    @IBOutlet weak var hraderAppTittleName: UILabel!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var createItemView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var headerAddLblName: UILabel!{
        didSet{
            self.headerAddLblName.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    @IBOutlet weak var headerCreateItemLbl: UILabel!{
        didSet{
            self.headerCreateItemLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    
    @IBOutlet weak var appTitle: UILabel!{
        didSet{
            self.appTitle.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    @IBOutlet weak var noItemAddedTextLbl: UILabel!{
        didSet{
            noItemAddedTextLbl.font = UIFont(name: "Barlow-Medium", size: 24.0)
            noItemAddedTextLbl.numberOfLines = 1
            noItemAddedTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var addItemBtnTextLbl: UILabel!{
        didSet{
            addItemBtnTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
            addItemBtnTextLbl.numberOfLines = 1
            addItemBtnTextLbl.sizeToFit()
            addItemBtnTextLbl.adjustsFontSizeToFitWidth = true
            addItemBtnTextLbl.textAlignment = .left
        }
    }
    
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var shareTittleTextLbl: UILabel!{
        didSet{
            self.shareTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var gmailAddTextField: UITextField!
    @IBOutlet weak var emailNotFoundErrorMsg: UILabel!{
        didSet{
            self.emailNotFoundErrorMsg.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    @IBOutlet weak var formAddButtonView: UIView!{
        didSet{
            formAddButtonView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var emailTittleLbl: UILabel!{
        didSet{
            self.emailTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            emailTittleLbl.numberOfLines = 1
            emailTittleLbl.sizeToFit()
            emailTittleLbl.adjustsFontSizeToFitWidth = true
            emailTittleLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var shareUniqueCodeTittleLbl: UILabel!{
        didSet{
            self.shareUniqueCodeTittleLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    @IBOutlet weak var shareUrlTittleLbl: UILabel!{
        didSet{
            self.shareUrlTittleLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    
    
    @IBOutlet weak var searchBtnView: UIView!
    
    @IBOutlet weak var emailTextFieldView: UIView!{
        didSet{
            emailTextFieldView.layer.borderWidth = 1
            emailTextFieldView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            emailTextFieldView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var emailTextFieldBorderView: UIView!{
        didSet{
            emailTextFieldBorderView.layer.borderWidth = 1
            emailTextFieldBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            emailTextFieldBorderView.layer.cornerRadius = 10
            
        }
    }

    @IBOutlet weak var emailAddConfirmBtn: UIView!
    @IBOutlet weak var shareOptionView: UIView!
    @IBOutlet weak var shareUniqueCodeView: UIView!{
        didSet{
            shareUniqueCodeView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var shareUrlView: UIView!{
        didSet{
            shareUrlView.layer.cornerRadius = 10
        }
    }
    
    
    // Form code generate field
    @IBOutlet weak var formCodeCreateView: UIView!{
        didSet{
            formCodeCreateView.layer.shadowColor = UIColor.black.cgColor
            formCodeCreateView.layer.shadowOpacity = 1
            formCodeCreateView.layer.shadowOffset = .zero
            formCodeCreateView.layer.shadowRadius = 10
                //formCodeCreateView.layer.shadowPath = UIBezierPath(rect: formCodeCreateView.bounds).cgPath
            formCodeCreateView.layer.shouldRasterize = true
            formCodeCreateView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    @IBOutlet weak var formCodeShowView: UIView!{
        didSet{
            formCodeShowView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formCodeCreateSubView: UIView!{
        didSet{
            formCodeCreateSubView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var formCodeTextField: UITextField!
    @IBOutlet weak var formCodeTextFieldView: UIView!{
        didSet{
            formCodeTextFieldView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var showingCodeTextLbl: UILabel!
    @IBOutlet weak var formCodeCreateErrorTextLbl: UILabel!
    
    
    var navigationDrawer:NavigationDrawer!
    var retrievedEvent: [String] = []
    var sharedObjects:[AnyObject] = []
    var show: Bool = false
    var mainPageData:[NSDictionary] = [NSDictionary]()
    var publishedDateArray: [DataSnapshot] = []
    var startingDateArray: [DataSnapshot] = []
    var serveyCount: [DataSnapshot] = []
    var questionArray: [DataSnapshot] = []
    var sharedFormArray: [DataSnapshot] = []
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var totalForm: Int = 0
    var shareUrl: String = ""
    var exectURL: URL!
    var check: Int = 0
    var verifiedEmail: String = ""
    var allGmailArray: [DataSnapshot] = []
    var sharedUniqueId: String = ""
    var sharedFormName: String = ""
    var sharingFormName: String = ""
    var singleFormName: String = ""
    var sharedGmailArray: [DataSnapshot] = []
    var totalServeyArray: [String] = []
    var allFormUniqueCodeArray: [DataSnapshot] = []
    var allFormUniqueCode: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [self]
        self.shareOptionView.alpha = 0
        self.formCodeCreateView.alpha = 0
        self.shareView.frame.size.height = self.view.frame.size.height
        self.shareView.frame.size.width = self.view.frame.size.width
        self.view.addSubview(shareView)
        Database.database().reference().removeAllObservers()
        questionArray.removeAll()
        sharedFormArray.removeAll()
        emailNotFoundErrorMsg.alpha = 0
        self.shareView.alpha = 0
        self.createItemView.alpha = 0
        self.addItemView.alpha = 0
        self.searchView.alpha = 0
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        let options = NavigationDrawerOptions()
        options.navigationDrawerType = .leftDrawer
        options.navigationDrawerOpenDirection = .anyWhere
        options.navigationDrawerYPosition = 0
        options.navigationDrawerAnchorController = .window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
        navigationDrawer = NavigationDrawer.instance
        navigationDrawer.setup(withOptions: options)
        navigationDrawer.setNavigationDrawerController(viewController: vc)
        NavigationDrawer.instance.initialize(forViewController: (appDelegate.window?.visibleViewController())!)
        self.emailAddConfirmBtn!.roundCorners([.topLeft, .topRight], radius: 20.0)
        self.shareOptionView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        let tapGesture = UITapGestureRecognizer(target: self,
                                 action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicatorView.show()
        self.show = false
        appDelegate.shared = false
        appDelegate.isFullFormView = false
        appDelegate.sharedFormTotalView = false
        appDelegate.peopleServeyScreenView = false
        
        DispatchQueue.main.async {
            self.totalServeyArray.removeAll()
            self.questionArray.removeAll()
            self.publishedDateArray.removeAll()
            self.startingDateArray.removeAll()
            self.getData()
            //self.getData2()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.totalServeyArray.removeAll()
        self.questionArray.removeAll()
        self.publishedDateArray.removeAll()
        self.startingDateArray.removeAll()
    }
    
    
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    func getData(){
        self.show = false
        totalServeyArray.removeAll()
        questionArray.removeAll()
        publishedDateArray.removeAll()
        startingDateArray.removeAll()
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Form").queryOrderedByKey().observe(.value){ snapshot in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {

                self.questionArray.append(event as! DataSnapshot)
            }
            if(self.questionArray.count == 0){
                self.searchBtnView.alpha = 0
                self.createItemView.alpha = 0
                self.addItemView.alpha = 1
                //self.headerAddBtn.alpha = 1
                self.scrollView.alpha = 0
                self.addVIEW.alpha = 1
               // self.tableView.reloadData()
            }else{
                self.publishedDateArray.removeAll()
                self.startingDateArray.removeAll()
                self.totalServeyArray.removeAll()
                for i in 0 ..< self.questionArray.count {
                    self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Form/\(self.questionArray[i].key)/Servey").queryOrderedByKey().observe(.value){ snapshot in
                        let snapDict = snapshot.value as? NSDictionary
                        if snapDict != nil{
                            self.totalServeyArray.append("\(snapDict!.count)")
                        }else{
                            self.totalServeyArray.append("0")
                        }
                        
                    }
                }
                for i in 0 ..< self.questionArray.count {
                    self.ref.child("GlobalForms/\(appDelegate.uniqueID!)\(self.questionArray[i].key)/End/Time").queryOrderedByKey().observe(.value){ (snapshot) in
                    
                        self.publishedDateArray.append(snapshot)
                        //self.tableView.reloadData()
                    }
                }
                for i in 0 ..< self.questionArray.count {
                    self.ref.child("GlobalForms/\(appDelegate.uniqueID!)\(self.questionArray[i].key)/Start/Time").queryOrderedByKey().observe(.value){ (snapshot) in
                    
                        self.startingDateArray.append(snapshot)
                        if (self.questionArray.count == self.startingDateArray.count && self.questionArray.count == self.publishedDateArray.count && self.questionArray.count == self.totalServeyArray.count){
                            self.tableView.reloadData()
                        }
                    }
                }
                self.addItemView.alpha = 0
                self.createItemView.alpha = 1
                self.searchView.alpha = 1
                //self.headerAddBtn.alpha = 1
                self.scrollView.alpha = 1
                self.addVIEW.alpha = 0
            }
            appDelegate.formNameArray = self.questionArray
            LoadingIndicatorView.hide()
          
        }
    }
    
    @IBAction func shareViewCloseBtn(_ sender: Any) {
        self.emailNotFoundErrorMsg.alpha = 0
        self.gmailAddTextField.text? = ""
        self.shareView.alpha = 0
    }
    
    @IBAction func gmailAddBtn(_ sender: Any) {
        hideKeyboard()
        LoadingIndicatorView.show()
        getGmailAndCheckWithAllGmail()
    }
    

    @IBAction func emptyViewAddBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
        self.navigationController?.pushViewController(formBuilderViewController!, animated: true)
    }
    
    @IBAction func headerCreateNewBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
        self.navigationController?.pushViewController(formBuilderViewController!, animated: true)
    }
    
    
    @IBAction func headerAddButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
        self.navigationController?.pushViewController(formBuilderViewController!, animated: true)
    }
    
    @IBAction func sideMenuOpenBtn(_ sender: Any) {
        NavigationDrawer.instance.toggleNavigationDrawer(completionHandler: nil)
    }
    
    func getGmailAndCheckWithAllGmail(){
        self.check = 0
        self.verifiedEmail = (self.gmailAddTextField.text?.replacingOccurrences(of: ".", with: "%"))!
        allGmailArray.removeAll()
        self.ref.child("AllUsers").queryOrderedByKey().observe(.value){ (snapshot) in
            self.allGmailArray.removeAll()
            for event in snapshot.children.allObjects {

                self.allGmailArray.append(event as! DataSnapshot)
            }

            
            if self.allGmailArray.count > 0{
                for i in 0 ..< self.allGmailArray.count{
                    if (self.allGmailArray[i].key == self.verifiedEmail){
                        self.check = 1
                        self.sharedUniqueId = self.allGmailArray[i].value as! String
                    }
                }
            }
            if self.check == 0 {
                self.emailNotFoundErrorMsg.alpha = 1
                self.shareView.alpha = 1
            }else{
                self.emailNotFoundErrorMsg.alpha = 0
                let path: String = "UserDetails/\(self.sharedUniqueId)/\("Shared")/\(self.sharedFormName)"
                let path2: String = "UserDetails/\(appDelegate.uniqueID!)/\("Form")/\(self.singleFormName)"
                self.ref.child(path).setValue("Yes")
                self.ref.child(path2).child("Shared").child(self.sharedUniqueId).setValue("Yes")
                self.shareView.alpha = 0
            }
            LoadingIndicatorView.hide()
        }
        self.gmailAddTextField.text? = ""
    }
    
    @IBAction func shareOptionViewCancelBtn(_ sender: Any) {
        self.shareOptionView.alpha = 0
    }
    
    
    @IBAction func shareUniqueCodeBtnPressed(_ sender: Any) {
        self.formCodeTextField.text = ""
        self.shareOptionView.alpha = 0
        shareUniqueCodeFunction()
    }
    
    @IBAction func shareUrlBtnPressed(_ sender: Any) {
        self.shareOptionView.alpha = 0
        shareUrlFunction()
    }
        
    func shareUniqueCodeFunction() {
        getAllFormUniqueCode()
        self.formCodeCreateView.alpha = 1
        self.formCodeCreateSubView.alpha = 1
        self.formCodeCreateErrorTextLbl.alpha = 0
        self.formCodeShowView.alpha = 0
    }
    
    func shareUrlFunction() {
        self.shareUrl = "com.goform://id=\(appDelegate.uniqueID!)\(sharingFormName)"
        self.shareView.alpha = 0
        UIPasteboard.general.string = self.shareUrl
        self.exectURL = URL(string: "\(self.shareUrl)")
        self.sharedObjects = [self.exectURL as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: self.sharedObjects , applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ .airDrop]
        activityViewController.isModalInPresentation = true
        activityViewController.popoverPresentationController?.sourceView = UIView()
        self.present(activityViewController, animated: true, completion: nil)
        //self?.successUrlText.text = self?.shareUrl
    }
    
    
    // Form code generate field
    @IBAction func formCreateViewCancelBtn(_ sender: Any) {
        self.formCodeCreateView.alpha = 0
    }
    
    @IBAction func formCodeCreateSubmitBtnPressed(_ sender: Any) {
        if (self.formCodeTextField.text! == ""){
            self.formCodeCreateErrorTextLbl.alpha = 1
            self.formCodeCreateErrorTextLbl.text = "You can't submit empty name"
            return
        }
        print(self.allFormUniqueCodeArray)
        if self.allFormUniqueCodeArray.count > 0 {
            for i in 0 ..< self.allFormUniqueCodeArray.count{
                print("\(self.allFormUniqueCodeArray[i].key)")
                if ("\(self.allFormUniqueCodeArray[i].key)" == "\(self.formCodeTextField.text!)"){
                    self.check = 1
                }
            }
        }
        if self.check == 1 {
            self.formCodeCreateErrorTextLbl.alpha = 1
            self.formCodeCreateSubView.alpha = 1
            self.formCodeShowView.alpha = 0
            self.check = 0
        }else{
            self.formCodeCreateErrorTextLbl.alpha = 0
            self.formCodeCreateSubView.alpha = 0
            self.formCodeShowView.alpha = 1
            self.showingCodeTextLbl.text = self.formCodeTextField.text
            let path: String = "GlobalFormsUniqueCode/\(self.formCodeTextField.text!)"
            self.ref.child(path).setValue("\(appDelegate.uniqueID!)\(sharingFormName)")
        }
    }
    
    @IBAction func formCodeCreateCopyBtnPressed(_ sender: Any) {
        UIPasteboard.general.string = self.formCodeTextField.text
        self.formCodeTextField.text = ""
        self.formCodeCreateView.alpha = 0
    }
    
    func getAllFormUniqueCode(){
        LoadingIndicatorView.show()
        self.check = 0
        allFormUniqueCode.removeAll()
        self.ref.child("GlobalFormsUniqueCode").queryOrderedByKey().observe(.value){ (snapshot) in
            self.allFormUniqueCode.removeAll()
            if (snapshot.value != nil){
                for event in snapshot.children.allObjects {

                    self.allFormUniqueCodeArray.append(event as! DataSnapshot)
                }
            }else{
                
            }
            LoadingIndicatorView.hide()
        }
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.sharedFormArray.count == 0 ? 1 : 2
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return "My Form"
//        }else{
//            return "Shared Form"
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(section == 0){
//            return publishedDateArray.count
//        }else{
//            return sharedFormArray.count
//        }
        print(startingDateArray.count)
        print(questionArray.count)
        print(publishedDateArray.count)
        print(totalServeyArray.count)
        return startingDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            let cell: MainViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainViewTableViewCell", for: indexPath) as! MainViewTableViewCell
//            if questionArray.count > 0 {
//                cell.shareBtn.tag = indexPath.row + 1
//                cell.addBtn.tag = indexPath.row + 1
//                cell.didShare = { [weak self] tag in
//                    self?.shareUrl = "com.goform://id=\(appDelegate.uniqueID!)\(self!.questionArray[indexPath.row].key)"
//                    self?.shareView.alpha = 0
//                    UIPasteboard.general.string = self!.shareUrl
//                    self!.exectURL = URL(string: "\(self!.shareUrl)")
//                    self?.sharedObjects = [self!.exectURL as AnyObject]
//                    let activityViewController = UIActivityViewController(activityItems: self!.sharedObjects , applicationActivities: nil)
//                    activityViewController.excludedActivityTypes = [ .airDrop]
//                    activityViewController.isModalInPresentation = true
//                    activityViewController.popoverPresentationController?.sourceView = UIView()
//                    self?.present(activityViewController, animated: true, completion: nil)
//                    //self?.successUrlText.text = self?.shareUrl
//
//                }
//                cell.didAdd = { [weak self] tag in
//                    self?.sharedFormName = "\(appDelegate.uniqueID!)\(self!.questionArray[indexPath.row].key)"
//                    self?.singleFormName = "\(self!.questionArray[indexPath.row].key)"
//                    self?.shareView.alpha = 1
//                }
//
//                cell.didCount = { [weak self] tag in
//                    appDelegate.sharedPeopleViewFormName = "\(self!.questionArray[indexPath.row].key)"
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let sharedPeopleViewController = storyboard.instantiateViewController(withIdentifier: "SharedPeopleViewController") as? SharedPeopleViewController
//                    //appDelegate.currentNav?.pushViewController(formFillupViewController!, animated: true)
//                    UIApplication.shared.keyWindow?.rootViewController?.present(sharedPeopleViewController!, animated: true, completion: nil)
//                }
//
//                if (publishedDateArray.count > 0){
//                    print(publishedDateArray.count)
//                    print("\(self.publishedDateArray[indexPath.row].value)")
//                    self.dayDifference(from: self.publishedDateArray[indexPath.row].value as? TimeInterval ?? 0.00)
//                    if(show == true){
//                        cell.expiredView.alpha = 1
//                        cell.cellView.alpha = 0
//                        cell.inviteView.alpha = 0
//                        cell.shareView.alpha = 0
//                        cell.totalViewdView.alpha = 0
//                        cell.publishedLbl.alpha = 0
//                        cell.publishedDateLbl.alpha = 0
//                        show = false
//                    }else{
//
//                        let calendar = Calendar.current
//                        let date = Date(timeIntervalSince1970: self.startingDateArray[indexPath.row].value as! TimeInterval ?? 0.00)
//                        let format = date.getFormattedDate(format: "d MMM yyyy")
//                        cell.publishedDateLbl.text = "On \(format)"
//                        cell.expiredCellView.alpha = 0
//                        cell.expiredView.alpha = 0
//                    }
//                }
//
//                cell.formName.text = self.questionArray[indexPath.row].key
//            }
//            return cell
//        }else{
//
//            let cell: MainViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SharedTableViewCell", for: indexPath) as! MainViewTableViewCell
//            if sharedFormArray.count > 0 {
//                cell.shareBtn.tag = indexPath.row + 1
//                //cell.addBtn.tag = indexPath.row + 1
//                cell.didShare = { [weak self] tag in
//                    self?.shareUrl = "com.goform://id=\(self!.sharedFormArray[indexPath.row].key)"
//                    self?.shareView.alpha = 0
//                    UIPasteboard.general.string = self!.shareUrl
//                    self!.exectURL = URL(string: "\(self!.shareUrl)")
//                    self?.sharedObjects = [self!.exectURL as AnyObject]
//                    let activityViewController = UIActivityViewController(activityItems: self!.sharedObjects , applicationActivities: nil)
//                    activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook, .postToTwitter, .mail]
//                    activityViewController.isModalInPresentation = true
//                    activityViewController.popoverPresentationController?.sourceView = UIView()
//                    self?.present(activityViewController, animated: true, completion: nil)
//                    //self?.successUrlText.text = self?.shareUrl
//
//                }
////                cell.didAdd = { [weak self] tag in
////                    self?.sharedFormName = "\(self!.sharedFormArray[indexPath.row].key)"
////                    self?.successView.alpha = 1
////                }
//                let index = self.sharedFormArray[indexPath.row].key.index(self.sharedFormArray[indexPath.row].key.startIndex, offsetBy: 21)
//                let subString = self.sharedFormArray[indexPath.row].key.substring(from: index)
//                cell.formName.text = subString
//            }
//
//            if ("\(self.sharedFormArray[indexPath.row].value!)" == "Yes"){
//                cell.status.text = "Active"
//            }else{
//                cell.status.text = "Inactive"
//            }
//
//            return cell
//        }
        
        
        let cell: MainViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainViewTableViewCell", for: indexPath) as! MainViewTableViewCell
        if startingDateArray.count > 0 {
            cell.shareBtn.tag = indexPath.row + 1
            cell.addBtn.tag = indexPath.row + 1
            cell.propleCountBtn.tag = indexPath.row + 1
            cell.showBtn.tag = indexPath.row + 1
            cell.didShare = { [weak self] tag in
                self?.shareOptionView.alpha = 1
                self!.sharingFormName = "\(self!.questionArray[indexPath.row].key)"
            }
            cell.didAdd = { [weak self] tag in
                self?.sharedFormName = "\(appDelegate.uniqueID!)\(self!.questionArray[indexPath.row].key)"
                self?.singleFormName = "\(self!.questionArray[indexPath.row].key)"
                self?.shareView.alpha = 1
            }
            
            cell.didCount = { [weak self] tag in
                appDelegate.sharedPeopleViewFormName = "\(self!.questionArray[indexPath.row].key)"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sharedPeopleViewController = storyboard.instantiateViewController(withIdentifier: "SharedPeopleViewController") as? SharedPeopleViewController
                self?.navigationController!.pushViewController(sharedPeopleViewController!, animated: true)
            }
            
            cell.didShow = { [weak self] tag in
                appDelegate.peopleServeyScreenFormName = self!.questionArray[indexPath.row].key
                let storyboard = UIStoryboard(name: "Form", bundle: nil)
                let formServeyListViewController = storyboard.instantiateViewController(withIdentifier: "FormServeyListViewController") as? FormServeyListViewController
                self?.navigationController!.pushViewController(formServeyListViewController!, animated: true)
                
            }
            
            if (startingDateArray.count > 0){
                let calendar = Calendar.current
                print(self.publishedDateArray.count)
                let date = Date(timeIntervalSince1970: self.publishedDateArray[indexPath.row].value as? TimeInterval ?? 0.00)
                if date < Date.now {
                    print(self.questionArray.count)
                    cell.expiredViewFirstLetter.text = self.questionArray[indexPath.row].key.first?.description
                    
                    cell.expiredCellView.alpha = 1
                    cell.cellView.alpha = 0
                }
                else{
                    print(self.questionArray.count)
                    cell.notExpiredFirstLetter.text = self.questionArray[indexPath.row].key.first?.description
                    let date = Date(timeIntervalSince1970: self.startingDateArray[indexPath.row].value as? TimeInterval ?? 0.00)
                    let format = date.getFormattedDate(format: "d MMM yyyy")
                    cell.publishedDateLbl.text = "On \(format)"
                    cell.expiredCellView.alpha = 0
                   
                    cell.cellView.alpha = 1
                }
            }
            print(self.questionArray.count)
            print(self.totalServeyArray.count)
            cell.notExpiredTotalValue.text = self.totalServeyArray[indexPath.row]
            cell.expiredTotalValue.text = self.totalServeyArray[indexPath.row]
            cell.formName.text = self.questionArray[indexPath.row].key
            cell.expiredViewFormName.text = self.questionArray[indexPath.row].key
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (startingDateArray.count > 0){
            
            let calendar = Calendar.current
            print(self.publishedDateArray.count)
            let date = Date(timeIntervalSince1970: self.publishedDateArray[indexPath.row].value as? TimeInterval ?? 0.00)
            if date < Date.now {
                return 90
            }
            else{
                return 120
            }
           
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let fullFormViewViewController = storyboard.instantiateViewController(withIdentifier: "FullFormViewViewController") as? FullFormViewViewController
//            self.navigationController?.pushViewController(fullFormViewViewController!, animated: true)
//            appDelegate.formNameText = self.questionArray[indexPath.row].key
//        }else{
//            if ("\(self.sharedFormArray[indexPath.row].value!)" == "Yes"){
//                appDelegate.isShared = true
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let fullFormViewViewController = storyboard.instantiateViewController(withIdentifier: "FullFormViewViewController") as? FullFormViewViewController
//                self.navigationController?.pushViewController(fullFormViewViewController!, animated: true)
//                appDelegate.formNameText = self.sharedFormArray[indexPath.row].key
//            }else{
//                appDelegate.myDatePicker.showSingleButtonAlert(message: "You have no permission to open or edit this form.", okText: "Ok", vc: self)
//            }
//        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
        self.navigationController?.pushViewController(formBuilderViewController!, animated: true)
        appDelegate.isFullFormView = true
        appDelegate.isSharedFormView = false
        appDelegate.formNameText = self.questionArray[indexPath.row].key
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            self.sharedGmailArray.removeAll()
//            if editingStyle == .delete {
//              print("Deleted")
//                self.ref.child(appDelegate.uniqueID!).child("Form").child("\(questionArray[indexPath.row].key)").child("Shared").queryOrderedByKey().observe(.value){ (snapshot) in
//                    self.sharedGmailArray.removeAll()
//                    for event in snapshot.children.allObjects {
//
//                        self.sharedGmailArray.append(event as! DataSnapshot)
//                    }
//
//                    if self.sharedGmailArray.count > 0{
//                        for i in 0 ..< self.sharedGmailArray.count{
//                            print(self.sharedGmailArray[i].key)
//                            let path: String = "\(self.sharedGmailArray[i].key)/Shared/\(appDelegate.uniqueID!)\(self.questionArray[indexPath.row].key)"
//                            self.ref.child(path).removeValue()
//                        }
//                    }
//                    self.getData()
//                }
//                let path: String = "\(appDelegate.uniqueID!)/\("Form")/\(questionArray[indexPath.row].key)"
//                let path2: String = "\(appDelegate.uniqueID!)\(questionArray[indexPath.row].key)"
//                self.ref.child(path).removeValue()
//                self.ref.child(path2).removeValue()
////                self.getData()
//            }
//        }else{
////            if editingStyle == .delete {
////              print("Deleted")
////                let path: String = "\(appDelegate.uniqueID!)/\("Shared")/\(sharedFormArray[indexPath.row].key)"
////                self.ref.child(path).removeValue()
////                self.getData()
////            }
//        }
        
        
        self.sharedGmailArray.removeAll()
        if editingStyle == .delete {
//            self.ref.child(appDelegate.uniqueID!).child("Form").child("\(questionArray[indexPath.row].key)").child("Shared").queryOrderedByKey().observe(.value){ (snapshot) in
//                self.sharedGmailArray.removeAll()
//                for event in snapshot.children.allObjects {
//
//                    self.sharedGmailArray.append(event as! DataSnapshot)
//                }
//
//                if self.sharedGmailArray.count > 0{
//                    for i in 0 ..< self.sharedGmailArray.count{
//                        print(self.sharedGmailArray[i].key)
//                        let path: String = "\(self.sharedGmailArray[i].key)/Shared/\(appDelegate.uniqueID!)\(self.questionArray[indexPath.row].key)"
//                        self.ref.child(path).removeValue()
//                    }
//                }
//                self.getData()
//            }
            let path: String = "UserDetails/\(appDelegate.uniqueID!)/\("Form")/\(questionArray[indexPath.row].key)"
            let path2: String = "GlobalForms/\(appDelegate.uniqueID!)\(questionArray[indexPath.row].key)"
            self.ref.child(path).removeValue()
            self.ref.child(path2).removeValue()
            Database.database().reference().removeAllObservers()
            self.getData()
        }
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
