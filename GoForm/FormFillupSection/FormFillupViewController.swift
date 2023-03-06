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

class FormFillupViewController: UIViewController, UIScrollViewDelegate, UIDocumentPickerDelegate {
    
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
    var fileArrayIndex = 0
    var shareUrl: String = ""
    
    var textFieldData = [[String:String]]()
    var datePickerData = [[String:String]]()
    var fileUploadData = [[String:String]]()
    var dropdownData = [[String:Any]]()
    var singleChoiceData = [[String:Any]]()
    var multipleChoiceData = [[String:Any]]()
    
    var imagePicker: UIImagePickerController!
    var storageRef: StorageReference!
    var documentPicker: UIDocumentPickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
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
            let uniqueIdSubString = appDelegate.peopleServeyScreenFormName.take(28)
            self.formNamTextLbl.text = subString
            loadSharedFormServeyData()
        }else{
            self.formNameView.alpha = 1
        }
        self.formNameErrorText.alpha = 0
        submitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        formNameSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        
        initNewSelectDatePicker()
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
            
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.fullFormViewData.append(contentsOf: (data))
            LoadingIndicatorView.hide()
            //self.extractData()
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
            if ((fullFormViewData[i].value(forKey: "Text")) != nil){
                let textDataValue = fullFormViewData[i]["Text"]!
                dynamicArray.append(["Text" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "File")) != nil){
                let textDataValue = fullFormViewData[i]["File"]!
                dynamicArray.append(["File" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "Date")) != nil){
                let textDataValue = fullFormViewData[i]["Date"]!
                dynamicArray.append(["Date" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "Dropdown")) != nil){
                let textDataValue = fullFormViewData[i]["Dropdown"]!
                dynamicArray.append(["Dropdown" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "SingleChoice")) != nil){
                let textDataValue = fullFormViewData[i]["SingleChoice"]!
                dynamicArray.append(["SingleChoice" : textDataValue])
            }
            else{
                let textDataValue = fullFormViewData[i]["MultipleChoice"]!
                dynamicArray.append(["MultipleChoice" : textDataValue])
            }
        }
        
        for i in 0 ..< submittedAnsData.count{
            if ((submittedAnsData[i].value(forKey: "Text")) != nil){
                let textDataValue = submittedAnsData[i]["Text"]!
                ansDynamicArray.append(["Text" : textDataValue])
            }
            else if ((submittedAnsData[i].value(forKey: "File")) != nil){
                let textDataValue = submittedAnsData[i]["File"]!
                ansDynamicArray.append(["File" : textDataValue])
            }
            else if ((submittedAnsData[i].value(forKey: "Date")) != nil){
                let textDataValue = submittedAnsData[i]["Date"]!
                ansDynamicArray.append(["Date" : textDataValue])
            }
            else if ((submittedAnsData[i].value(forKey: "Dropdown")) != nil){
                let textDataValue = submittedAnsData[i]["Dropdown"]!
                ansDynamicArray.append(["Dropdown" : textDataValue])
            }
            else if ((submittedAnsData[i].value(forKey: "SingleChoice")) != nil){
                let textDataValue = submittedAnsData[i]["SingleChoice"]!
                ansDynamicArray.append(["SingleChoice" : textDataValue])
            }
            else{
                let textDataValue = submittedAnsData[i]["MultipleChoice"]!
                ansDynamicArray.append(["MultipleChoice" : textDataValue])
            }
        }
        
