//
//  CreateDateTimeViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 30/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

class CreateDateTimeViewController: UIViewController, UITextFieldDelegate {
    
    let myStartDatePicker: MyDatePicker = {
        let v = MyDatePicker()
        v.backgroundColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1)
        return v
    }()
    
    let myEndDatePicker: MyDatePicker = {
        let v = MyDatePicker()
        v.backgroundColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1)
        return v
    }()
    
    var newStartDatePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.tintColor = UIColor.red
        v.backgroundColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1)
        return v
    }()
    
    var newEndDatePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.tintColor = UIColor.red
        v.backgroundColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1)
        return v
    }()
    
    @IBOutlet weak var dateTimeBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var containerView : UIView!
    
    @IBOutlet weak var startPartView : UIView?
    @IBOutlet weak var endPartView : UIView?
    @IBOutlet weak var startDatePickerContainerView : UIView?
    @IBOutlet weak var endDatePickerContainerView : UIView?
    @IBOutlet weak var startTimePickerContainerView : UIView?
    @IBOutlet weak var endTimePickerContainerView : UIView?
    @IBOutlet weak var createPinButton : UIButton?

    @IBOutlet weak var createPinBtnView: UIView!
    @IBOutlet weak var selectionView : UIView?
    @IBOutlet weak var timeSelectionView : UIView?
    @IBOutlet weak var selectionView2 : UIView?
    @IBOutlet weak var timeSelectionView2 : UIView?
    @IBOutlet weak var shadowView : UIView!
    @IBOutlet weak var iconDropdown : UIImageView!
    @IBOutlet weak var iconDropdown2 : UIImageView!
    
    
    @IBOutlet weak var clenderOpenView: UIView!{
        didSet{
            clenderOpenView.layer.borderWidth = 1
            clenderOpenView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            clenderOpenView.layer.cornerRadius = 10
            
        }
    }
    
    
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    @IBOutlet weak var lblStartTime : UILabel!
    @IBOutlet weak var lblEndTime : UILabel!
    
    @IBOutlet weak var startTimePicker : UIDatePicker!
    @IBOutlet weak var endTimePicker : UIDatePicker!
    
    
    @IBOutlet weak var formNameView: UIView!
    @IBOutlet weak var formNameBorderView: UIView!{
        didSet{
            formNameBorderView.layer.borderWidth = 1
            formNameBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            formNameBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var startPartBorderView: UIView!{
        didSet{
            startPartBorderView.layer.borderWidth = 1
            startPartBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            startPartBorderView.layer.cornerRadius = 10
            
        }
    }

    @IBOutlet weak var endPartBorderView: UIView!{
        didSet{
            endPartBorderView.layer.borderWidth = 1
            endPartBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            endPartBorderView.layer.cornerRadius = 10
            
        }
    }

    
    @IBOutlet weak var formNameFieldView: UIView!{
        didSet{
            formNameFieldView.layer.borderWidth = 1
            formNameFieldView.layer.cornerRadius = 10
            formNameFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var radioButtonBorderView: UIView!{
        didSet{
            radioButtonBorderView.layer.borderWidth = 1
            radioButtonBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            radioButtonBorderView.layer.cornerRadius = 10
            
        }
    }
    
    
    @IBOutlet weak var formNameTextField: UITextField!
    
    @IBOutlet weak var formNameTextLbl: UILabel!{
        didSet{
            self.formNameTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            formNameTextLbl.numberOfLines = 1
            formNameTextLbl.sizeToFit()
            formNameTextLbl.adjustsFontSizeToFitWidth = true
            formNameTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var formStartTextLbl: UILabel!{
        didSet{
            self.formStartTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            formStartTextLbl.numberOfLines = 1
            formStartTextLbl.sizeToFit()
            formStartTextLbl.adjustsFontSizeToFitWidth = true
            formStartTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var formEndTextLbl: UILabel!{
        didSet{
            self.formEndTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            formEndTextLbl.numberOfLines = 1
            formEndTextLbl.sizeToFit()
            formEndTextLbl.adjustsFontSizeToFitWidth = true
            formEndTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var selectOneTextLbl: UILabel!{
        didSet{
            self.selectOneTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            selectOneTextLbl.numberOfLines = 1
            selectOneTextLbl.sizeToFit()
            selectOneTextLbl.adjustsFontSizeToFitWidth = true
            selectOneTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var headerFormSettingsLbl: UILabel!{
        didSet{
            self.headerFormSettingsLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    @IBOutlet weak var startDateTextLbl: UILabel!{
        didSet{
            self.startDateTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
        }
    }
    @IBOutlet weak var startTimeTextLbl: UILabel!{
        didSet{
            self.startTimeTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
        }
    }
    @IBOutlet weak var endDateTextLbl: UILabel!{
        didSet{
            self.endDateTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
        }
    }
    @IBOutlet weak var endTimeTextLbl: UILabel!{
        didSet{
            self.endTimeTextLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
        }
    }
    @IBOutlet weak var publishBtn: UIButton!{
        didSet{
            self.publishBtn.titleLabel!.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    var toolBar = UIToolbar()
    
    var startDate = Date()
    var endDate : Date?
    var questionArray : [String] = []
    var combineArray = [[String:Any]]()
    var varience : Int = 0
    var startDateString : String = ""
    var endDateString : String = ""
    var firebaseEndDate : Int = 0
    
    var showingStartDatePicker = false
    var showingEndDatePicker = false
    var showingStartTimePicker = false
    var showingEndTimePicker = false
    
    var optionValue = "Public"
    @IBOutlet weak var optionSecondImage: UIImageView!
    @IBOutlet weak var optionFirstImage: UIImageView!
    
    var option = ""
    var formName: String = ""
    var sharedUniqueId: String = ""
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateTimeBtn.alpha = 0
        self.optionFirstImage.image = UIImage(named:"radio_button_select")
        self.formNameTextField.resignFirstResponder()
        self.ref = Database.database().reference()
        if appDelegate.isFullFormView{
            self.formNameTextField.text = appDelegate.formNameText
            self.formNameTextField.isUserInteractionEnabled = false
            getTimeData()
        }
        self.formNameTextField.delegate = self
        createPinBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        docRef = Firestore.firestore().document("")
        self.formName = appDelegate.formNameStore
        self.questionArray = appDelegate.formQuestionArray
        self.combineArray = appDelegate.combineArray
        selectionView?.backgroundColor = .white
        selectionView?.layer.borderWidth = 1.0
        selectionView?.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        selectionView2?.backgroundColor = .white
        selectionView2?.layer.borderWidth = 1.0
        selectionView2?.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        timeSelectionView?.backgroundColor = .white
        timeSelectionView?.layer.borderWidth = 1.0
        timeSelectionView?.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        timeSelectionView2?.backgroundColor = .white
        timeSelectionView2?.layer.borderWidth = 1.0
        timeSelectionView2?.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        containerView.frame.size.width = self.view.frame.size.width
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: containerView.frame.size.height)
        scrollView.addSubview(containerView)

        initNewStartDatePicker()
        initNewEndDatePicker()
        //reloadViews()
    }
    
    @IBAction func optionChooseFirstButtonClicked(_ sender: Any) {
        self.optionValue = "Public"
        self.optionFirstImage.image = UIImage(named:"radio_button_select")
        self.optionSecondImage.image = UIImage(named:"radio_button_unselect")
    }
    
    @IBAction func optionChooseSecondButtonClicked(_ sender: Any) {
        self.optionValue = "Private"
        self.optionSecondImage.image = UIImage(named:"radio_button_select")
        self.optionFirstImage.image = UIImage(named:"radio_button_unselect")
    }
    
    func getTimeData(){
        print("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.formNameText!)/End/Time")
        self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.formNameText!)/End/Time").queryOrderedByKey().observe(.value){ snapshot in
            
            print(snapshot.value)
            guard let data = snapshot.value as? Int else { return }
            self.firebaseEndDate = data
            if (self.firebaseEndDate != 0){
                print(self.firebaseEndDate)
                self.endDate = Date(timeIntervalSince1970: TimeInterval(self.firebaseEndDate))
                self.initNewEndDatePicker()
                self.initNewStartDatePicker()
            }
        }
    }
    
    func reloadViews(){
        
        startDatePickerContainerView?.frame.size.height = showingStartDatePicker ? newStartDatePicker.frame.size.height : 0
        startDatePickerContainerView?.frame.origin.y = (selectionView?.frame.origin.y)! + (selectionView?.frame.size.height)! + 8
        timeSelectionView?.frame.origin.y = (startDatePickerContainerView?.frame.origin.y)! + (startDatePickerContainerView?.frame.size.height)!
        startTimePickerContainerView?.frame.origin.y = (timeSelectionView?.frame.origin.y)! + (timeSelectionView?.frame.size.height)! + 8
        startTimePickerContainerView?.frame.size.height = showingStartTimePicker ? 150 : 0
        
        endDatePickerContainerView?.frame.size.height = showingEndDatePicker ? newEndDatePicker.frame.size.height : 0
        endDatePickerContainerView?.frame.origin.y = (selectionView2?.frame.origin.y)! + (selectionView2?.frame.size.height)! + 8
        timeSelectionView2?.frame.origin.y = (endDatePickerContainerView?.frame.origin.y)! + (endDatePickerContainerView?.frame.size.height)!
        endTimePickerContainerView?.frame.origin.y = (timeSelectionView2?.frame.origin.y)! + (timeSelectionView2?.frame.size.height)! + 8
        endTimePickerContainerView?.frame.size.height = showingEndTimePicker ? 150 : 0
        
        startPartView?.frame.size.height = (startTimePickerContainerView?.frame.origin.y)! + (startTimePickerContainerView?.frame.size.height)!
        endPartView?.frame.origin.y = (startPartView?.frame.origin.y)! + (startPartView?.frame.size.height)! + 20
        
        endPartView?.frame.size.height = (endTimePickerContainerView?.frame.origin.y)! + (endTimePickerContainerView?.frame.size.height)!
        //createPinButton?.frame.origin.y = (endPartView?.frame.origin.y)! + (endPartView?.frame.size.height)! + 20
        
        
        //containerView?.frame.size.height = (createPinButton?.frame.origin.y)! + (createPinButton?.frame.size.height)! + 50
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: containerView.frame.size.height)
    }
    
    @IBAction func createPinAction(){
        appDelegate.isShared = false
        if (formNameTextField.text?.count == 0){
            appDelegate.myDatePicker.showSingleButtonAlert(message: "Please enter form name", okText: "Ok", vc: self)
            return
        }
        else if ((lblEndDate.text!.lowercased() as NSString).contains("select") || endDate == nil){
            appDelegate.myDatePicker.showSingleButtonAlert(message: "Please select end date", okText: "Ok", vc: self)
            return
        }
        else if ((lblEndTime.text!.lowercased() as NSString).contains("select") || endDate == nil){
            appDelegate.myDatePicker.showSingleButtonAlert(message: "Please select end time", okText: "Ok", vc: self)
            return
        }
        
        if (endDate! < startDate){
            appDelegate.myDatePicker.showSingleButtonAlert(message: "End date cann't be lower than start date", okText: "Ok", vc: self)
            return
        }
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        startDateString = dateFormatter.string(from: self.startDate)
        endDateString = dateFormatter.string(from: self.endDate!)
        
        let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
        let endTimeStamp : Int = Int(endDate!.timeIntervalSince1970)
      
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let startAt = dateFormatter.date(from: self.startDateString)
        let endAt = dateFormatter.date(from: self.endDateString)
        
        //dateFormatter.dateFormat = "dd MMM, yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"		
        let expiredAt = dateFormatter.string(from: endAt!)
        
        let createdAt : Date? = dateFormatter.date(from: dateFormatter.string(from: Date()))
        
        let data = NSMutableDictionary.init()
        data.setValue("Expired on \(expiredAt)", forKey: "expireOn")
        data.setValue(startAt, forKey: "startDate")
        data.setValue(endAt, forKey: "endDate")
        data.setValue(createdAt, forKey: "createdAt")
        data.setValue(self.varience, forKey: "varience")
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        data.setValue(dateFormatter.string(from:startAt!), forKey: "start_date")
        data.setValue(dateFormatter.string(from:endAt!), forKey: "end_date")
        
         let keyPart1 = self.startDateString.split(separator: " ").first
         let keyPart2 = self.endDateString.split(separator: " ").first
        
        if appDelegate.shared == true {
            LoadingIndicatorView.show()
            let path: String = "UserDetails/\(appDelegate.sharedFormUniqueId)/\("Form")/\(self.formNameTextField.text!)"
            let path2: String = "GlobalForms/\(appDelegate.sharedFormUniqueId)\(self.formNameTextField.text!)"
            let credential = ["data" : combineArray]
            self.ref.child(path).setValue(credential)
            self.ref.child(path2).setValue(credential)
            self.ref.child(path).child("Start").child("Date").setValue(keyPart1)
            self.ref.child(path).child("Start").child("Time").setValue(startTimeStamp)
            self.ref.child(path).child("End").child("Date").setValue(keyPart2)
            self.ref.child(path).child("End").child("Time").setValue(endTimeStamp)
            self.ref.child(path2).child("Start").child("Date").setValue(keyPart1)
            self.ref.child(path2).child("Start").child("Time").setValue(startTimeStamp)
            self.ref.child(path2).child("End").child("Date").setValue(keyPart2)
            self.ref.child(path2).child("End").child("Time").setValue(endTimeStamp)
            LoadingIndicatorView.hide()
            Database.database().reference().removeAllObservers()
            self.navigationController?.popToRootViewController(animated: true)

        }else{
            if appDelegate.isFullFormView{
                LoadingIndicatorView.show()
                let dataPath: String = "UserDetails/\(appDelegate.uniqueID!)/\("Form")/\(self.formNameTextField.text!)/data"
                let startDatePath: String = "UserDetails/\(appDelegate.uniqueID!)/\("Form")/\(self.formNameTextField.text!)"
                let endDatePath: String = "UserDetails/\(appDelegate.uniqueID!)/\("Form")/\(self.formNameTextField.text!)"
                let globalDataPath: String = "GlobalForms/\(appDelegate.uniqueID!)\(self.formNameTextField.text!)/data"
                let globalStartDatePath: String = "GlobalForms/\(appDelegate.uniqueID!)\(self.formNameTextField.text!)"
                let globalEndDatePath: String = "GlobalForms/\(appDelegate.uniqueID!)\(self.formNameTextField.text!)"
                let credential = ["data" : combineArray]
                self.ref.child(dataPath).setValue(combineArray)
                self.ref.child(globalDataPath).setValue(combineArray)
                self.ref.child(startDatePath).child("Start").child("Date").setValue(keyPart1)
                self.ref.child(startDatePath).child("Start").child("Time").setValue(startTimeStamp)
                self.ref.child(endDatePath).child("End").child("Date").setValue(keyPart2)
                self.ref.child(endDatePath).child("End").child("Time").setValue(endTimeStamp)
                self.ref.child(globalStartDatePath).child("Start").child("Date").setValue(keyPart1)
                self.ref.child(globalStartDatePath).child("Start").child("Time").setValue(startTimeStamp)
                self.ref.child(globalEndDatePath).child("End").child("Date").setValue(keyPart2)
                self.ref.child(globalEndDatePath).child("End").child("Time").setValue(endTimeStamp)
                LoadingIndicatorView.hide()
                Database.database().reference().removeAllObservers()
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                LoadingIndicatorView.show()
                let path: String = "UserDetails/\(appDelegate.uniqueID!)/\("Form")/\(self.formNameTextField.text!)"
                let path2: String = "GlobalForms/\(appDelegate.uniqueID!)\(self.formNameTextField.text!)"
                let credential = ["data" : combineArray]
                self.ref.child(path).setValue(credential)
                self.ref.child(path2).setValue(credential)
                self.ref.child(path).child("Start").child("Date").setValue(keyPart1)
                self.ref.child(path).child("Start").child("Time").setValue(startTimeStamp)
                self.ref.child(path).child("End").child("Date").setValue(keyPart2)
                self.ref.child(path).child("End").child("Time").setValue(endTimeStamp)
                self.ref.child(path2).child("Start").child("Date").setValue(keyPart1)
                self.ref.child(path2).child("Start").child("Time").setValue(startTimeStamp)
                self.ref.child(path2).child("End").child("Date").setValue(keyPart2)
                self.ref.child(path2).child("End").child("Time").setValue(endTimeStamp)
                LoadingIndicatorView.hide()
                Database.database().reference().removeAllObservers()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func selectStartDate(){
        //touchedOutside()
        //showingStartDatePicker = true
        self.dateTimeBtn.alpha = 1
        startTimePickerContainerView?.alpha = 0
        endTimePickerContainerView?.alpha = 0
        clenderOpenView.alpha = 1
        newStartDatePicker.alpha = 1
        clenderOpenView.frame.size.height = newStartDatePicker.frame.size.height
        clenderOpenView.center = mainView.center
        clenderOpenView.addSubview(newStartDatePicker)
        //reloadViews()
    }
    
    @IBAction func selectStartTime(){
       // touchedOutside()
        //showingStartDatePicker = true
        self.dateTimeBtn.alpha = 1
        clenderOpenView.alpha = 1
        startTimePickerContainerView?.alpha = 1
        endTimePickerContainerView?.alpha = 0
        clenderOpenView.frame.size.height = startTimePickerContainerView!.frame.size.height
        clenderOpenView.center = mainView!.center
        //startTimePickerContainerView?.center = clenderOpenView.center
        clenderOpenView.addSubview(startTimePickerContainerView!)
    }
    
    @IBAction func selectEndDate(){
        //touchedOutside()
        //showingStartDatePicker = true
        self.dateTimeBtn.alpha = 1
        startTimePickerContainerView?.alpha = 0
        endTimePickerContainerView?.alpha = 0
        newEndDatePicker.alpha = 1
        clenderOpenView.alpha = 1
        clenderOpenView.frame.size.height = newEndDatePicker.frame.size.height
        clenderOpenView.center = mainView.center
        clenderOpenView.addSubview(newEndDatePicker)
        //reloadViews()
    }
    
    @IBAction func selectEndTime(){
        
        if (lblEndDate.text != "DD-MM-YYYY"){
            
            //touchedOutside()
            //showingStartDatePicker = true
            self.dateTimeBtn.alpha = 1
            clenderOpenView.alpha = 1
            startTimePickerContainerView?.alpha = 0
            endTimePickerContainerView?.alpha = 1
            clenderOpenView.frame.size.height = endTimePickerContainerView!.frame.size.height
          //  clenderOpenView.center = mainView.center
            //endTimePickerContainerView?.center = clenderOpenView.center
            clenderOpenView.addSubview(endTimePickerContainerView!)
            clenderOpenView.center = mainView.center

        }else{
            showSingleButtonAlert(message: "First Select End Date", okText: "Ok", vc: self)
        }
        
    }
    
    
    @IBAction func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func initNewStartDatePicker() {
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
        
        self.startDatePickerContainerView!.addSubview(newStartDatePicker)
        self.startDatePickerContainerView!.frame.size.height = newStartDatePicker.frame.size.height
        self.startDatePickerContainerView!.frame.origin.y = (selectionView?.frame.origin.y)! + selectionView!.frame.size.height + 8
        self.newStartDatePicker.center.x = self.startDatePickerContainerView!.frame.size.width / 2
        
        self.newStartDatePicker.minimumDate = Date()
        self.newStartDatePicker.maximumDate = maxDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        lblStartDate.text = dateFormatter.string(from: startDate)
        
        dateFormatter.dateFormat = "hh:mm a"
        lblStartTime.text = dateFormatter.string(from: startDate)
        
        //dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        //lblOption.text = dateFormatter.string(from: startDate)
        
        newStartDatePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
    }
    
    func initNewEndDatePicker() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        let currentDate = Date()
        components.calendar = calendar
        components.year = 18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        if #available(iOS 14.0, *) {
            newEndDatePicker.preferredDatePickerStyle = .inline
        } else {
            // use default
        }
        
        self.newEndDatePicker.datePickerMode = .date
        
        self.endDatePickerContainerView!.addSubview(newEndDatePicker)
        self.endDatePickerContainerView!.frame.size.height = newEndDatePicker.frame.size.height
        self.endDatePickerContainerView!.frame.origin.y = (selectionView?.frame.origin.y)! + selectionView!.frame.size.height + 8
        self.newEndDatePicker.center.x = self.endDatePickerContainerView!.frame.size.width / 2
        
        self.newEndDatePicker.minimumDate = Date()
        self.newEndDatePicker.maximumDate = maxDate

        
        self.newEndDatePicker.minimumDate = startDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if endDate != nil{
            lblEndDate.text = dateFormatter.string(from: endDate!)
            
            dateFormatter.dateFormat = "hh:mm a"
            lblEndTime.text = dateFormatter.string(from: endDate!)
        }
        newEndDatePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
    }
    
    @objc func startDateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
            
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            lblStartDate.text = dateFormatter.string(from: date)
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        startDate = dateFormatter.date(from: "\(lblStartDate.text ?? "") \(lblStartTime.text ?? "")")!
        
        print("startDate => \(String(describing: startDate))")
        //touchedOutside()
    }
    
    @objc func endDateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
            
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            lblEndDate.text = dateFormatter.string(from: date)
            endDate = date
        }
        
        print("endDate => \(String(describing: endDate))")
       // touchedOutside()
    }
    
    @IBAction func startTimeChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
            
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            lblStartTime.text = dateFormatter.string(from: date)
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        startDate = dateFormatter.date(from: "\(lblStartDate.text ?? "") \(lblStartTime.text ?? "")")!
        
        print("startDate => \(String(describing: startDate))")
       // touchedOutside()
    }
    
    @IBAction func endTimeChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
            
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            lblEndTime.text = dateFormatter.string(from: date)
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        endDate = dateFormatter.date(from: "\(lblEndDate.text ?? "") \(lblEndTime.text ?? "")")!
        
        print("endDate => \(String(describing: endDate))")
      // touchedOutside()
    }

    
    @IBAction func touchedOutside(){
        self.dateTimeBtn.alpha = 0
        clenderOpenView.alpha = 0
        newEndDatePicker.alpha = 0
        newStartDatePicker.alpha = 0
        startTimePickerContainerView?.alpha = 0
        endTimePickerContainerView?.alpha = 0
    }
    
    /**
         * Called when 'return' key pressed. return NO to ignore.
         */
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }


       /**
        * Called when the user click on the view (outside the UITextField).
        */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    public func showSingleButtonAlert(message: String,okText : String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: okText,
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
