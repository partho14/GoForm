//
//  FormFillupViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 9/2/23.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import DropDown
import FirebaseStorage
import MobileCoreServices
import UniformTypeIdentifiers

class FormFillupViewController: UIViewController, UIScrollViewDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var newStartDatePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.tintColor = UIColor.red
        v.backgroundColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1)
        return v
    }()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var dateView: UIView!{
        didSet{
            dateView.layer.borderWidth = 1
            dateView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            dateView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var formNameView: UIView!
    @IBOutlet weak var formFillupHeaderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submitBtnView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var formNamTextLbl: UILabel!{
        didSet{
            self.formNamTextLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    
    @IBOutlet weak var formNameBorderView: UIView!{
        didSet{
            formNameBorderView.layer.borderWidth = 1
            formNameBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            formNameBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var formNameTittleLbl: UILabel!{
        didSet{
            formNameTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            formNameTittleLbl.numberOfLines = 1
            formNameTittleLbl.sizeToFit()
            formNameTittleLbl.adjustsFontSizeToFitWidth = true
            formNameTittleLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var formNameErrorText: UILabel!
    @IBOutlet weak var formNameTextFieldView: UIView!{
        didSet{
            formNameTextFieldView.layer.borderWidth = 1
            formNameTextFieldView.layer.cornerRadius = 10
            formNameTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var formNameTextField: UITextField!
    @IBOutlet weak var formNameSubmitBtnView: UIView!
    
    var errorTextLbl = UILabel()
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var splitUrl: String = ""
    var fullFormViewData: [NSDictionary] = [NSDictionary]()
    var submittedAnsData: [NSDictionary] = [NSDictionary]()
    var dynamicArray = [[String:Any]]()
    var ansDynamicArray = [[String:Any]]()
    var ansBoolValue: [Bool] = []
    var fileUrlArray : [String] = []
    var startDate = Date()
    var filePathUrl: String = ""
    var filePathText: String = ""
    var textFieldIndex = 0
    var dateFieldIndex = 0
    var dropdownFieldIndex = 0
    var singleChoiceIndex = 0
    var multipleChoiceIndex = 0
    var fileIndex = 0
    var multipleImageIndex = 0
    var fileArrayIndex = 0
    var shareUrl: String = ""
    var multipleImageStoreIndex: [String] = []
    var questionUniqueName: String = ""
    
    var textFieldData = [[String:String]]()
    var datePickerData = [[String:String]]()
    var fileUploadData = [[String:String]]()
    var dropdownData = [[String:Any]]()
    var singleChoiceData = [[String:Any]]()
    var multipleChoiceData = [[String:Any]]()
    var multipleImageDataStore = [[String:Any]]()
    var emptyMultipleImage : [String] = []
    
    var imagePicker = UIImagePickerController()
    var storageRef: StorageReference!
    var documentPicker: UIDocumentPickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        imagePicker.delegate = self
        dateView?.frame.size.height = newStartDatePicker.frame.size.height
        newStartDatePicker.frame.size.width = dateView.frame.size.width
        dateView.addSubview(newStartDatePicker)
        scrollView.frame.size.width = self.view.frame.size.width
        //scrollView.frame.size.height = self.view.frame.size.height
        tableView.frame.size.width = self.view.frame.size.width
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        scrollView.addSubview(self.tableView)
        self.dateView.alpha = 0
        self.dateBtn.alpha = 0
        self.formFillupHeaderView.alpha = 0
        self.scrollView.alpha = 0
        self.submitBtnView.alpha = 0
        if appDelegate.isFillupFormViewingView {
            self.formNameView.alpha = 0
            self.splitUrl = appDelegate.isFillupFormViewingFormName!
            let index = self.splitUrl.index(self.splitUrl.startIndex, offsetBy: 28)
            let subString = self.splitUrl.substring(from: index)
            self.formNamTextLbl.text = subString
            print("UserDetails/\(appDelegate.uniqueID!)/mysubmit/\(splitUrl)")
            loadFormFillupShowingData()
        }else if appDelegate.peopleServeyScreenView{
            self.formNameView.alpha = 0
            self.submitBtnView.alpha = 0
            self.formNamTextLbl.text = appDelegate.peopleServeyScreenFormName
            print("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.peopleServeyScreenFormName)/Servey/\(appDelegate.peoplwServeyUniqueId)/data")
            loadPeopleServeyData()
        }else if appDelegate.sharedFormTotalView {
            self.formNameView.alpha = 0
            self.submitBtnView.alpha = 0
            let index = appDelegate.peopleServeyScreenFormName.index(appDelegate.peopleServeyScreenFormName.startIndex, offsetBy: 28)
            let subString = appDelegate.peopleServeyScreenFormName.substring(from: index)
            _ = appDelegate.peopleServeyScreenFormName.take(28)
            self.formNamTextLbl.text = subString
            loadSharedFormServeyData()
        }else{
            self.formNameView.alpha = 1
        }
        self.formNameErrorText.alpha = 0
        submitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        formNameSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        
        initNewSelectDatePicker()
        
        errorTextLbl = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 20))
        errorTextLbl.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        errorTextLbl.textAlignment = .center
        errorTextLbl.text = ""
        errorTextLbl.textColor = .red
        errorTextLbl.numberOfLines = 2
        errorTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
        self.view.addSubview(errorTextLbl)
        errorTextLbl.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = scrollView.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        appDelegate.isFillupFormViewingView = false
        appDelegate.peopleServeyScreenView = false
    }
    
    func loadFormFillupShowingData(){
        self.formFillupHeaderView.alpha = 1
        self.scrollView.alpha = 1
        self.submitBtnView.alpha = 1
        self.formNameView.alpha = 0
        LoadingIndicatorView.show()
        self.ref.child("GlobalForms/\(splitUrl)/data").queryOrderedByKey().observe(.value){ snapshot in
            
            guard let data = snapshot.value as? [NSDictionary] else {
                self.showSingleButtonAlert(message: "This Form is no longer available", okText: "Ok", vc: self)
                return
                
            }
            
            self.fullFormViewData.append(contentsOf: (data))
            //self.extractData()
        }
        
        self.ref.child("GlobalForms/\(splitUrl)/End/Time").queryOrderedByKey().observe(.value){ snapshot in
            
            if snapshot.value != nil{
                let updateData = Date(timeIntervalSince1970: snapshot.value as? TimeInterval ?? 0.00)
                if updateData < Date.now {
                    self.formFillupHeaderView.alpha = 1
                    self.scrollView.alpha = 0
                    self.submitBtnView.alpha = 0
                    self.formNameView.alpha = 0
                    self.showSingleButtonAlert(message: "This Form is no longer available", okText: "Ok", vc: self)
                    return
                }
            }
        }
        
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/mysubmit/\(splitUrl)/data").queryOrderedByKey().observe(.value){ snapshot in
            
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.submittedAnsData.append(contentsOf: (data))
            self.myServeyDataExtract()
        }
    }
    
    func loadPeopleServeyData(){
        self.formFillupHeaderView.alpha = 1
        self.scrollView.alpha = 1
        self.submitBtnView.alpha = 0
        self.formNameView.alpha = 0
        LoadingIndicatorView.show()
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.peopleServeyScreenFormName)/data").queryOrderedByKey().observe(.value){ snapshot in
            self.fullFormViewData.removeAll()
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.fullFormViewData.append(contentsOf: (data))
            LoadingIndicatorView.hide()
            //self.extractData()
        }
        
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.peopleServeyScreenFormName)/Servey/\(appDelegate.peoplwServeyUniqueId)/data").queryOrderedByKey().observe(.value){ snapshot in
            
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.submittedAnsData.append(contentsOf: (data))
            self.myServeyDataExtract()
        }
    }
    
    func loadSharedFormServeyData(){
        self.formFillupHeaderView.alpha = 1
        self.scrollView.alpha = 1
        self.submitBtnView.alpha = 0
        self.formNameView.alpha = 0
        LoadingIndicatorView.show()
        
        let index = appDelegate.peopleServeyScreenFormName.index(appDelegate.peopleServeyScreenFormName.startIndex, offsetBy: 28)
        let subString = appDelegate.peopleServeyScreenFormName.substring(from: index)
        let uniqueIdSubString = appDelegate.peopleServeyScreenFormName.take(28)
        print(uniqueIdSubString)
        
        self.ref.child("UserDetails/\(uniqueIdSubString)/Form/\(subString)/data").queryOrderedByKey().observe(.value){ snapshot in
            self.fullFormViewData.removeAll()
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.fullFormViewData.append(contentsOf: (data))
            LoadingIndicatorView.hide()
            //self.extractData()
        }
        print("UserDetails/\(uniqueIdSubString)/Form/\(subString)/Servey/\(appDelegate.peoplwServeyUniqueId)/data")
        self.ref.child("UserDetails/\(uniqueIdSubString)/Form/\(subString)/Servey/\(appDelegate.peoplwServeyUniqueId)/data").queryOrderedByKey().observe(.value){ snapshot in
            
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.submittedAnsData.append(contentsOf: (data))
            print(self.submittedAnsData)
            self.myServeyDataExtract()
        }
    }
    
    func myServeyDataExtract(){
        for i in 0 ..< fullFormViewData.count{
            let fullString = fullFormViewData[i].allKeys.first!  as! String
            if ((fullFormViewData[i].value(forKey: "\(fullString)")) != nil){
                let textDataValue = fullFormViewData[i]["\(fullString)"]!
                dynamicArray.append(["\(fullFormViewData[i].allKeys.first!)" : textDataValue])
            }
            else{
            }
        }
        print(dynamicArray)
        for i in 0 ..< submittedAnsData.count{
//            if (submittedAnsData.count - 1 >= i){
//                let fullString = submittedAnsData[i].allKeys.first!  as! String
//                if ((submittedAnsData[i].value(forKey: "\(fullString)")) != nil){
//                    let textDataValue = submittedAnsData[i]["\(fullString)"]!
//                    ansDynamicArray.append(["\(submittedAnsData[i].allKeys.first!)" : textDataValue])
//                }
//                else{
//
//                }
//            }else{
//                //ansDynamicArray.append(["":""])
//            }
                let fullString = submittedAnsData[i].allKeys.first!  as! String
                if ((submittedAnsData[i].value(forKey: "\(fullString)")) != nil){
                    let textDataValue = submittedAnsData[i]["\(fullString)"]!
                    ansDynamicArray.append(["\(submittedAnsData[i].allKeys.first!)" : textDataValue])
                }
                else{
                    
                }
        }
        print(ansDynamicArray)
//        self.ansDynamicArray = Array(repeating: ["":""], count: self.dynamicArray.count)
//        self.fileUrlArray = Array(repeating: "", count: self.dynamicArray.count)
        self.ansBoolValue = Array(repeating: true, count: self.dynamicArray.count)
        LoadingIndicatorView.hide()
        self.tableView.reloadData()
        
    }
    func loadData(){
        LoadingIndicatorView.show()
        
        self.ref.child("GlobalForms/\(splitUrl)/Start/Time").queryOrderedByKey().observe(.value){ snapshot in
            
            if snapshot.value != nil{
                let date = Date(timeIntervalSince1970: snapshot.value as? TimeInterval ?? 0.00)
                if date > Date.now {
                    self.formFillupHeaderView.alpha = 1
                    self.scrollView.alpha = 0
                    self.submitBtnView.alpha = 0
                    self.formNameView.alpha = 0
                    self.showSingleButtonAlert(message: "This Form Will Open Soon", okText: "Ok", vc: self)
                }
                else{
                    self.formFillupHeaderView.alpha = 1
                    self.scrollView.alpha = 1
                    self.submitBtnView.alpha = 1
                    self.formNameView.alpha = 0
                }
            }else{
                self.formNameTextField.text = ""
                self.errorTextLbl.text = "Form not found, please enter correct form name"
                self.errorTextLbl.alpha = 1
                return
            }

        }
        
        self.ref.child("GlobalForms/\(splitUrl)/End/Time").queryOrderedByKey().observe(.value){ snapshot in
            
            if snapshot.value != nil{
                let updateData = Date(timeIntervalSince1970: snapshot.value as? TimeInterval ?? 0.00)
                if updateData < Date.now {
                    self.formFillupHeaderView.alpha = 1
                    self.scrollView.alpha = 0
                    self.submitBtnView.alpha = 0
                    self.formNameView.alpha = 0
                    self.showSingleButtonAlert(message: "This Form is no longer available", okText: "Ok", vc: self)
                }
                else{
                    self.formFillupHeaderView.alpha = 1
                    self.scrollView.alpha = 1
                    self.submitBtnView.alpha = 1
                    self.formNameView.alpha = 0
                }
            }else{
                self.formNameTextField.text = ""
                self.errorTextLbl.text = "Form not found, please enter correct form name"
                self.errorTextLbl.alpha = 1
                return
            }
        }
        
        self.ref.child("GlobalForms/\(splitUrl)/data").queryOrderedByKey().observe(.value){ snapshot in
            
            guard let data = snapshot.value as? [NSDictionary] else {
                self.formNameTextField.text = ""
                self.errorTextLbl.text = "Form not found, please enter correct form name"
                self.errorTextLbl.alpha = 1
                return
                
            }
            self.errorTextLbl.alpha = 0
            self.fullFormViewData.append(contentsOf: (data))
            LoadingIndicatorView.hide()
            self.extractData()
        }
    }
    
    func extractData(){
        for i in 0 ..< fullFormViewData.count{
            let fullString = fullFormViewData[i].allKeys.first!  as! String
            if ((fullFormViewData[i].value(forKey: "\(fullString)")) != nil){
                let textDataValue = fullFormViewData[i]["\(fullString)"]!
                dynamicArray.append(["\(fullFormViewData[i].allKeys.first!)" : textDataValue])
            }
            else{
            }
        }
        self.ansDynamicArray = Array(repeating: ["":""], count: self.dynamicArray.count)
        self.ansBoolValue = Array(repeating: false, count: self.dynamicArray.count)
        self.fileUrlArray = Array(repeating: "", count: self.dynamicArray.count)
        self.tableView.reloadData()
    }
    
    
    @IBAction func formFillupSubmitBtnPressed(_ sender: Any) {
        
        var isAllAnsAvaiable = 0
        for i in 0 ..< ansBoolValue.count{
            if (ansBoolValue[i] == false){
                isAllAnsAvaiable = 1
            }
        }
        
        if (isAllAnsAvaiable == 1){
            appDelegate.myDatePicker.showSingleButtonAlert(message: "You have to fill all input field", okText: "Ok", vc: self)
            return
        }else{
            let path: String = "UserDetails/\(appDelegate.uniqueID!)/mysubmit/\(splitUrl)/"
            let uniqueIdSubString = self.splitUrl.take(28)
            let index = splitUrl.index(self.splitUrl.startIndex, offsetBy: 28)
            let subString = self.splitUrl.substring(from: index)
            let peopleServeypath: String = "UserDetails/\(uniqueIdSubString)/Form/\(subString)/Servey/\(appDelegate.uniqueID!)"
            let path2: String = "GlobalForms/\(splitUrl)/Servey/\(appDelegate.uniqueID!)"
            let credential = ["data" : ansDynamicArray]
            self.ref.child(path).setValue(credential)
            self.ref.child(path2).setValue(credential)
            self.ref.child(peopleServeypath).setValue(credential)
            print(ansDynamicArray)
            print(ansDynamicArray[0].values)
            self.showSingleButtonAlert(message: "Successfully submitted your servey", okText: "Ok", vc: self)
        }
        
    }
    
    @IBAction func formNameSubmitBtnPressed(_ sender: Any) {
        let uniqueName = "\(self.formNameTextField.text!)"
        if formNameTextField.text?.count == 0 {
            self.errorTextLbl.text = "You can't submit empty field"
            self.formNameTextField.text = ""
            self.errorTextLbl.alpha = 1
            return
        }
        else if (uniqueName.contains("com.goform://id=")){

                self.formNameView.alpha = 0
                let splitUrlFUll = uniqueName.components(separatedBy: "=")
                self.splitUrl = splitUrlFUll.last ?? ""
                let index = self.splitUrl.index(self.splitUrl.startIndex, offsetBy: 28)
                let subString = self.splitUrl.substring(from: index)
                self.formNamTextLbl.text = subString
                self.formNameTextField.resignFirstResponder()
                self.loadData()
            
        }else{
            self.ref.child("GlobalFormsUniqueCode").child("\(uniqueName)").queryOrderedByKey().observe(.value){ (snapshot) in
                guard let data = snapshot.value as? String else {
                    self.formNameTextField.text = ""
                    self.errorTextLbl.text = "Form not found, please enter correct form name"
                    self.errorTextLbl.alpha = 1
                    return
                }
                self.splitUrl = data
                self.loadData()
            }
        }
        
    }
    
    @IBAction func formNameCancelBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func formFillupCancelBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    func initNewSelectDatePicker() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        let currentDate = Date()
        components.calendar = calendar
        components.year = 18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        if #available(iOS 14.0, *) {
            newStartDatePicker.preferredDatePickerStyle = .inline
        } else {
            // use default
        }
        
        self.newStartDatePicker.datePickerMode = .date
        
        self.dateView!.addSubview(newStartDatePicker)
        self.dateView!.frame.size.height = newStartDatePicker.frame.size.height
        self.newStartDatePicker.maximumDate = maxDate
        components.year = -100
        components.month = 12
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        self.newStartDatePicker.minimumDate = minDate
        newStartDatePicker.addTarget(self, action: #selector(selectDateChanged(_:)), for: .valueChanged)
    }
    
    @objc func selectDateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
            
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            //lblEndDate.text = dateFormatter.string(from: date)
            startDate = date
        }
        print(dateFieldIndex)
        print("endDate => \(String(describing: startDate))")
        var dateEditDataValue = self.dynamicArray[dateFieldIndex]["\(questionUniqueName)"]! as? [[String:Any]]