//        self.ansDynamicArray = Array(repeating: ["":""], count: self.dynamicArray.count)
//        self.fileUrlArray = Array(repeating: "", count: self.dynamicArray.count)
        LoadingIndicatorView.hide()
        self.tableView.reloadData()
        
    }
    func loadData(){
        LoadingIndicatorView.show()
        
        self.ref.child("GlobalForms/\(splitUrl)/Start/Time").queryOrderedByKey().observe(.value){ snapshot in
            
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

        }
        
        self.ref.child("GlobalForms/\(splitUrl)/End/Time").queryOrderedByKey().observe(.value){ snapshot in
            
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
        }
        
        self.ref.child("GlobalForms/\(splitUrl)/data").queryOrderedByKey().observe(.value){ snapshot in
            
            guard let data = snapshot.value as? [NSDictionary] else { return }
            self.fullFormViewData.append(contentsOf: (data))
            LoadingIndicatorView.hide()
            self.extractData()
        }
    }
    
    func extractData(){
        for i in 0 ..< fullFormViewData.count{
            if ((fullFormViewData[i].value(forKey: "Text")) != nil){
                let textDataValue = fullFormViewData[i]["Text"]!
                dynamicArray.append(["Text" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "File")) != nil){
                let textDataValue = fullFormViewData[i]["File"]!
                dynamicArray.append(["File" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "Date")) != nil){
                let textDataValue = fullFormViewData[i]["Date"]!
                dynamicArray.append(["Date" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "Dropdown")) != nil){
                let textDataValue = fullFormViewData[i]["Dropdown"]!
                dynamicArray.append(["Dropdown" : textDataValue])
            }
            else if ((fullFormViewData[i].value(forKey: "SingleChoice")) != nil){
                let textDataValue = fullFormViewData[i]["SingleChoice"]!
                dynamicArray.append(["SingleChoice" : textDataValue])
            }
            else{
                let textDataValue = fullFormViewData[i]["MultipleChoice"]!
                dynamicArray.append(["MultipleChoice" : textDataValue])
            }
        }
        self.ansDynamicArray = Array(repeating: ["":""], count: self.dynamicArray.count)
        self.ansBoolValue = Array(repeating: false, count: self.dynamicArray.count)
        self.fileUrlArray = Array(repeating: "", count: self.dynamicArray.count)
        self.tableView.reloadData()
    }
    
    
    @IBAction func formFillupSubmitBtnPressed(_ sender: Any) {
        
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
    
    @IBAction func formNameSubmitBtnPressed(_ sender: Any) {
        if formNameTextField.text?.count == 0 {
            
        }else{
            self.formNameView.alpha = 0
            let splitUrlFUll = formNameTextField.text?.components(separatedBy: "=")
            self.splitUrl = splitUrlFUll?.last ?? ""
            let index = self.splitUrl.index(self.splitUrl.startIndex, offsetBy: 28)
            let subString = self.splitUrl.substring(from: index)
            self.formNamTextLbl.text = subString
            self.formNameTextField.resignFirstResponder()
            self.loadData()
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
        var dateEditDataValue = self.dynamicArray[dateFieldIndex]["Date"]! as? [[String:Any]]
//        self.ansDynamicArray.remove(at: self.dateFieldIndex )
//        self.ansDynamicArray.insert(["\((dateEditDataValue?[0]["tittle"])!)" : "\(startDate)"], at: self.dateFieldIndex)
        self.datePickerData.append([ "title" : "\((dateEditDataValue?[0]["title"])!)"])
        self.datePickerData.append([ "answer" : "\(startDate)"])
        self.ansDynamicArray.remove(at: self.dateFieldIndex )
        self.ansDynamicArray.insert(["Date" : self.datePickerData], at: self.dateFieldIndex)
        self.ansBoolValue.remove(at: self.dateFieldIndex )
        self.ansBoolValue.insert(true, at: self.dateFieldIndex)
        self.datePickerData.removeAll()
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
                if (dynamicArray[indexPath.row]["Text"] != nil){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView){
                        let cellTextField: FormFillupTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupTextFieldTableViewCell", for: indexPath) as! FormFillupTextFieldTableViewCell
                        var textDataValue = dynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
                        var ansDataValue = ansDynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
                        print((textDataValue?[0]["title"])! as! String)
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((textDataValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellTextField.textFieldTittleLbl.text = stringWithExtraSpace
                        cellTextField.textFieldTittleLbl.numberOfLines = 0
                        cellTextField.textFieldTittleLbl.adjustsFontSizeToFitWidth = true
                        cellTextField.textFieldTittleLbl.sizeToFit()
                        cellTextField.textField.text = (ansDataValue?[1]["answer"])! as? String
    //                    var ansValue = ansDynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
    //                    if (ansValue?[1]["answer"] as! String == ""){
    //                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    }else{
    //                        cellTextField.textField.placeholder = (textDataValue?[1]["placeholder"])! as? String
    //                    }
                        ansDataValue?.removeAll()
                        textDataValue?.removeAll()
                        cellTextField.textField.tag = indexPath.row
                        cellTextField.didSaveText = { [weak self] tag in
                            var textEditDataValue = self?.dynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
                            self?.textFieldIndex = 0
                            self?.textFieldIndex = indexPath.row
                            self?.textFieldData.append([ "title" : "\((textEditDataValue?[0]["title"])!)"])
                            self?.textFieldData.append([ "answer" : "\((cellTextField.textField.text)!)"])
                            self?.ansDynamicArray.remove(at: self!.textFieldIndex )
                            self?.ansDynamicArray.insert(["Text" : self!.textFieldData], at: self!.textFieldIndex)
                            self?.textFieldData.removeAll()
                            textEditDataValue?.removeAll()
                            //self?.questionArray2.remove(at: self!.index + 1)
                            //self?.tableView.reloadData()
                        }
                        return cellTextField

                    }else{
                        let cellTextField: FormFillupTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupTextFieldTableViewCell", for: indexPath) as! FormFillupTextFieldTableViewCell
                        var textDataValue = dynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
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
                            var textEditDataValue = self?.dynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
                            self?.textFieldIndex = 0
                            self?.textFieldIndex = indexPath.row
                            self?.textFieldData.append([ "title" : "\((textEditDataValue?[0]["title"])!)"])
                            self?.textFieldData.append([ "answer" : "\((cellTextField.textField.text)!)"])
                            self?.ansDynamicArray.remove(at: self!.textFieldIndex )
                            self?.ansDynamicArray.insert(["Text" : self!.textFieldData], at: self!.textFieldIndex)
                            self?.ansBoolValue.remove(at: self!.textFieldIndex )
                            self?.ansBoolValue.insert(true, at: self!.textFieldIndex)
                            self?.textFieldData.removeAll()
                            textEditDataValue?.removeAll()
                            //self?.questionArray2.remove(at: self!.index + 1)
                            self?.tableView.reloadData()
                        }
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue = ansDynamicArray[indexPath.row]["Text"]! as? [[String:Any]]
                            cellTextField.textField.text = (ansDataValue?[1]["answer"])! as? String
                            ansDataValue?.removeAll()
                        }else{
                            
                        }
                        return cellTextField
                    }
                }
                else if(dynamicArray[indexPath.row]["File"] != nil){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellFile: FormFillupUploadFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupUploadFileTableViewCell", for: indexPath) as! FormFillupUploadFileTableViewCell
                        cellFile.fileUploadBtn.tag = indexPath.row + 1
                        var fileUploadValue = dynamicArray[indexPath.row]["File"]! as? [[String:Any]]
                        var ansDataValue = ansDynamicArray[indexPath.row]["File"]! as? [[String:Any]]
                        cellFile.uploadFileMaxSizeLbl.text = "Maximum Size \((fileUploadValue?[2]["fileSize"])! as! String)MB"
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((fileUploadValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellFile.uploadFileTittleLbl.text = stringWithExtraSpace
                        cellFile.chooseFileTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                        cellFile.chooseFileTextLbl.textColor = UIColor.red
                        cellFile.uploadFileTittleLbl.numberOfLines = 0
                        cellFile.uploadFileTittleLbl.adjustsFontSizeToFitWidth = true
                        cellFile.uploadFileTittleLbl.sizeToFit()
                        ansDataValue?.removeAll()
                        fileUploadValue?.removeAll()
                        
                        if (appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView){
                            cellFile.didUpload = { [weak self] tag in
                                var fileUploadValueForOpen = self!.dynamicArray[indexPath.row]["File"]! as? [[String:Any]]
                                appDelegate.pdfFileUrl =  fileUploadValueForOpen?[0]["title"] as? String
                                self?.shareUrl = fileUploadValueForOpen?[0]["title"] as! String
                                fileUploadValueForOpen?.removeAll()
                                self?.fileOpen()
                            }
                        }else{
                            cellFile.didUpload = { [weak self] tag in
                                var filePathValue = self?.dynamicArray[indexPath.row]["File"]! as? [[String:Any]]
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
                        
                        return cellFile
                    }else{
                        let cellFile: FormFillupUploadFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupUploadFileTableViewCell", for: indexPath) as! FormFillupUploadFileTableViewCell
                        cellFile.fileUploadBtn.tag = indexPath.row + 1
                        var fileUploadValue = dynamicArray[indexPath.row]["File"]! as? [[String:Any]]
                        cellFile.uploadFileMaxSizeLbl.text = "Maximum Size \((fileUploadValue?[2]["fileSize"])! as! String)MB"
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((fileUploadValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellFile.uploadFileTittleLbl.text = stringWithExtraSpace
                        cellFile.uploadFileTittleLbl.numberOfLines = 0
                        cellFile.uploadFileTittleLbl.adjustsFontSizeToFitWidth = true
                        cellFile.uploadFileTittleLbl.sizeToFit()
                        fileUploadValue?.removeAll()
                        
                        cellFile.didUpload = { [weak self] tag in
                            var filePathValue = self?.dynamicArray[indexPath.row]["File"]! as? [[String:Any]]
                            self?.filePathText = ((filePathValue?[0]["title"])) as! String
                            self!.fileIndex = indexPath.row
                            self?.fileArrayIndex = 0
                            self?.fileArrayIndex = indexPath.row
                            //self?.filePathCreate()
                            self?.filePathCreate2()
                            filePathValue?.removeAll()
                            //self?.tableView.reloadData()
                        }
                        
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue = ansDynamicArray[indexPath.row]["File"]! as? [[String:Any]]
                            cellFile.chooseFileTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                            cellFile.chooseFileTextLbl.textColor = UIColor.red
                            ansDataValue?.removeAll()
                        }else{
                            
                        }
                        
                        return cellFile
                    }
                }
                else if(dynamicArray[indexPath.row]["Date"] != nil){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellDatepicker: FormFillupDatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupDatePickerTableViewCell", for: indexPath) as! FormFillupDatePickerTableViewCell
                        var datePickerValue = dynamicArray[indexPath.row]["Date"]! as? [[String:Any]]
                        var ansDataValue = ansDynamicArray[indexPath.row]["Date"]! as? [[String:Any]]
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
                        var datePickerValue = dynamicArray[indexPath.row]["Date"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((datePickerValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDatepicker.datePickerTittleLbl.text = stringWithExtraSpace
                        cellDatepicker.datePickerTittleLbl.numberOfLines = 0
                        cellDatepicker.datePickerTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDatepicker.datePickerTittleLbl.sizeToFit()
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
                        
                        
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue = ansDynamicArray[indexPath.row]["Date"]! as? [[String:Any]]
                            cellDatepicker.dateTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                            ansDataValue?.removeAll()
                        }else{
                            cellDatepicker.dateTextLbl.text = (datePickerValue?[1]["dateFormat"])! as? String
                        }
                        datePickerValue?.removeAll()
                        return cellDatepicker
                    }
                }
                else if(dynamicArray[indexPath.row]["Dropdown"] != nil){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellDropdown: FormFillupDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupDropdownTableViewCell", for: indexPath) as! FormFillupDropdownTableViewCell
                        cellDropdown.dropDownBtn.tag = indexPath.row + 1
                        var dropdownValue = dynamicArray[indexPath.row]["Dropdown"]! as? [[String:Any]]
                        var ansDataValue = ansDynamicArray[indexPath.row]["Dropdown"]! as? [[String:Any]]
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
                            cellDropdown.dropdownOptionDropdown.show()
                            cellDropdown.dropdownOptionDropdown.dataSource = dropdownOptionValue!
                            cellDropdown.dropdownOptionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                              print("Selected item: \(item) at index: \(index)")
                                cellDropdown.dropDownOptionTextLbl.text = dropdownOptionValue![index]
                                var dropdownEditDataValue = self?.dynamicArray[indexPath.row]["Dropdown"]! as? [[String:Any]]
                                self?.dropdownFieldIndex = 0
                                self?.dropdownFieldIndex = indexPath.row
    //                            self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
    //                            self?.ansDynamicArray.insert(["\((dropdownEditDataValue?[0]["tittle"])!)" : "\((dropdownOptionValue![index]))"], at: self!.dropdownFieldIndex)
                                self?.dropdownData.append([ "title" : "\((dropdownEditDataValue?[0]["tittle"])!)"])
                                self?.dropdownData.append([ "answer" : "\((dropdownOptionValue![index]))"])
                                self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
                                self?.ansDynamicArray.insert(["Dropdown" : self!.dropdownData], at: self!.dropdownFieldIndex)
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
                        var dropdownValue = dynamicArray[indexPath.row]["Dropdown"]! as? [[String:Any]]
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
                            cellDropdown.dropdownOptionDropdown.show()
                            cellDropdown.dropdownOptionDropdown.dataSource = dropdownOptionValue!
                            cellDropdown.dropdownOptionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                              print("Selected item: \(item) at index: \(index)")
                                cellDropdown.dropDownOptionTextLbl.text = dropdownOptionValue![index]
                                var dropdownEditDataValue = self?.dynamicArray[indexPath.row]["Dropdown"]! as? [[String:Any]]
                                self?.dropdownFieldIndex = 0
                                self?.dropdownFieldIndex = indexPath.row
    //                            self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
    //                            self?.ansDynamicArray.insert(["\((dropdownEditDataValue?[0]["tittle"])!)" : "\((dropdownOptionValue![index]))"], at: self!.dropdownFieldIndex)
                                self?.dropdownData.append([ "title" : "\((dropdownEditDataValue?[0]["title"])!)"])
                                self?.dropdownData.append([ "answer" : "\((dropdownOptionValue![index]))"])
                                self?.ansDynamicArray.remove(at: self!.dropdownFieldIndex )
                                self?.ansDynamicArray.insert(["Dropdown" : self!.dropdownData], at: self!.dropdownFieldIndex)
                                self?.ansBoolValue.remove(at: self!.dropdownFieldIndex )
                                self?.ansBoolValue.insert(true, at: self!.dropdownFieldIndex)
                                self?.tableView.reloadData()
                                self?.dropdownData.removeAll()
                                dropdownEditDataValue?.removeAll()
                                
                            }
                        }
                        
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue = ansDynamicArray[indexPath.row]["Dropdown"]! as? [[String:Any]]
                            cellDropdown.dropDownOptionTextLbl.text = (ansDataValue?[1]["answer"])! as? String
                            hasData = false
                            ansDataValue?.removeAll()
                        }else{
                            
                        }
                        
                        dropdownValue?.removeAll()
                        return cellDropdown
                    }
                }
                
                else if(dynamicArray[indexPath.row]["SingleChoice"] != nil){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellSingleChoice: FormFillupSingleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupSingleChoiceTableViewCell", for: indexPath) as! FormFillupSingleChoiceTableViewCell
                        appDelegate.formBuilderSingleChoice = []
                        var singleChoiceValue = dynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
                        var ansDataValue = ansDynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
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
                            var singleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
                            self?.singleChoiceIndex = 0
                            self?.singleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((singleChoiceEditDataValue?[0]["tittle"])!)" : "\(cellSingleChoice.index)"], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.append([ "title" : "\((singleChoiceEditDataValue?[0]["title"])!)"])
                            self?.singleChoiceData.append([ "answer" : "\(cellSingleChoice.index)"])
                            self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
                            self?.ansDynamicArray.insert(["SingleChoice" : self!.singleChoiceData], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.removeAll()
                            
                            print(cellSingleChoice.index)
                            singleChoiceEditDataValue?.removeAll()
                        }
                        
                        return cellSingleChoice
                    }else{
                        let cellSingleChoice: FormFillupSingleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupSingleChoiceTableViewCell", for: indexPath) as! FormFillupSingleChoiceTableViewCell
                        appDelegate.formBuilderSingleChoice = []
                        var singleChoiceValue = dynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
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
                            var singleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
                            self?.singleChoiceIndex = 0
                            self?.singleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((singleChoiceEditDataValue?[0]["tittle"])!)" : "\(cellSingleChoice.index)"], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.append([ "title" : "\((singleChoiceEditDataValue?[0]["title"])!)"])
                            self?.singleChoiceData.append([ "answer" : "\(cellSingleChoice.index)"])
                            self?.ansDynamicArray.remove(at: self!.singleChoiceIndex )
                            self?.ansDynamicArray.insert(["SingleChoice" : self!.singleChoiceData], at: self!.singleChoiceIndex)
                            self?.singleChoiceData.removeAll()
                            self?.ansBoolValue.remove(at: self!.singleChoiceIndex )
                            self?.ansBoolValue.insert(true, at: self!.singleChoiceIndex)
                            print(cellSingleChoice.index)
                            singleChoiceEditDataValue?.removeAll()
                            self?.tableView.reloadData()
                        }
                        
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue = ansDynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
                            var ansDataOptionValue = ansDataValue![1]["answer"]! as? String
                            appDelegate.singleChoiceAnsIndex = Int(ansDataOptionValue!)!
                            hasData = false
                            ansDataValue?.removeAll()
                        }else{
                            
                        }

                        return cellSingleChoice
                    }
                }
                
                else if(dynamicArray[indexPath.row]["MultipleChoice"] != nil){
                    
                    if (appDelegate.isFillupFormViewingView || appDelegate.peopleServeyScreenView || appDelegate.sharedFormTotalView) {
                        let cellMultipleChoice: FormFillupMultipleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupMultipleChoiceTableViewCell", for: indexPath) as! FormFillupMultipleChoiceTableViewCell
                        appDelegate.formBuilderMultipleChoice = []
                        var multipleChoiceValue = dynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
                        var ansDataValue = ansDynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
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
                            var multipleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
                            self?.multipleChoiceIndex = 0
                            self?.multipleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((multipleChoiceEditDataValue?[0]["tittle"])!)" : cellMultipleChoice.storeIndex], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.append([ "title" : "\((multipleChoiceEditDataValue?[0]["title"])!)"])
                            self?.multipleChoiceData.append([ "answer" : cellMultipleChoice.storeIndex])
                            self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
                            self?.ansDynamicArray.insert(["MultipleChoice" : self!.multipleChoiceData], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.removeAll()
                            print(cellMultipleChoice.index)
                            multipleChoiceEditDataValue?.removeAll()
                        }
                        
                        return cellMultipleChoice
                    }else{
                        let cellMultipleChoice: FormFillupMultipleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormFillupMultipleChoiceTableViewCell", for: indexPath) as! FormFillupMultipleChoiceTableViewCell
                        appDelegate.formBuilderMultipleChoice = []
                        var multipleChoiceValue = dynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
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
                            var multipleChoiceEditDataValue = self?.dynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
                            self?.multipleChoiceIndex = 0
                            self?.multipleChoiceIndex = indexPath.row
    //                        self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
    //                        self?.ansDynamicArray.insert(["\((multipleChoiceEditDataValue?[0]["tittle"])!)" : cellMultipleChoice.storeIndex], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.append([ "title" : "\((multipleChoiceEditDataValue?[0]["title"])!)"])
                            self?.multipleChoiceData.append([ "answer" : cellMultipleChoice.storeIndex])
                            self?.ansDynamicArray.remove(at: self!.multipleChoiceIndex )
                            self?.ansDynamicArray.insert(["MultipleChoice" : self!.multipleChoiceData], at: self!.multipleChoiceIndex)
                            self?.multipleChoiceData.removeAll()
                            print(cellMultipleChoice.index)
                            multipleChoiceEditDataValue?.removeAll()
                            self?.ansBoolValue.remove(at: self!.multipleChoiceIndex )
                            self?.ansBoolValue.insert(true, at: self!.multipleChoiceIndex)
                            self?.tableView.reloadData()
                            
                        }
                        if ansBoolValue[indexPath.row] == true{
                            var ansDataValue = ansDynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
                            var ansDataOptionValue = ansDataValue![1]["answer"]! as? [Int]
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
            if (dynamicArray[indexPath.row]["Text"] != nil){
                return 120
            }else if (dynamicArray[indexPath.row]["File"] != nil){
                return 220
            }else if (dynamicArray[indexPath.row]["Date"] != nil){
                return 120
                
            }else if (dynamicArray[indexPath.row]["Dropdown"] != nil){
                return 120
            }else if (dynamicArray[indexPath.row]["SingleChoice"] != nil){
                let singleChoiceValue = dynamicArray[indexPath.row]["SingleChoice"]! as? [[String:Any]]
                let singleChoiceOptionValue = singleChoiceValue![1]["option"]! as? [String]
                return 80 + CGFloat(40 * singleChoiceOptionValue!.count)
            }else if (dynamicArray[indexPath.row]["MultipleChoice"] != nil){
                let multipleChoiceValue = dynamicArray[indexPath.row]["MultipleChoice"]! as? [[String:Any]]
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
            var filePathValue = self.dynamicArray[fileIndex]["File"]! as? [[String:Any]]
//            self.ansDynamicArray.remove(at: self.fileIndex )
//            self.ansDynamicArray.insert(["\((filePathValue?[0]["tittle"])!)" : "\(myURL.lastPathComponent)"], at: self.fileIndex)
            self.fileUploadData.append([ "title" : "\((filePathValue?[0]["title"])!)"])
            self.fileUploadData.append([ "answer" : "\(myURL.lastPathComponent)"])
            self.ansDynamicArray.remove(at: self.fileIndex )
            self.ansDynamicArray.insert(["File" : self.fileUploadData], at: self.fileIndex)
            self.fileUploadData.removeAll()
            self.filePathUrl = myURL.lastPathComponent
            let secondLocationRef = Storage.storage().reference()
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
            self.ansBoolValue.remove(at: self.fileIndex )
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
            var selectedImageData = [String:String]()
            
            
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            
            
            print(fileUrl.lastPathComponent)
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                selectedImageData["filename"] = fileUrl.lastPathComponent
                selectedImageData["data"] = pickedImage.pngData()?.base64EncodedString(options: .lineLength64Characters)

                
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
