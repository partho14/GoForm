//
//  SharedFormViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 22/2/23.
//

import UIKit
import Firebase
import GoogleSignIn

class SharedFormViewController: UIViewController {
    
    @IBOutlet weak var headerTittleTextLbl: UILabel!{
        didSet{
            headerTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 20)

        }
    }
    @IBOutlet weak var noItemAvailableTextLbl: UILabel!{
        didSet{
            noItemAvailableTextLbl.font = UIFont(name: "Barlow-Medium", size: 24.0)
            noItemAvailableTextLbl.numberOfLines = 1
            noItemAvailableTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addView: UIView!
    
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
    var singleFormName: String = ""
    var sharedGmailArray: [DataSnapshot] = []
    var formOpenPermission: [String] = []
    var totalServeyArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Database.database().reference().removeAllObservers()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
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
        appDelegate.isSharedFormView = false
        appDelegate.isFullFormView = false
        appDelegate.sharedFormTotalView = false
        DispatchQueue.main.async {
            self.getData()
        }
    }
    
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    func getData(){
        self.show = false
        questionArray.removeAll()
        publishedDateArray.removeAll()
        sharedFormArray.removeAll()
        startingDateArray.removeAll()
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Shared").queryOrderedByKey().observe(.value){ snapshot in
            self.questionArray.removeAll()
            for event in snapshot.children.allObjects {

                self.questionArray.append(event as! DataSnapshot)
            }
            if(self.questionArray.count == 0){
                self.scrollView.alpha = 0
                self.addView.alpha = 1
            }else{
                self.publishedDateArray.removeAll()
                self.startingDateArray.removeAll()
                self.totalServeyArray.removeAll()
                for i in 0 ..< self.questionArray.count {
                    print(self.questionArray[i].key)
                    self.formOpenPermission.append(self.questionArray[i].value as! String)
                    self.ref.child("GlobalForms/\(self.questionArray[i].key)/End/Time").queryOrderedByKey().observe(.value){ (snapshot) in
                    
                        self.publishedDateArray.append(snapshot)
                        //self.tableView.reloadData()
                    }
                }
                
                for i in 0 ..< self.questionArray.count {
                    self.ref.child("GlobalForms/\(self.questionArray[i].key)/Servey").queryOrderedByKey().observe(.value){ snapshot in
                        let snapDict = snapshot.value as? NSDictionary
                        if snapDict != nil{
                            self.totalServeyArray.append("\(snapDict!.count)")
                        }else{
                            self.totalServeyArray.append("0")
                        }
                        
                    }
                }
                
                for i in 0 ..< self.questionArray.count {
                    self.ref.child("GlobalForms/\(self.questionArray[i].key)/Start/Time").queryOrderedByKey().observe(.value){ (snapshot) in
                        if snapshot.exists() {
                            self.startingDateArray.append(snapshot)
                            if (self.questionArray.count == self.startingDateArray.count){
                                self.tableView.reloadData()
                            }
                        }else{
                            self.questionArray.remove(at: i)
                            if (self.questionArray.count == self.startingDateArray.count){
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                self.scrollView.alpha = 1
                self.addView.alpha = 0
            }
            appDelegate.formNameArray = self.questionArray
            LoadingIndicatorView.hide()
          
        }
//        self.ref.child("\(appDelegate.uniqueID!)/Shared").queryOrderedByKey().observe(.value){ (snapshot) in
//            self.sharedFormArray.removeAll()
//            for event in snapshot.children.allObjects {
//
//                self.sharedFormArray.append(event as! DataSnapshot)
//            }
//            if(self.sharedFormArray.count == 0 && self.questionArray.count == 0){
//
//                self.addVIEW.layer.cornerRadius = 0
//                self.scrollView.alpha = 0
//                self.addVIEW.alpha = 1
//                self.tableView.reloadData()
//            }else{
//
//                self.addVIEW.layer.cornerRadius = 25
//                self.scrollView.alpha = 1
//                self.addVIEW.alpha = 0
//                self.tableView.reloadData()
//            }
//            appDelegate.sharedFormArray = self.sharedFormArray
//            LoadingIndicatorView.hide()
//        }
//
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SharedFormViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startingDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SharedFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SharedFormTableViewCell", for: indexPath) as! SharedFormTableViewCell
        if startingDateArray.count > 0 {
            
            let index = self.questionArray[indexPath.row].key.index(self.questionArray[indexPath.row].key.startIndex, offsetBy: 28)
            let subString = self.questionArray[indexPath.row].key.substring(from: index)
            
            cell.shareBtn.tag = indexPath.row + 1
            cell.addBtn.tag = indexPath.row + 1
            cell.showBtn.tag = indexPath.row + 1
            cell.didShare = { [weak self] tag in
                print("com.goform://id=\(self!.questionArray[indexPath.row].key)")
                self?.shareUrl = "com.goform://id=\(self!.questionArray[indexPath.row].key)"
                UIPasteboard.general.string = self!.shareUrl
                self!.exectURL = URL(string: "\(self!.shareUrl)")
                self?.sharedObjects = [self!.exectURL as AnyObject]
                let activityViewController = UIActivityViewController(activityItems: self!.sharedObjects , applicationActivities: nil)
                activityViewController.excludedActivityTypes = [ .airDrop]
                activityViewController.isModalInPresentation = true
                activityViewController.popoverPresentationController?.sourceView = UIView()
                self?.present(activityViewController, animated: true, completion: nil)
                //self?.successUrlText.text = self?.shareUrl
                
            }
            cell.didAdd = { [weak self] tag in
                self?.sharedFormName = "\(appDelegate.uniqueID!)\(self!.questionArray[indexPath.row].key)"
                self?.singleFormName = "\(self!.questionArray[indexPath.row].key)"
            }
            
            cell.didCount = { [weak self] tag in
                appDelegate.sharedPeopleViewFormName = "\(self!.questionArray[indexPath.row].key)"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sharedPeopleViewController = storyboard.instantiateViewController(withIdentifier: "SharedPeopleViewController") as? SharedPeopleViewController
                self?.navigationController!.pushViewController(sharedPeopleViewController!, animated: true)
            }
            
            cell.didShow = { [weak self] tag in
                appDelegate.sharedFormTotalView = true
                appDelegate.peopleServeyScreenFormName = self!.questionArray[indexPath.row].key
                let storyboard = UIStoryboard(name: "Form", bundle: nil)
                let formServeyListViewController = storyboard.instantiateViewController(withIdentifier: "FormServeyListViewController") as? FormServeyListViewController
                self?.navigationController!.pushViewController(formServeyListViewController!, animated: true)
                
            }

            
            if (startingDateArray.count > 0){
                let date = Date(timeIntervalSince1970: self.publishedDateArray[indexPath.row].value as? TimeInterval ?? 0.00)
                if date < Date.now {
                    cell.expiredFirstLetter.text = subString.first?.description
                    cell.expiredView.alpha = 1
                    cell.notExpiredView.alpha = 0
                }
                else{
                    cell.notExpiredFirstLetter.text = subString.first?.description
                    let date = Date(timeIntervalSince1970: self.startingDateArray[indexPath.row].value as? TimeInterval ?? 0.00)
                    let format = date.getFormattedDate(format: "d MMM yyyy")
                    cell.notExpiredFormCreateDate.text = "On \(format)"
                    cell.expiredView.alpha = 0
                    cell.notExpiredView.alpha = 1
                }
            }
            cell.notExpiredTotalRecieveCount.text = self.totalServeyArray[indexPath.row]
            cell.expiredTotalRecieveCount.text = self.totalServeyArray[indexPath.row]
            cell.notExpiredFormName.text = subString
            cell.expiredFormName.text = subString
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (startingDateArray.count > 0){
            
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//                    if ("\(self.questionArray[indexPath.row].value!)" == "Yes"){
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let formBuilderViewController = storyboard.instantiateViewController(withIdentifier: "FormBuilderViewController") as? FormBuilderViewController
//                        self.navigationController?.pushViewController(formBuilderViewController!, animated: true)
//                        appDelegate.isSharedFormView = true
//                        appDelegate.isFullFormView = true
//                        let index = self.questionArray[indexPath.row].key.index(self.questionArray[indexPath.row].key.startIndex, offsetBy: 28)
//                        let subString = self.questionArray[indexPath.row].key.substring(from: index)
//                        let uniqueIdSubString = self.questionArray[indexPath.row].key.take(28)
//                        print(uniqueIdSubString)
//                        print(subString)
//                        appDelegate.shared = true
//                        appDelegate.sharedFormUniqueId = uniqueIdSubString
//                        appDelegate.formNameText = subString
//                    }else{
//                        appDelegate.myDatePicker.showSingleButtonAlert(message: "You have no permission to open or edit this form.", okText: "Ok", vc: self)
//                    }
//    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.sharedGmailArray.removeAll()
        if editingStyle == .delete {
            let index = self.questionArray[indexPath.row].key.index(self.questionArray[indexPath.row].key.startIndex, offsetBy: 28)
            let subString = self.questionArray[indexPath.row].key.substring(from: index)
            let uniqueIdSubString = self.questionArray[indexPath.row].key.take(28)
            let path: String = "UserDetails/\(uniqueIdSubString)/\("Form")/\(subString)"
            let path2: String = "GlobalForms/\(self.questionArray[indexPath.row].key)"
            self.ref.child(path).removeValue()
            self.ref.child(path2).removeValue()
            Database.database().reference().removeAllObservers()
            self.getData()
        }
    }
}
extension String {
    func take(_ n: Int) -> String {
        guard n >= 0 else {
            fatalError("n should never negative")
        }
        let index = self.index(self.startIndex, offsetBy: min(n, self.count))
        return String(self[..<index])
    }
}