//        self.ansDynamicArray.remove(at: self.dateFieldIndex )
//        self.ansDynamicArray.insert(["\((dateEditDataValue?[0]["tittle"])!)" : "\(startDate)"], at: self.dateFieldIndex)
        if (appDelegate.isFillupFormViewingView){
            self.datePickerData.append([ "title" : "\((dateEditDataValue?[0]["title"])!)"])
            self.datePickerData.append([ "answer" : "\(startDate)"])
            self.ansDynamicArray.append(["\(questionUniqueName)" : self.datePickerData])
            self.datePickerData.removeAll()
        }else{
            self.datePickerData.append([ "title" : "\((dateEditDataValue?[0]["title"])!)"])
            self.datePickerData.append([ "answer" : "\(startDate)"])
            self.ansDynamicArray.remove(at: self.dateFieldIndex )
            self.ansDynamicArray.insert(["\(questionUniqueName)" : self.datePickerData], at: self.dateFieldIndex)
            self.ansBoolValue.remove(at: self.dateFieldIndex )
            self.ansBoolValue.insert(true, at: self.dateFieldIndex)
            self.datePickerData.removeAll()
        }
        self.tableView.reloadData()
        dateEditDataValue?.removeAll()
        //touchedOutside()
    }
    @IBAction func touchedOutside() {
        self.dateBtn.alpha = 0
        self.dateView.alpha = 0
        self.newStartDatePicker.alpha = 0
    }
    
}

extension FormFillupViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            if dynamicArray.count > 0{
                let fullString = dynamicArray[indexPath.row].keys.first!
                var afterEqualsTo = ""
                if let index = fullString.range(of: "_", options: .backwards)?.upperBound {
                    afterEqualsTo = String(fullString.suffix(from: index))
                }
                if ("\(afterEqualsTo)" == "Text"){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView){
                        let cellTextField: FormFillupTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupTextFieldTableViewCell", for: indexPath) as! FormFillupTextFieldTableViewCell
                        var textDataValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        print((textDataValue?[0]["title"])! as! String)
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((textDataValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellTextField.textFieldTittleLbl.text = stringWithExtraSpace
                        cellTextField.textFieldTittleLbl.numberOfLines = 0
                        cellTextField.textFieldTittleLbl.adjustsFontSizeToFitWidth = true
                        cellTextField.textFieldTittleLbl.sizeToFit()
                        for i in 0 ..< ansDynamicArray.count{
                            let ansFullString = ansDynamicArray[i].keys.first!
                            if(ansFullString == fullString){
                                var ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                cellTextField.textField.text = (ansDataValue?[1]["answer"])! as? String
                                ansDataValue?.removeAll()
                            }else{
                                cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
                            }
                            
                        }
    //                    var ansValue = ansDynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
    //                    if (ansValue?[1]["answer"] as! String == ""){
    //                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    }else{
    //                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    }
                        textDataValue?.removeAll()
                        cellTextField.textField.tag = indexPath.row
                        cellTextField.didSaveText = { [weak self] tag in
                            var textEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.textFieldIndex = 0
                            self?.textFieldIndex = indexPath.row
                            self?.textFieldData.append([ "title" : "\((textEditDataValue?[0]["title"])!)"])
                            self?.textFieldData.append([ "answer" : "\((cellTextField.textField.text)!)"])
//                            self?.ansDynamicArray.remove(at: self!.textFieldIndex )
//                            self?.ansDynamicArray.insert(["\(fullString)" : self!.textFieldData], at: self!.textFieldIndex)
                            self?.ansDynamicArray.append(["\(fullString)" : self!.textFieldData])
                            self?.textFieldData.removeAll()
                            textEditDataValue?.removeAll()
                        }
                        return cellTextField

                    }else{
                        let cellTextField: FormFillupTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupTextFieldTableViewCell", for: indexPath) as! FormFillupTextFieldTableViewCell
                        var textDataValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        print((textDataValue?[0]["title"])! as! String)
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((textDataValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellTextField.textFieldTittleLbl.text = stringWithExtraSpace
                        cellTextField.textFieldTittleLbl.numberOfLines = 0
                        cellTextField.textFieldTittleLbl.adjustsFontSizeToFitWidth = true
                        cellTextField.textFieldTittleLbl.sizeToFit()
                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    var ansValue = ansDynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
    //                    if (ansValue?[1]["answer"] as! String == ""){
    //                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    }else{
    //                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    }
                        textDataValue?.removeAll()
                        cellTextField.textField.tag = indexPath.row
                        cellTextField.didSaveText = { [weak self] tag in
                            var textEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.textFieldIndex = 0
                            self?.textFieldIndex = indexPath.row
                            self?.textFieldData.append([ "title" : "\((textEditDataValue?[0]["title"])!)"])
                            self?.textFieldData.append([ "answer" : "\((cellTextField.textField.text)!)"])
                            self?.ansDynamicArray.remove(at: self!.textFieldIndex )
                            self?.ansDynamicArray.insert(["\(fullString)" : self!.textFieldData], at: self!.textFieldIndex)
                            self?.ansBoolValue.remove(at: self!.textFieldIndex )
                            self?.ansBoolValue.insert(true, at: self!.textFieldIndex)
                            self?.textFieldData.removeAll()
                            textEditDataValue?.removeAll()
                            self?.tableView.reloadData()
                        }
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == fullString){
                                    ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                }
                                
                            }
                            cellTextField.textField.text = (ansDataValue?[1]["answer"])! as? String
                            ansDataValue?.removeAll()
                        }else{
                            
                        }
                        return cellTextField
                    }
                }
                else if("\(afterEqualsTo)" == "File"){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView){
                        let cellFile: FormFillupUploadFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupUploadFileTableViewCell", for: indexPath) as! FormFillupUploadFileTableViewCell
                        cellFile.fileUploadBtn.tag = indexPath.row + 1
                        var fileUploadValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        for i in 0 ..< ansDynamicArray.count{
                            let ansFullString = ansDynamicArray[i].keys.first!
                            if(ansFullString == fullString){
                                var ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                cellFile.chooseFileTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                                ansDataValue?.removeAll()
                            }
                            
                        }
                        cellFile.uploadFileMaxSizeLbl.text = "Maximum Size \((fileUploadValue?[2]["fileSize"])! as! String)MB"
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((fileUploadValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellFile.uploadFileTittleLbl.text = stringWithExtraSpace
                        cellFile.chooseFileTextLbl.textColor = UIColor.red
                        cellFile.uploadFileTittleLbl.numberOfLines = 0
                        cellFile.uploadFileTittleLbl.adjustsFontSizeToFitWidth = true
                        cellFile.uploadFileTittleLbl.sizeToFit()
                        fileUploadValue?.removeAll()
                        
                        if (appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView){
                            cellFile.didUpload = { [weak self] tag in
                                var fileUploadValueForOpen = self!.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                appDelegate.pdfFileUrl =  fileUploadValueForOpen?[0]["title"] as? String
                                self?.shareUrl = fileUploadValueForOpen?[0]["title"] as! String
                                fileUploadValueForOpen?.removeAll()
                                self?.fileOpen()
                            }
                        }else{
                            cellFile.didUpload = { [weak self] tag in
                                var filePathValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                self!.questionUniqueName = "\(fullString)"
                                if (((filePathValue?[1]["fileType"])) as! String == "Image"){
                                    self?.filePathText = ((filePathValue?[0]["title"])) as! String
                                    self!.fileIndex = indexPath.row
                                    self?.fileArrayIndex = 0
                                    self?.fileArrayIndex = indexPath.row
                                    //self?.filePathCreate()
                                    print("true")
                                    self?.chooseImage()
                                    filePathValue?.removeAll()
                                }else{
                                    self?.filePathText = ((filePathValue?[0]["title"])) as! String
                                    self!.fileIndex = indexPath.row
                                    self?.fileArrayIndex = 0
                                    self?.fileArrayIndex = indexPath.row
                                    //self?.filePathCreate()
                                    self?.filePathCreate2()
                                    filePathValue?.removeAll()
                                    //self?.tableView.reloadData()
                                }
                            }
                            
                            cellFile.tableView.tag = indexPath.row
                            cellFile.didUpdate = { [weak self] tag in
                                self!.questionUniqueName = "\(fullString)"
                                var filePathValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                self?.filePathText = ((filePathValue?[0]["title"])) as! String
                                self?.fileIndex = 0
                                self?.fileIndex = indexPath.row
                                self?.multipleImageIndex = cellFile.indexValue
                                self?.multipleImageStoreIndex = cellFile.storeIndex
                                print(self?.multipleImageIndex)
                                filePathValue?.removeAll()
                                self?.chooseImage()
                                
                            }
                            
                            
                            var fileUploadValue = self.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            if ((fileUploadValue?[1]["fileType"])! as! String == "Image"){
                                // This is for edit own form image
                                if ((fileUploadValue?[3]["accecptableFile"])! as! String == "Single"){
                                    // This is for edit own form single image
                                    if ansBoolValue[indexPath.row] == true{
                                        LoadingIndicatorView.show()
                                        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                                        indicator.color = UIColor.orange
                                        indicator.translatesAutoresizingMaskIntoConstraints = false
                                        indicator.startAnimating()
                                        cellFile.uploadImageView.addSubview(indicator)
                                        
                                        indicator.centerXAnchor.constraint(equalTo:  cellFile.uploadImageView.centerXAnchor).isActive = true
                                        indicator.centerYAnchor.constraint(equalTo:  cellFile.uploadImageView.centerYAnchor).isActive = true
                                        let islandRef = self.storageRef.child(appDelegate.uniqueID!).child(splitUrl).child(fileUploadValue![0]["title"] as! String).child("File.pdf")
                                        islandRef.getData(maxSize: (10 * 1024 * 1024)) { (data, error) in
                                                if let err = error {
                                                   print(err)
                                              } else {
                                                if let image  = data {
                                                    let seconds = 1.0
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                        let image1 = UIImage(data: data!)
                                                        cellFile.cellImageView.image = image1!
                                                        cellFile.cellImageView.contentMode = .scaleAspectFill
                                                        indicator.removeFromSuperview()
                                                    }
                                                     // Use Image
                                                }
                                             }
                                        }
                                        LoadingIndicatorView.hide()
                                        cellFile.uploadFileBorderView.frame.size.height = CGFloat(180)
                                        cellFile.uploadFileBigView.frame.size.height = CGFloat(180)
                                        cellFile.uploadFileBigView2.frame.size.height = CGFloat(180)
                                        cellFile.tableView.frame.size.height = CGFloat(180)
                                        cellFile.uploadFileMaxSizeLbl.frame = CGRect(x: 17, y: 150, width: 300, height: 20)
                                        cellFile.tableView.alpha = 0
                                        cellFile.uploadImageView.alpha = 1
                                        cellFile.uploadFileView.alpha = 0
                                        cellFile.chooseFileTextLbl.text = "Image"
                                        cellFile.chooseFileTextLbl.textColor = UIColor.red
                                        cellFile.fileDeleteBtn.alpha = 1
                                    }else{
                                        cellFile.uploadFileBorderView.frame.size.height = CGFloat(180)
                                        cellFile.uploadFileBigView.frame.size.height = CGFloat(180)
                                        cellFile.uploadFileBigView2.frame.size.height = CGFloat(180)
                                        cellFile.tableView.frame.size.height = CGFloat(180)
                                        cellFile.uploadFileMaxSizeLbl.frame = CGRect(x: 17, y: 150, width: 300, height: 20)
                                        cellFile.tableView.alpha = 0
                                        cellFile.uploadImageView.alpha = 0
                                        cellFile.uploadFileView.alpha = 1
                                        cellFile.chooseFileTextLbl.text = "Choose a file"
                                        cellFile.chooseFileTextLbl.textColor = UIColor.black
                                        cellFile.fileDeleteBtn.alpha = 0
                                    }
                                }else{
                                    // This is for edit own form Multiple image
                                    if ansBoolValue[indexPath.row] == true{
                                        appDelegate.hasImageValue = true
                                        var ansDataValue : [[String:Any]]?
                                        var ansDataOptionValue : [String]?
                                        for i in 0 ..< ansDynamicArray.count{
                                            let ansFullString = ansDynamicArray[i].keys.first!
                                            if(ansFullString == fullString){
                                                ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                                ansDataOptionValue = ansDataValue![1]["answer"]! as? [String]
                                            }
                                            
                                        }
                                        appDelegate.multiplePhotoStoreIndex = ansDataOptionValue!
                                        cellFile.uploadFileBorderView.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                        cellFile.uploadFileBigView.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                        cellFile.uploadFileBigView2.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                        cellFile.tableView.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                        cellFile.uploadFileMaxSizeLbl.frame = CGRect(x: 17, y: 150 + (130 * ansDataOptionValue!.count), width: 300, height: 20)
                                        ansDataValue?.removeAll()
                                        ansDataOptionValue?.removeAll()
                                        cellFile.loadData()
                                        cellFile.tableView.reloadData()
                                        cellFile.tableView.alpha = 1
                                        cellFile.uploadImageView.alpha = 0
                                        cellFile.uploadFileView.alpha = 0
                                        
                                    }else{
                                        cellFile.tableView.alpha = 1
                                        cellFile.uploadImageView.alpha = 0
                                        cellFile.uploadFileView.alpha = 0
                                    }
                                }
                                
                            }else{
                                // This is for edit own form File
                                if ansBoolValue[indexPath.row] == true{
                                    cellFile.uploadImageView.alpha = 0
                                    cellFile.uploadFileView.alpha = 1
                                    var ansDataValue : [[String:Any]]?
                                    for i in 0 ..< ansDynamicArray.count{
                                        let ansFullString = ansDynamicArray[i].keys.first!
                                        if(ansFullString == fullString){
                                            ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                        }
                                        
                                    }
                                    cellFile.chooseFileTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                                    cellFile.chooseFileTextLbl.textColor = UIColor.red
                                    cellFile.fileDeleteBtn.alpha = 1
                                    ansDataValue?.removeAll()
                                }else{
                                    cellFile.uploadImageView.alpha = 0
                                    cellFile.uploadFileView.alpha = 1
                                    cellFile.chooseFileTextLbl.text = "Choose a file"
                                    cellFile.chooseFileTextLbl.textColor = UIColor.black
                                    cellFile.fileDeleteBtn.alpha = 0
                                }
                            }
                            
                            fileUploadValue?.removeAll()
                        }
                        
                        return cellFile
                    }else{
                        let cellFile: FormFillupUploadFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupUploadFileTableViewCell", for: indexPath) as! FormFillupUploadFileTableViewCell
                        cellFile.fileUploadBtn.tag = indexPath.row + 1
                        cellFile.fileDeleteBtn.tag = indexPath.row + 1
                        cellFile.imageDeleteBtn.tag = indexPath.row + 1
                        cellFile.imageReplaceBtn.tag = indexPath.row + 1
                        var fileUploadValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        cellFile.uploadFileMaxSizeLbl.text = "Maximum Size \((fileUploadValue?[2]["fileSize"])! as! String)MB"
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((fileUploadValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellFile.uploadFileTittleLbl.text = stringWithExtraSpace
                        cellFile.uploadFileTittleLbl.numberOfLines = 1
                        cellFile.uploadFileTittleLbl.adjustsFontSizeToFitWidth = true
                        cellFile.uploadFileTittleLbl.sizeToFit()
                        cellFile.uploadImageView.alpha = 0
                        
                        cellFile.didUpload = { [weak self] tag in
                            
                            var filePathValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self!.questionUniqueName = "\(fullString)"
                            if (((filePathValue?[1]["fileType"])) as! String == "Image"){
                                if ((filePathValue?[3]["accecptableFile"])! as! String == "Single"){
                                    self?.filePathText = ((filePathValue?[0]["title"])) as! String
                                    self!.fileIndex = indexPath.row
                                    self?.fileArrayIndex = 0
                                    self?.fileArrayIndex = indexPath.row
                                    //self?.filePathCreate()
                                    print("true")
                                    filePathValue?.removeAll()
                                    self?.chooseImage()
                                }else{
                                    
                                }
                            }else{
                                self?.filePathText = ((filePathValue?[0]["title"])) as! String
                                self!.fileIndex = indexPath.row
                                self?.fileArrayIndex = 0
                                self?.fileArrayIndex = indexPath.row
                                //self?.filePathCreate()
                                self?.filePathCreate2()
                                filePathValue?.removeAll()
                            }
                        }
                        cellFile.didDelete = { [weak self] tag in
                            self!.fileIndex = 0
                            self!.fileIndex = indexPath.row
                            self?.ansDynamicArray.remove(at: self!.fileIndex)
                            self?.ansDynamicArray.insert(["" : ""], at: self!.fileIndex)
                            self?.ansBoolValue[indexPath.row] = false
                            tableView.reloadData()
                        }
                        
                        cellFile.didImageDelete = { [weak self] tag in
                            self!.fileIndex = 0
                            self!.fileIndex = indexPath.row
                            self?.ansDynamicArray.remove(at: self!.fileIndex)
                            self?.ansDynamicArray.insert(["" : ""], at: self!.fileIndex)
                            self?.ansBoolValue[indexPath.row] = false
                            tableView.reloadData()
                        }
                        cellFile.didImageReplace = { [weak self] tag in
                            self!.questionUniqueName = "\(fullString)"
                            self!.fileIndex = indexPath.row
                            self?.fileArrayIndex = 0
                            self?.fileArrayIndex = indexPath.row
                            //self?.filePathCreate()
                            print("true")
                            self?.chooseImage()
                        }
                        
                        cellFile.tableView.tag = indexPath.row
                        cellFile.didUpdate = { [weak self] tag in
                            self!.questionUniqueName = "\(fullString)"
                            var filePathValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.filePathText = ((filePathValue?[0]["title"])) as! String
                            self?.fileIndex = 0
                            self?.fileIndex = indexPath.row
                            self?.multipleImageIndex = cellFile.indexValue
                            self?.multipleImageStoreIndex = cellFile.storeIndex
                            print(self?.multipleImageIndex)
                            filePathValue?.removeAll()
                            self?.chooseImage()
                            
                        }
                        
                        print(ansDynamicArray)
                        print(ansBoolValue)
                        
                        if ((fileUploadValue?[1]["fileType"])! as! String == "Image"){
                            if ((fileUploadValue?[3]["accecptableFile"])! as! String == "Single"){
                                if ansBoolValue[indexPath.row] == true{
                                    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                                    indicator.color = UIColor.orange
                                    indicator.translatesAutoresizingMaskIntoConstraints = false
                                    indicator.startAnimating()
                                    cellFile.uploadImageView.addSubview(indicator)
                                    
                                    indicator.centerXAnchor.constraint(equalTo:  cellFile.uploadImageView.centerXAnchor).isActive = true
                                    indicator.centerYAnchor.constraint(equalTo:  cellFile.uploadImageView.centerYAnchor).isActive = true
                                   
                                    let islandRef = self.storageRef.child(appDelegate.uniqueID!).child(splitUrl).child(fileUploadValue![0]["title"] as! String).child("File.pdf")
                                    islandRef.getData(maxSize: (10 * 1024 * 1024)) { (data, error) in
                                            if let err = error {
                                               print(err)
                                          } else {
                                            if let image  = data {
                                                let seconds = 1.0
                                                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                    let image1 = UIImage(data: data!)
                                                    cellFile.cellImageView.image = image1!
                                                    cellFile.cellImageView.contentMode = .scaleAspectFill
                                                    indicator.removeFromSuperview()
                                                }
                                                 // Use Image
                                            }
                                         }
                                    }
                                    LoadingIndicatorView.hide()
                                    cellFile.uploadFileBorderView.frame.size.height = CGFloat(180)
                                    cellFile.uploadFileBigView.frame.size.height = CGFloat(180)
                                    cellFile.uploadFileBigView2.frame.size.height = CGFloat(180)
                                    cellFile.tableView.frame.size.height = CGFloat(180)
                                    cellFile.uploadFileMaxSizeLbl.frame = CGRect(x: 17, y: 150, width: 300, height: 20)
                                    cellFile.tableView.alpha = 0
                                    cellFile.uploadImageView.alpha = 1
                                    cellFile.uploadFileView.alpha = 0
                                    cellFile.chooseFileTextLbl.text = "Image"
                                    cellFile.chooseFileTextLbl.textColor = UIColor.red
                                    cellFile.fileDeleteBtn.alpha = 1
                                }else{
                                    cellFile.uploadFileBorderView.frame.size.height = CGFloat(180)
                                    cellFile.uploadFileBigView.frame.size.height = CGFloat(180)
                                    cellFile.uploadFileBigView2.frame.size.height = CGFloat(180)
                                    cellFile.tableView.frame.size.height = CGFloat(180)
                                    cellFile.uploadFileMaxSizeLbl.frame = CGRect(x: 17, y: 150, width: 300, height: 20)
                                    cellFile.tableView.alpha = 0
                                    cellFile.uploadImageView.alpha = 0
                                    cellFile.uploadFileView.alpha = 1
                                    cellFile.chooseFileTextLbl.text = "Choose a file"
                                    cellFile.chooseFileTextLbl.textColor = UIColor.black
                                    cellFile.fileDeleteBtn.alpha = 0
                                }
                            }else{
                                if ansBoolValue[indexPath.row] == true{
                                    appDelegate.hasImageValue = true
//                                    var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                    var ansDataValue : [[String:Any]]?
                                    for i in 0 ..< ansDynamicArray.count{
                                        let ansFullString = ansDynamicArray[i].keys.first!
                                        if(ansFullString == fullString){
                                            ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                        }
                                        
                                    }
                                    var ansDataOptionValue = ansDataValue![1]["answer"]! as? [String]
                                    appDelegate.multiplePhotoStoreIndex = ansDataOptionValue!
                                    cellFile.uploadFileBorderView.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                    cellFile.uploadFileBigView.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                    cellFile.uploadFileBigView2.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                    cellFile.tableView.frame.size.height = CGFloat(180 + (140 * ansDataOptionValue!.count))
                                    cellFile.uploadFileMaxSizeLbl.frame = CGRect(x: 17, y: 150 + (130 * ansDataOptionValue!.count), width: 300, height: 20)
                                    ansDataValue?.removeAll()
                                    ansDataOptionValue?.removeAll()
                                    cellFile.loadData()
                                    cellFile.tableView.reloadData()
                                    cellFile.tableView.alpha = 1
                                    cellFile.uploadImageView.alpha = 0
                                    cellFile.uploadFileView.alpha = 0
                                    
                                }else{
                                    cellFile.tableView.alpha = 1
                                    cellFile.uploadImageView.alpha = 0
                                    cellFile.uploadFileView.alpha = 0
                                }
                            }
                            
                        }else{
                            if ansBoolValue[indexPath.row] == true{
                                cellFile.uploadFileBorderView.frame.size.height = CGFloat(180)
                                cellFile.uploadFileBigView.frame.size.height = CGFloat(180)
                                cellFile.uploadFileBigView2.frame.size.height = CGFloat(180)
                                cellFile.uploadImageView.alpha = 0
                                cellFile.uploadFileView.alpha = 1
                                cellFile.tableView.alpha = 0
//                                var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                var ansDataValue : [[String:Any]]?
                                for i in 0 ..< ansDynamicArray.count{
                                    let ansFullString = ansDynamicArray[i].keys.first!
                                    if(ansFullString == fullString){
                                        ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                    }
                                    
                                }
                                cellFile.chooseFileTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                                cellFile.chooseFileTextLbl.textColor = UIColor.red
                                cellFile.fileDeleteBtn.alpha = 1
                                ansDataValue?.removeAll()
                            }else{
                                cellFile.uploadFileBorderView.frame.size.height = CGFloat(180)
                                cellFile.uploadFileBigView.frame.size.height = CGFloat(180)
                                cellFile.uploadFileBigView2.frame.size.height = CGFloat(180)
                                cellFile.tableView.alpha = 0
                                cellFile.uploadImageView.alpha = 0
                                cellFile.uploadFileView.alpha = 1
                                cellFile.chooseFileTextLbl.text = "Choose a file"
                                cellFile.chooseFileTextLbl.textColor = UIColor.black
                                cellFile.fileDeleteBtn.alpha = 0
                            }
                        }
                        
                        fileUploadValue?.removeAll()
                        return cellFile
                    }
                }
                else if("\(afterEqualsTo)" == "Date"){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellDatepicker: FormFillupDatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupDatePickerTableViewCell", for: indexPath) as! FormFillupDatePickerTableViewCell
                        var datePickerValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var ansDataValue : [[String:Any]]?
                        for i in 0 ..< ansDynamicArray.count{
                            let ansFullString = ansDynamicArray[i].keys.first!
                            if(ansFullString == fullString){
                                ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                            }
                            
                        }
                        cellDatepicker.dateTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((datePickerValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDatepicker.datePickerTittleLbl.text = stringWithExtraSpace
                        cellDatepicker.datePickerTittleLbl.numberOfLines = 0
                        cellDatepicker.datePickerTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDatepicker.datePickerTittleLbl.sizeToFit()
                        ansDataValue?.removeAll()
                        datePickerValue?.removeAll()
                        cellDatepicker.datePickerBtn.tag = indexPath.row + 1
                        cellDatepicker.didUpdate = { [weak self] tag in
                            self?.dateFieldIndex = indexPath.row
                            self?.dateBtn.alpha = 1
                            self?.dateView.alpha = 1
                            self?.newStartDatePicker.alpha = 1
                            self?.dateView.frame.size.height = (self?.newStartDatePicker.frame.size.height)!
                            self?.dateView.center = (self?.mainView.center)!
                            self?.dateView.addSubview(self!.newStartDatePicker)
                        }
                        
                        return cellDatepicker
                    }else{
                        let cellDatepicker: FormFillupDatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupDatePickerTableViewCell", for: indexPath) as! FormFillupDatePickerTableViewCell
                        var datePickerValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((datePickerValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDatepicker.datePickerTittleLbl.text = stringWithExtraSpace
                        cellDatepicker.datePickerTittleLbl.numberOfLines = 0
                        cellDatepicker.datePickerTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDatepicker.datePickerTittleLbl.sizeToFit()
                        cellDatepicker.datePickerBtn.tag = indexPath.row + 1
                        cellDatepicker.didUpdate = { [weak self] tag in
                            self!.questionUniqueName = "\(fullString)"
                            self?.dateFieldIndex = indexPath.row
                            self?.dateBtn.alpha = 1
                            self?.dateView.alpha = 1
                            self?.newStartDatePicker.alpha = 1
                            self?.dateView.frame.size.height = (self?.newStartDatePicker.frame.size.height)!
                            self?.dateView.center = (self?.mainView.center)!
                            self?.dateView.addSubview(self!.newStartDatePicker)
                        }
                        
                        
                        if ansBoolValue[indexPath.row] == true{
//                            var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == fullString){
                                    ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                }
                                
                            }
                            cellDatepicker.dateTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                            ansDataValue?.removeAll()
                        }else{
                            cellDatepicker.dateTextLbl.text = (datePickerValue?[1]["dateFormat"])! as? String
                        }
                        datePickerValue?.removeAll()
                        return cellDatepicker
                    }
                }
                else if("\(afterEqualsTo)" == "Dropdown"){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellDropdown: FormFillupDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupDropdownTableViewCell", for: indexPath) as! FormFillupDropdownTableViewCell
                        cellDropdown.dropDownBtn.tag = indexPath.row + 1
                        var dropdownValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var ansDataValue : [[String:Any]]?
                        for i in 0 ..< ansDynamicArray.count{
                            let ansFullString = ansDynamicArray[i].keys.first!
                            if(ansFullString == fullString){
                                ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                            }
                            
                        }
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((dropdownValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDropdown.dropDownTittleLbl.text = stringWithExtraSpace
                        cellDropdown.dropDownTittleLbl.numberOfLines = 0
                        cellDropdown.dropDownTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDropdown.dropDownTittleLbl.sizeToFit()
                        let dropdownOptionValue = dropdownValue![1]["option"]! as? [String]
                        cellDropdown.dropDownOptionTextLbl.text = (ansDataValue?[1]["answer"])! as? String
    //                    dropdownOptionDropdown.anchorView = cellDropdown.dropdownOptionView
    //                    dropdownOptionDropdown.dataSource = dropdownOptionValue!
    //                    dropdownOptionDropdown.direction = .bottom
                    
                        cellDropdown.didOption = { [weak self] tag in
                            self!.questionUniqueName = "\(fullString)"
                            cellDropdown.dropdownOptionDropdown.show()
                            cellDropdown.dropdownOptionDropdown.dataSource = dropdownOptionValue!
                            cellDropdown.dropdownOptionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                              print("Selected item: \(item) at index: \(index)")
                                cellDropdown.dropDownOptionTextLbl.text = dropdownOptionValue![index]
                                var dropdownEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                self?.dropdownFieldIndex = 0
                                self?.dropdownFieldIndex = indexPath.row
    //                            self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
    //                            self?.ansDynamicArray.insert(["\((dropdownEditDataValue?[0]["tittle"])!)" : "\((dropdownOptionValue![index]))"], at: self!.dropdownFieldIndex)
                                self?.dropdownData.append([ "title" : "\((dropdownEditDataValue?[0]["title"])!)"])
                                self?.dropdownData.append([ "answer" : "\((dropdownOptionValue![index]))"])
//                                self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
//                                self?.ansDynamicArray.insert(["\(fullString)" : self!.dropdownData], at: self!.dropdownFieldIndex)
                                self?.ansDynamicArray.append(["\(fullString)" : self!.dropdownData])
                                self?.dropdownData.removeAll()
                                dropdownEditDataValue?.removeAll()
                                
                            }
                        }
                        ansDataValue?.removeAll()
                        dropdownValue?.removeAll()
                        return cellDropdown
                    }else{
                        let cellDropdown: FormFillupDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupDropdownTableViewCell", for: indexPath) as! FormFillupDropdownTableViewCell
                        cellDropdown.dropDownBtn.tag = indexPath.row + 1
                        var dropdownValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var hasData = false
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((dropdownValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDropdown.dropDownTittleLbl.text = stringWithExtraSpace
                        cellDropdown.dropDownTittleLbl.numberOfLines = 0
                        cellDropdown.dropDownTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDropdown.dropDownTittleLbl.sizeToFit()
                        let dropdownOptionValue = dropdownValue![1]["option"]! as? [String]
    //                    dropdownOptionDropdown.anchorView = cellDropdown.dropdownOptionView
    //                    dropdownOptionDropdown.dataSource = dropdownOptionValue!
    //                    dropdownOptionDropdown.direction = .bottom
                    
                        cellDropdown.didOption = { [weak self] tag in
                            self!.questionUniqueName = "\(fullString)"
                            cellDropdown.dropdownOptionDropdown.show()
                            cellDropdown.dropdownOptionDropdown.dataSource = dropdownOptionValue!
                            cellDropdown.dropdownOptionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                              print("Selected item: \(item) at index: \(index)")
                                cellDropdown.dropDownOptionTextLbl.text = dropdownOptionValue![index]
                                var dropdownEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                                self?.dropdownFieldIndex = 0
                                self?.dropdownFieldIndex = indexPath.row
    //                            self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
    //                            self?.ansDynamicArray.insert(["\((dropdownEditDataValue?[0]["tittle"])!)" : "\((dropdownOptionValue![index]))"], at: self!.dropdownFieldIndex)
                                self?.dropdownData.append([ "title" : "\((dropdownEditDataValue?[0]["title"])!)"])
                                self?.dropdownData.append([ "answer" : "\((dropdownOptionValue![index]))"])
                                self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
                                self?.ansDynamicArray.insert(["\(fullString)" : self!.dropdownData], at: self!.dropdownFieldIndex)
                                self?.ansBoolValue.remove(at: self!.dropdownFieldIndex )
                                self?.ansBoolValue.insert(true, at: self!.dropdownFieldIndex)
                                self?.tableView.reloadData()
                                self?.dropdownData.removeAll()
                                dropdownEditDataValue?.removeAll()
                                
                            }
                        }
                        
                        if ansBoolValue[indexPath.row] == true{
//                            var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == fullString){
                                    ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                }
                                
                            }
                            cellDropdown.dropDownOptionTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                            hasData = false
                            ansDataValue?.removeAll()
                        }else{
                            
                        }
                        
                        dropdownValue?.removeAll()
                        return cellDropdown
                    }
                }
                
                else if("\(afterEqualsTo)" == "SingleChoice"){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellSingleChoice: FormFillupSingleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupSingleChoiceTableViewCell", for: indexPath) as! FormFillupSingleChoiceTableViewCell
                        appDelegate.formBuilderSingleChoice = []
                        var singleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
//                        var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var ansDataValue : [[String:Any]]?
                        for i in 0 ..< ansDynamicArray.count{
                            let ansFullString = ansDynamicArray[i].keys.first!
                            if(ansFullString == fullString){
                                ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                            }
                            
                        }
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((singleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellSingleChoice.singleChoiceTittleLbl.text = stringWithExtraSpace
                        cellSingleChoice.singleChoiceTittleLbl.numberOfLines = 0
                        cellSingleChoice.singleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
                        cellSingleChoice.singleChoiceTittleLbl.sizeToFit()
                        var singleChoiceOptionValue = singleChoiceValue![1]["option"]! as? [String]
                        var ansDataOptionValue = ansDataValue![1]["answer"]! as? String
                        appDelegate.formBuilderSingleChoice = singleChoiceOptionValue!
                        appDelegate.singleChoiceAnsIndex = Int(ansDataOptionValue!)!
                        cellSingleChoice.loadDataForShow()
                        print(singleChoiceOptionValue!)
                        cellSingleChoice.singleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        cellSingleChoice.singleChoiceBigView.frame.size.height = CGFloat(40 + (50 * singleChoiceOptionValue!.count))
                        cellSingleChoice.singleChoiceSmallView.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        singleChoiceOptionValue?.removeAll()
                        singleChoiceValue?.removeAll()
                        ansDataValue?.removeAll()
                        cellSingleChoice.tableView.tag = indexPath.row
                        cellSingleChoice.didUpdate = { [weak self] tag in
                            var singleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.singleChoiceIndex = 0
                            self?.singleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((singleChoiceEditDataValue?[0]["tittle"])!)" : "\(cellSingleChoice.index)"], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.append([ "title" : "\((singleChoiceEditDataValue?[0]["title"])!)"])
                            self?.singleChoiceData.append([ "answer" : "\(cellSingleChoice.index)"])
//                            self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
//                            self?.ansDynamicArray.insert(["\(fullString)" : self!.singleChoiceData], at: self!.singleChoiceIndex)
                            self?.ansDynamicArray.append(["\(fullString)" : self!.singleChoiceData])
                            self?.singleChoiceData.removeAll()
                            
                            print(cellSingleChoice.index)
                            singleChoiceEditDataValue?.removeAll()
                        }
                        
                        return cellSingleChoice
                    }else{
                        let cellSingleChoice: FormFillupSingleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupSingleChoiceTableViewCell", for: indexPath) as! FormFillupSingleChoiceTableViewCell
                        appDelegate.formBuilderSingleChoice = []
                        var singleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var hasData = false
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((singleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellSingleChoice.singleChoiceTittleLbl.text = stringWithExtraSpace
                        cellSingleChoice.singleChoiceTittleLbl.numberOfLines = 0
                        cellSingleChoice.singleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
                        cellSingleChoice.singleChoiceTittleLbl.sizeToFit()
                        var singleChoiceOptionValue = singleChoiceValue![1]["option"]! as? [String]
                        appDelegate.formBuilderSingleChoice = singleChoiceOptionValue!
                        cellSingleChoice.loadData()
                        print(singleChoiceOptionValue!)
                        cellSingleChoice.singleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        cellSingleChoice.singleChoiceBigView.frame.size.height = CGFloat(40 + (50 * singleChoiceOptionValue!.count))
                        cellSingleChoice.singleChoiceSmallView.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        singleChoiceOptionValue?.removeAll()
                        singleChoiceValue?.removeAll()
                        cellSingleChoice.tableView.tag = indexPath.row
                        cellSingleChoice.didUpdate = { [weak self] tag in
                            var singleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.singleChoiceIndex = 0
                            self?.singleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((singleChoiceEditDataValue?[0]["tittle"])!)" : "\(cellSingleChoice.index)"], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.append([ "title" : "\((singleChoiceEditDataValue?[0]["title"])!)"])
                            self?.singleChoiceData.append([ "answer" : "\(cellSingleChoice.index)"])
                            self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
                            self?.ansDynamicArray.insert(["\(fullString)" : self!.singleChoiceData], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.removeAll()
                            self?.ansBoolValue.remove(at: self!.singleChoiceIndex )
                            self?.ansBoolValue.insert(true, at: self!.singleChoiceIndex)
                            print(cellSingleChoice.index)
                            singleChoiceEditDataValue?.removeAll()
                            self?.tableView.reloadData()
                        }
                        
                        if ansBoolValue[indexPath.row] == true{
//                            var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == fullString){
                                    ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                }
                                
                            }
                            var ansDataOptionValue = ansDataValue![1]["answer"]! as? String
                            appDelegate.singleChoiceAnsIndex = Int(ansDataOptionValue!)!
                            hasData = false
                            ansDataValue?.removeAll()
                        }else{
                            
                        }

                        return cellSingleChoice
                    }
                }
                
                else if("\(afterEqualsTo)" == "MultipleChoice"){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellMultipleChoice: FormFillupMultipleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupMultipleChoiceTableViewCell", for: indexPath) as! FormFillupMultipleChoiceTableViewCell
                        appDelegate.formBuilderMultipleChoice = []
                        var multipleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
//                        var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var ansDataValue : [[String:Any]]?
                        for i in 0 ..< ansDynamicArray.count{
                            let ansFullString = ansDynamicArray[i].keys.first!
                            if(ansFullString == fullString){
                                ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                            }
                            
                        }
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((multipleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellMultipleChoice.multipleChoiceTittleLbl.text = stringWithExtraSpace
                        cellMultipleChoice.multipleChoiceTittleLbl.numberOfLines = 0
                        cellMultipleChoice.multipleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
                        cellMultipleChoice.multipleChoiceTittleLbl.sizeToFit()
                        var multipleChoiceOptionValue = multipleChoiceValue![1]["option"]! as? [String]
                        var ansDataOptionValue = ansDataValue![1]["answer"]! as? [Int]
                        appDelegate.formBuilderMultipleChoice = multipleChoiceOptionValue!
                        appDelegate.multipleChoiceStoreIndex = ansDataOptionValue!
                        cellMultipleChoice.loadDataForShow()
                        print(multipleChoiceOptionValue!)
                        cellMultipleChoice.multipleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.multipleChoiceBigView.frame.size.height = CGFloat(40 + (50 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.multipleChoiceSmallView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        multipleChoiceOptionValue?.removeAll()
                        multipleChoiceValue?.removeAll()
                        ansDataValue?.removeAll()
                        ansDataOptionValue?.removeAll()
                        cellMultipleChoice.tableView.tag = indexPath.row
                        cellMultipleChoice.didUpdate = { [weak self] tag in
                            var multipleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.multipleChoiceIndex = 0
                            self?.multipleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((multipleChoiceEditDataValue?[0]["tittle"])!)" : cellMultipleChoice.storeIndex], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.append([ "title" : "\((multipleChoiceEditDataValue?[0]["title"])!)"])
                            self?.multipleChoiceData.append([ "answer" : cellMultipleChoice.storeIndex])
//                            self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
//                            self?.ansDynamicArray.insert(["\(fullString)" : self!.multipleChoiceData], at: self!.multipleChoiceIndex)
                            self?.ansDynamicArray.append(["\(fullString)" : self!.multipleChoiceData])
                            self?.multipleChoiceData.removeAll()
                            print(cellMultipleChoice.index)
                            multipleChoiceEditDataValue?.removeAll()
                        }
                        
                        return cellMultipleChoice
                    }else{
                        let cellMultipleChoice: FormFillupMultipleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupMultipleChoiceTableViewCell", for: indexPath) as! FormFillupMultipleChoiceTableViewCell
                        appDelegate.formBuilderMultipleChoice = []
                        var multipleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        var hasData = false
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((multipleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellMultipleChoice.multipleChoiceTittleLbl.text = stringWithExtraSpace
                        cellMultipleChoice.multipleChoiceTittleLbl.numberOfLines = 0
                        cellMultipleChoice.multipleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
                        cellMultipleChoice.multipleChoiceTittleLbl.sizeToFit()
                        var multipleChoiceOptionValue = multipleChoiceValue![1]["option"]! as? [String]
                        appDelegate.formBuilderMultipleChoice = multipleChoiceOptionValue!
                        cellMultipleChoice.loadData()
                        print(multipleChoiceOptionValue!)
                        cellMultipleChoice.multipleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.multipleChoiceBigView.frame.size.height = CGFloat(40 + (50 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.multipleChoiceSmallView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        multipleChoiceOptionValue?.removeAll()
                        multipleChoiceValue?.removeAll()
                        cellMultipleChoice.tableView.tag = indexPath.row
                        cellMultipleChoice.didUpdate = { [weak self] tag in
                            var multipleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.multipleChoiceIndex = 0
                            self?.multipleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((multipleChoiceEditDataValue?[0]["tittle"])!)" : cellMultipleChoice.storeIndex], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.append([ "title" : "\((multipleChoiceEditDataValue?[0]["title"])!)"])
                            self?.multipleChoiceData.append([ "answer" : cellMultipleChoice.storeIndex])
                            self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
                            self?.ansDynamicArray.insert(["\(fullString)" : self!.multipleChoiceData], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.removeAll()
                            print(cellMultipleChoice.index)
                            multipleChoiceEditDataValue?.removeAll()
                            self?.ansBoolValue.remove(at: self!.multipleChoiceIndex )
                            self?.ansBoolValue.insert(true, at: self!.multipleChoiceIndex)
                            self?.tableView.reloadData()
                            
                        }
                        if ansBoolValue[indexPath.row] == true{
//                            var ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == fullString){
                                    ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                }
                                
                            }
                            let ansDataOptionValue = ansDataValue![1]["answer"]! as? [Int]
                            appDelegate.multipleChoiceStoreIndex = ansDataOptionValue!
                            ansDataValue?.removeAll()
                            hasData = false
                        }else{
                            
                        }
                        
                        return cellMultipleChoice
                    }
                }
                else{
                    let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                    return cell
                }
            }else{
                let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                return cell
            }
            
        }else{
            let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            let fullString = dynamicArray[indexPath.row].keys.first!
            var afterEqualsTo = ""
            if let index = fullString.range(of: "_", options: .backwards)?.upperBound {
                afterEqualsTo = String(fullString.suffix(from: index))
            }
            if ("\(afterEqualsTo)" == "Text"){
                return 120
            }else if ("\(afterEqualsTo)" == "File"){
                let filePathValue = self.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                if ((filePathValue?[3]["accecptableFile"])! as! String == "Single"){
                    return 230
                }else if((filePathValue?[3]["accecptableFile"])! as! String == "Multiple"){
                    if(ansBoolValue[indexPath.row] == true){
                        
                        if (appDelegate.isFillupFormViewingView){
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == fullString){
                                    ansDataValue = ansDynamicArray[i]["\(fullString)"]! as? [[String:Any]]
                                }
                                
                            }
                            let ansDataOptionValue = ansDataValue![1]["answer"]! as? [String]
                            return CGFloat(230 + (140 * ansDataOptionValue!.count))
                        }else{
                            let ansDataValue = ansDynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            let ansDataOptionValue = ansDataValue![1]["answer"]! as? [String]
                            return CGFloat(230 + (140 * ansDataOptionValue!.count))
                        }
                        
                    }else{
                        return 230
                    }
                }else{
                    return 230
                }
                
            }else if ("\(afterEqualsTo)" == "Date"){
                return 120
                
            }else if ("\(afterEqualsTo)" == "Dropdown"){
                return 120
            }else if ("\(afterEqualsTo)" == "SingleChoice"){
                let singleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                let singleChoiceOptionValue = singleChoiceValue![1]["option"]! as? [String]
                return 80 + CGFloat(40 * singleChoiceOptionValue!.count)
            }else if ("\(afterEqualsTo)" == "MultipleChoice"){
                let multipleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                let multipleChoiceOptionValue = multipleChoiceValue![1]["option"]! as? [String]
                return 80 + CGFloat(40 * multipleChoiceOptionValue!.count)
            }else{
                return 120
            }
        }else{
            return 0
        }
    }
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func filePathCreate2(){
        let types = [UTType.pdf.identifier, UTType.text.identifier, UTType.rtf.identifier, UTType.spreadsheet.identifier] as [String]
            let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = true
            }

            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet

            present(importMenu, animated: true)
    }
    
    func filePathCreate(){
        let attachSheet = UIAlertController(title: nil, message: "File attaching", preferredStyle: .actionSheet)
                
                
                attachSheet.addAction(UIAlertAction(title: "File", style: .default,handler: { (action) in
                    //let supportedTypes: [UTType] = [UTType.png,UTType.jpeg, UTType.pdf]
                    //let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
                    let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
                    documentPicker.delegate = self
                    documentPicker.modalPresentationStyle = .formSheet
                    self.present(documentPicker, animated: true, completion: nil)
                }))
        
        attachSheet.addAction(UIAlertAction(title: "Dropbox", style: .default,handler: { (action) in
            //let supportedTypes: [UTType] = [UTType.png,UTType.jpeg, UTType.pdf]
            //let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
            let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }))
                
//                attachSheet.addAction(UIAlertAction(title: "Photo/Video", style: .default,handler: { (action) in
//                    self.chooseImage()
//                }))
                
                
        attachSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.tableView.reloadData()
        }))
                
                self.present(attachSheet, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
            guard let myURL = urls.first else {
                return
            }

            print("import result : \(myURL)")
            print(myURL.lastPathComponent)
            let filePathValue = self.dynamicArray[fileIndex]["File"]! as? [[String:Any]]
//            self.ansDynamicArray.remove(at: self.fileIndex )
//            self.ansDynamicArray.insert(["\((filePathValue?[0]["tittle"])!)" : "\(myURL.lastPathComponent)"], at: self.fileIndex)
            if (appDelegate.isFillupFormViewingView){
                self.fileUploadData.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                self.fileUploadData.append([ "answer" : "\(myURL.lastPathComponent)"])
                self.ansDynamicArray.append(["\(questionUniqueName)" : self.fileUploadData])
                self.fileUploadData.removeAll()
            }else{
                self.fileUploadData.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                self.fileUploadData.append([ "answer" : "\(myURL.lastPathComponent)"])
                self.ansDynamicArray.remove(at: self.fileIndex )
                self.ansDynamicArray.insert(["\(questionUniqueName)" : self.fileUploadData], at: self.fileIndex)
                self.fileUploadData.removeAll()
            }
            self.filePathUrl = myURL.lastPathComponent
            _ = Storage.storage().reference()
            let storage = Storage.storage()
            let localFile = URL(string: "\(myURL)")
            let storageRef = storage.reference().child(appDelegate.uniqueID!).child(splitUrl).child(self.filePathText).child("File.pdf")
            storageRef.putFile(from: localFile!, metadata: nil) { metadata, error in
                guard metadata != nil else{
                    print("error: \(String(describing: error?.localizedDescription))")
                    return
                }
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: "\(myURL)") {
                    do {
                        try fileManager.removeItem(at: localFile!)
                        print("success: move item\(myURL)")
                    }catch{
                        print("failed: move item\(myURL)")
                    }
                }
            }
            self.fileUrlArray.remove(at: self.fileIndex)
            self.fileUrlArray.insert(self.filePathUrl, at: self.fileIndex)
            self.ansBoolValue.remove(at: self.fileIndex)
            self.ansBoolValue.insert(true, at: self.fileIndex)
            self.tableView.reloadData()
        }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Canceled")
        }
    func chooseImage() {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            var filePathValue = self.dynamicArray[fileIndex]["\(questionUniqueName)"]! as? [[String:Any]]
            if((filePathValue?[3]["accecptableFile"])! as! String == "Single"){
                
                
                var selectedImageData = [String:String]()
                
                
                guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
                
                
                print(fileUrl.lastPathComponent)
                
                if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    selectedImageData["filename"] = fileUrl.lastPathComponent
                    selectedImageData["data"] = pickedImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
                    let storage = Storage.storage()
                    _ = URL(string: "\(fileUrl)")
                    let storageRef = storage.reference().child(appDelegate.uniqueID!).child(splitUrl).child(self.filePathText).child("File.pdf")
                    storageRef.putFile(from: fileUrl, metadata: nil) { metadata, error in
                        guard metadata != nil else{
                            print("error: \(String(describing: error?.localizedDescription))")
                            return
                        }
                        let fileManager = FileManager.default
                        if fileManager.fileExists(atPath: "\(fileUrl)") {
                            do {
                                try fileManager.removeItem(at: fileUrl)
                                print("success: move item\(fileUrl)")
                            }catch{
                                print("failed: move item\(fileUrl)")
                            }
                        }
                    }
                    
                    if (appDelegate.isFillupFormViewingView){
                        self.fileUploadData.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                        self.fileUploadData.append([ "answer" : "\(fileUrl.lastPathComponent)"])
                        self.ansDynamicArray.append(["\(questionUniqueName)" : self.fileUploadData])
                        self.ansBoolValue.remove(at: self.fileIndex)
                        self.ansBoolValue.insert(true, at: self.fileIndex)
                        filePathValue?.removeAll()
                        
                        let seconds = 2.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.tableView.reloadData()
                        }
                    }else{
                        self.fileUploadData.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                        self.fileUploadData.append([ "answer" : "\(fileUrl.lastPathComponent)"])
                        self.ansDynamicArray.remove(at: self.fileIndex )
                        self.ansDynamicArray.insert(["\(questionUniqueName)" : self.fileUploadData], at: self.fileIndex)
                        self.ansBoolValue.remove(at: self.fileIndex)
                        self.ansBoolValue.insert(true, at: self.fileIndex)
                        filePathValue?.removeAll()
                        
                        let seconds = 2.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.tableView.reloadData()
                        }
                    }
                   
                }
                
            }else{
                
                var selectedImageData = [String:String]()
                
                
                guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
                
                
                print(fileUrl.lastPathComponent)
                
                if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    selectedImageData["filename"] = fileUrl.lastPathComponent
                    selectedImageData["data"] = pickedImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
                    let storage = Storage.storage()
                    _ = URL(string: "\(fileUrl)")
                    let storageRef = storage.reference().child(appDelegate.uniqueID!).child(splitUrl).child(self.filePathText).child("\(fileUrl.lastPathComponent)")
                    storageRef.putFile(from: fileUrl, metadata: nil) { metadata, error in
                        guard metadata != nil else{
                            print("error: \(String(describing: error?.localizedDescription))")
                            return
                        }
                        let fileManager = FileManager.default
                        if fileManager.fileExists(atPath: "\(fileUrl)") {
                            do {
                                try fileManager.removeItem(at: fileUrl)
                                print("success: move item\(fileUrl)")
                            }catch{
                                print("failed: move item\(fileUrl)")
                            }
                        }
                    }
                    if (appDelegate.isFillupFormViewingView){
                        if(ansBoolValue[fileIndex] == true){
//                            var ansDataValue = ansDynamicArray[fileIndex]["\(questionUniqueName)"]! as? [[String:Any]]
                            var ansDataValue : [[String:Any]]?
                            for i in 0 ..< ansDynamicArray.count{
                                let ansFullString = ansDynamicArray[i].keys.first!
                                if(ansFullString == questionUniqueName){
                                    ansDataValue = ansDynamicArray[i]["\(questionUniqueName)"]! as? [[String:Any]]
                                }
                                
                            }
                            var ansDataOptionValue = ansDataValue![1]["answer"]! as? [String]
                            print(ansDataOptionValue!)
                            ansDataOptionValue?.append("\(appDelegate.uniqueID!)/\(splitUrl)/\(self.filePathText)/\(fileUrl.lastPathComponent)")
                            print("\(appDelegate.uniqueID!)/\(splitUrl)/\(self.filePathText)/\(fileUrl.lastPathComponent)")
                            print(ansDataOptionValue!)
                            self.multipleImageDataStore.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                            self.multipleImageDataStore.append([ "answer" : ansDataOptionValue!])
                            self.ansDynamicArray.append(["\(questionUniqueName)" : self.multipleImageDataStore])
                            self.multipleImageDataStore.removeAll()
                            filePathValue?.removeAll()
                            ansDataValue?.removeAll()
                            ansDataOptionValue?.removeAll()
                            self.ansBoolValue.remove(at: self.fileIndex )
                            self.ansBoolValue.insert(true, at: self.fileIndex)
                        }else{
                            emptyMultipleImage.append("\(appDelegate.uniqueID!)/\(splitUrl)/\(self.filePathText)/\(fileUrl.lastPathComponent)")
                            print(emptyMultipleImage)
                            self.multipleImageDataStore.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                            self.multipleImageDataStore.append([ "answer" : emptyMultipleImage])
                            self.ansDynamicArray.append(["\(questionUniqueName)" : self.multipleImageDataStore])
                            self.multipleImageDataStore.removeAll()
                            filePathValue?.removeAll()
                            emptyMultipleImage.removeAll()
                            self.ansBoolValue.remove(at: self.fileIndex )
                            self.ansBoolValue.insert(true, at: self.fileIndex)
                        }
                        
                        let seconds = 2.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.tableView.reloadData()
                        }
                    }else{
                        if(ansBoolValue[fileIndex] == true){
                            var ansDataValue = ansDynamicArray[fileIndex]["\(questionUniqueName)"]! as? [[String:Any]]
                            var ansDataOptionValue = ansDataValue![1]["answer"]! as? [String]
                            ansDataOptionValue?.append("\(appDelegate.uniqueID!)/\(splitUrl)/\(self.filePathText)/\(fileUrl.lastPathComponent)")
                            print(ansDataOptionValue!)
                            self.multipleImageDataStore.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                            self.multipleImageDataStore.append([ "answer" : ansDataOptionValue!])
                            self.ansDynamicArray.remove(at: self.fileIndex )
                            self.ansDynamicArray.insert(["\(questionUniqueName)" : self.multipleImageDataStore], at: self.fileIndex)
                            self.multipleImageDataStore.removeAll()
                            filePathValue?.removeAll()
                            ansDataValue?.removeAll()
                            ansDataOptionValue?.removeAll()
                            self.ansBoolValue.remove(at: self.fileIndex )
                            self.ansBoolValue.insert(true, at: self.fileIndex)
                        }else{
                            emptyMultipleImage.append("\(appDelegate.uniqueID!)/\(splitUrl)/\(self.filePathText)/\(fileUrl.lastPathComponent)")
                            print(emptyMultipleImage)
                            self.multipleImageDataStore.append([ "title" : "\((filePathValue?[0]["title"])!)"])
                            self.multipleImageDataStore.append([ "answer" : emptyMultipleImage])
                            self.ansDynamicArray.remove(at: self.fileIndex )
                            self.ansDynamicArray.insert(["\(questionUniqueName)" : self.multipleImageDataStore], at: self.fileIndex)
                            self.multipleImageDataStore.removeAll()
                            filePathValue?.removeAll()
                            emptyMultipleImage.removeAll()
                            self.ansBoolValue.remove(at: self.fileIndex )
                            self.ansBoolValue.insert(true, at: self.fileIndex)
                        }
                        
                        let seconds = 2.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.tableView.reloadData()
                        }
                    }
                   
                }
            }

            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    func fileOpen(){
        let attachSheet = UIAlertController(title: nil, message: "File Open", preferredStyle: .actionSheet)
                
                
                attachSheet.addAction(UIAlertAction(title: "Open in App", style: .default,handler: { (action) in
                    //let supportedTypes: [UTType] = [UTType.png,UTType.jpeg, UTType.pdf]
                    //let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
                    let storyboard = UIStoryboard(name: "User", bundle: nil)
                    let pdfFileViewController = storyboard.instantiateViewController(withIdentifier: "PdfFileViewController") as? PdfFileViewController
                   // appDelegate.currentNav!.pushViewController(pdfFileViewController!, animated: true)
                    self.present(pdfFileViewController!, animated: true, completion: nil)
                }))
        
        attachSheet.addAction(UIAlertAction(title: "Download", style: .default,handler: { (action) in
        
            self.DownlondFromUrl()
//            self.exectURL = URL(string: "\(self.shareUrl)")
//            self.sharedObjects = [self.exectURL as AnyObject]
//            let activityViewController = UIActivityViewController(activityItems: self.sharedObjects , applicationActivities: nil)
//            activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook, .postToTwitter, .mail]
//            activityViewController.isModalInPresentation = true
//            activityViewController.popoverPresentationController?.sourceView = UIView()
//            self.present(activityViewController, animated: true, completion: nil)
        }))
                
//                attachSheet.addAction(UIAlertAction(title: "Photo/Video", style: .default,handler: { (action) in
//                    self.chooseImage()
//                }))
                
                
        attachSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.tableView.reloadData()
        }))
                
                self.present(attachSheet, animated: true, completion: nil)
    }
    
    func DownlondFromUrl(){
        LoadingIndicatorView.show()
        if appDelegate.sharedFormTotalView{
            
            let index = appDelegate.peopleServeyScreenFormName.index(appDelegate.peopleServeyScreenFormName.startIndex, offsetBy: 28)
            let subString = appDelegate.peopleServeyScreenFormName.substring(from: index)
            let uniqueIdSubString = appDelegate.peopleServeyScreenFormName.take(28)
            print(appDelegate.peoplwServeyUniqueId)
            print(appDelegate.peopleServeyScreenFormName)
            print(uniqueIdSubString)
            //Create URL to the source file you want to download
            let islandRef = self.storageRef.child(appDelegate.peoplwServeyUniqueId).child(appDelegate.peopleServeyScreenFormName).child(subString).child("File.pdf")
                    islandRef.downloadURL { url, error in
                        if let error = error {
                            print(error)
                        } else {
                            
                            let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
                            let destinationFileUrl = documentsUrl.appendingPathComponent("\(appDelegate.storeFormName)")
                            
                            let sessionConfig = URLSessionConfiguration.default
                            let session = URLSession(configuration: sessionConfig)

                            let request = URLRequest(url:url!)
                            print(url!)

                            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                                if let tempLocalUrl = tempLocalUrl, error == nil {
                                    // Success
                                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                        print("Successfully downloaded. Status code: \(statusCode)")
                                    }

                                    do {
                                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                                    } catch (let writeError) {
                                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                                    }

                                } else {
                                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                                }
                            }
                            task.resume()
                            LoadingIndicatorView.hide()
                        }
                    }
            
        }else{
            
            //Create URL to the source file you want to download
                let islandRef = self.storageRef.child(appDelegate.peoplwServeyUniqueId).child("\(appDelegate.uniqueID!)\(appDelegate.peopleServeyScreenFormName)").child(self.shareUrl).child("File.pdf")
                    islandRef.downloadURL { url, error in
                        if let error = error {
                            print(error)
                        } else {
                            
                            let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
                            let destinationFileUrl = documentsUrl.appendingPathComponent("\(appDelegate.storeFormName)")
                            
                            let sessionConfig = URLSessionConfiguration.default
                            let session = URLSession(configuration: sessionConfig)

                            let request = URLRequest(url:url!)
                            print(url!)

                            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                                if let tempLocalUrl = tempLocalUrl, error == nil {
                                    // Success
                                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                        print("Successfully downloaded. Status code: \(statusCode)")
                                    }

                                    do {
                                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                                    } catch (let writeError) {
                                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                                    }

                                } else {
                                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                                }
                            }
                            task.resume()
                            LoadingIndicatorView.hide()
                        }
                    }
        }
    }
    
    public func showSingleButtonAlert(message: String,okText : String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: okText,
                                         style: .cancel, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
}

