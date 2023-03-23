//
//  FormBuilderViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 8/12/22.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import DropDown

class FormBuilderViewController: UIViewController {
    
    let dropDown = DropDown()
    let dropdownOptionDropdown = DropDown()
    let uploadDropDownMenuArray = ["Image","Document", "PDF", "Word", "Excel"]
    var singleChoiceCount = 0
    var multipleChoiceCount = 0
    var isFullFormView: Bool = false
    var isEdit: Bool = false
    var editIndexNumber = 0

    @IBOutlet weak var headerCreateFormLbl: UILabel!{
        didSet{
            self.headerCreateFormLbl.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    @IBOutlet weak var headerAddItemLbl: UILabel!{
        didSet{
            self.headerAddItemLbl.font = UIFont(name: "Barlow-Bold", size: 16.0)
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            self.nextButton.titleLabel!.font = UIFont(name: "Barlow-Bold", size: 20.0)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var formSubmitBtnView: UIView!
    
    //Container
    @IBOutlet var selectOptionContainer: UIView!
    @IBOutlet var textFieldContainer: UIView!
    @IBOutlet var dropdownContainer: UIView!
    @IBOutlet var uploadContainer: UIView!
    @IBOutlet var datepickerView: UIView!
    @IBOutlet var singleChoiceContainer: UIView!
    @IBOutlet var multipleChoiceContainer: UIView!
    //*************textFieldContainer***********************
    
    @IBOutlet weak var textViewTittleLbl: UILabel!{
        didSet{
            self.textViewTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            textViewTittleLbl.numberOfLines = 1
            textViewTittleLbl.sizeToFit()
            textViewTittleLbl.adjustsFontSizeToFitWidth = true
            textViewTittleLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var textViewPlaceholderLbl: UILabel!{
        didSet{
            self.textViewPlaceholderLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            textViewPlaceholderLbl.numberOfLines = 1
            textViewPlaceholderLbl.sizeToFit()
            textViewPlaceholderLbl.adjustsFontSizeToFitWidth = true
            textViewPlaceholderLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var textFieldQuestionTextField: UITextField!
    @IBOutlet weak var textFieldPlaceholderTextField: UITextField!
    @IBOutlet weak var titleBorderView: UIView!{
        didSet{
            titleBorderView.layer.borderWidth = 1
            titleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            titleBorderView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var placeholderBorderView: UIView!{
        didSet{
            placeholderBorderView.layer.borderWidth = 1
            placeholderBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            placeholderBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var textFieldSubmitBtnView: UIView!
    
    @IBOutlet weak var titleTextFieldView: UIView!{
        didSet{
            titleTextFieldView.layer.borderWidth = 1
            titleTextFieldView.layer.cornerRadius = 10
            titleTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var placeholderTextFieldView: UIView!{
        didSet{
            placeholderTextFieldView.layer.borderWidth = 1
            placeholderTextFieldView.layer.cornerRadius = 10
            placeholderTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    //**********************************************************
    
    //*************DropdownContainer***********************
    
    var dropdownOptionArray: [String] = []
    
    @IBOutlet weak var dropdownTittleTextLbl: UILabel!{
        didSet{
            self.dropdownTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            dropdownTittleTextLbl.numberOfLines = 1
            dropdownTittleTextLbl.sizeToFit()
            dropdownTittleTextLbl.adjustsFontSizeToFitWidth = true
            dropdownTittleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var dropdownOptionTittleLbl: UILabel!{
        didSet{
            self.dropdownOptionTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            dropdownOptionTittleLbl.numberOfLines = 1
            dropdownOptionTittleLbl.sizeToFit()
            dropdownOptionTittleLbl.adjustsFontSizeToFitWidth = true
            dropdownOptionTittleLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var dropdownOptionTableView: UITableView!
    @IBOutlet weak var dropdownQuestionTextField: UITextField!
    @IBOutlet weak var dropdownOptionTextField: UITextField!
    @IBOutlet weak var dropdownTittleView: UIView!
    @IBOutlet weak var dropdownOptionView: UIView!
    
    @IBOutlet weak var dropDownTittleBorderView: UIView!{
        didSet{
            dropDownTittleBorderView.layer.borderWidth = 1
            dropDownTittleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            dropDownTittleBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var dropdownOptionBorderView: UIView!{
        didSet{
            dropdownOptionBorderView.layer.borderWidth = 1
            dropdownOptionBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            dropdownOptionBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var dropdownSubmitBtnView: UIView!
    
    @IBOutlet weak var dropdownTitleTextFieldView: UIView!{
        didSet{
            dropdownTitleTextFieldView.layer.borderWidth = 1
            dropdownTitleTextFieldView.layer.cornerRadius = 10
            dropdownTitleTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var dropdownOptionTextFieldView: UIView!{
        didSet{
            dropdownOptionTextFieldView.layer.borderWidth = 1
            dropdownOptionTextFieldView.layer.cornerRadius = 10
            dropdownOptionTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var dropdownOptionAddBtnView: UIView!{
        didSet{
            dropdownOptionAddBtnView.layer.cornerRadius = 10
        }
    }
    
    //*****************************************************
    
    //**************************uploadContainer****************************************
    var accecptableFileDefaultValue = "Single"
    @IBOutlet weak var accecptableFileFirstImageView: UIImageView!
    @IBOutlet weak var accecptableFileSecondImageView: UIImageView!
    
    @IBOutlet weak var uploadTittleTextLbl: UILabel!{
        didSet{
            self.uploadTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            uploadTittleTextLbl.numberOfLines = 1
            uploadTittleTextLbl.sizeToFit()
            uploadTittleTextLbl.adjustsFontSizeToFitWidth = true
            uploadTittleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var uploadFileTypeTextLbl: UILabel!{
        didSet{
            self.uploadFileTypeTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            uploadFileTypeTextLbl.numberOfLines = 1
            uploadFileTypeTextLbl.sizeToFit()
            uploadFileTypeTextLbl.adjustsFontSizeToFitWidth = true
            uploadFileTypeTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var uploadFileSizeTextLbl: UILabel!{
        didSet{
            self.uploadFileSizeTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            uploadFileSizeTextLbl.numberOfLines = 1
            uploadFileSizeTextLbl.sizeToFit()
            uploadFileSizeTextLbl.adjustsFontSizeToFitWidth = true
            uploadFileSizeTextLbl.textAlignment = .center
        }
    }
    
    @IBOutlet weak var accecptableFileTextLbl: UILabel!{
        didSet{
            self.accecptableFileTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            accecptableFileTextLbl.numberOfLines = 1
            accecptableFileTextLbl.sizeToFit()
            accecptableFileTextLbl.adjustsFontSizeToFitWidth = true
            accecptableFileTextLbl.textAlignment = .center
        }
    }
    
    @IBOutlet weak var uploadTittleTextField: UITextField!
    @IBOutlet weak var uploadMaxSizeFileTextField: UITextField!
    @IBOutlet weak var uploadSubmitBtnView: UIView!
    @IBOutlet weak var uploadFileTypeValueLbl: UITextField!
    @IBOutlet weak var uploadFileSizeBorderView: UIView!{
        didSet{
            uploadFileSizeBorderView.layer.borderWidth = 1
            uploadFileSizeBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            uploadFileSizeBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var uploadOptionBorderView: UIView!{
        didSet{
            uploadOptionBorderView.layer.borderWidth = 1
            uploadOptionBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            uploadOptionBorderView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var uploadTittleBorderView: UIView!{
        didSet{
            uploadTittleBorderView.layer.borderWidth = 1
            uploadTittleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            uploadTittleBorderView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var uploadTittleTextFieldView: UIView!{
        didSet{
            uploadTittleTextFieldView.layer.borderWidth = 1
            uploadTittleTextFieldView.layer.cornerRadius = 10
            uploadTittleTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var uploadFileSizeView: UIView!{
        didSet{
            uploadFileSizeView.layer.borderWidth = 1
            uploadFileSizeView.layer.cornerRadius = 10
            uploadFileSizeView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var uploadFileTypeView: UIView!{
        didSet{
            uploadFileTypeView.layer.borderWidth = 1
            uploadFileTypeView.layer.cornerRadius = 10
            uploadFileTypeView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var accecptableFileBorderView: UIView!{
        didSet{
            accecptableFileBorderView.layer.borderWidth = 1
            accecptableFileBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            accecptableFileBorderView.layer.cornerRadius = 10
            
        }
    }
    
    
    //**********************************************************
    
    //*************DatePickerContainer***************************
    
    var dateFormatValue = "DD-MM-YYYY"
    var datePickerDefaultValue = "None"
    
    @IBOutlet weak var datePickerTittleTextLbl: UILabel!{
        didSet{
            self.datePickerTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            datePickerTittleTextLbl.numberOfLines = 1
            datePickerTittleTextLbl.sizeToFit()
            datePickerTittleTextLbl.adjustsFontSizeToFitWidth = true
            datePickerTittleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var datePickerDefaultValueTextLbl: UILabel!{
        didSet{
            self.datePickerDefaultValueTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            datePickerDefaultValueTextLbl.numberOfLines = 1
            datePickerDefaultValueTextLbl.sizeToFit()
            datePickerDefaultValueTextLbl.adjustsFontSizeToFitWidth = true
            datePickerDefaultValueTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var datePickerFormatTextLbl: UILabel!{
        didSet{
            self.datePickerFormatTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            datePickerFormatTextLbl.numberOfLines = 1
            datePickerFormatTextLbl.sizeToFit()
            datePickerFormatTextLbl.adjustsFontSizeToFitWidth = true
            datePickerFormatTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var dateFormatFirstImageView: UIImageView!
    @IBOutlet weak var dateFormatSecondImageView: UIImageView!
    
    @IBOutlet weak var defaultvalueFirstImageView: UIImageView!
    @IBOutlet weak var defaultValueSecondImageView: UIImageView!
    
    @IBOutlet weak var datepickerTittleTextField: UITextField!
    
    @IBOutlet weak var datepickerSubmitBtnView: UIView!
    @IBOutlet weak var datepickerTittleBorderView: UIView!{
        didSet{
            datepickerTittleBorderView.layer.borderWidth = 1
            datepickerTittleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            datepickerTittleBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var datepickerFileSizeBorderView: UIView!{
        didSet{
            datepickerFileSizeBorderView.layer.borderWidth = 1
            datepickerFileSizeBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            datepickerFileSizeBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var datepickerDateFormatBorderView: UIView!{
        didSet{
            datepickerDateFormatBorderView.layer.borderWidth = 1
            datepickerDateFormatBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            datepickerDateFormatBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var datePicketTittleTextFieldView: UIView!{
        didSet{
            datePicketTittleTextFieldView.layer.borderWidth = 1
            datePicketTittleTextFieldView.layer.cornerRadius = 10
            datePicketTittleTextFieldView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    //**********************************************************
    
    //***************************SingleChoiceContainer*******************
    var singleChoiceOptionArray: [String] = []
    
    @IBOutlet weak var singleChoiceOptionTextLbl: UILabel!{
        didSet{
            self.singleChoiceOptionTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            singleChoiceOptionTextLbl.numberOfLines = 1
            singleChoiceOptionTextLbl.sizeToFit()
            singleChoiceOptionTextLbl.adjustsFontSizeToFitWidth = true
            singleChoiceOptionTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var singleChoiceTittleTextLbl: UILabel!{
        didSet{
            self.singleChoiceTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            singleChoiceTittleTextLbl.numberOfLines = 1
            singleChoiceTittleTextLbl.sizeToFit()
            singleChoiceTittleTextLbl.adjustsFontSizeToFitWidth = true
            singleChoiceTittleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var singleChoiceSubmitBtnView: UIView!
    @IBOutlet weak var singleChoiceTableView: UITableView!
    @IBOutlet weak var singleChoiceOptionTextField: UITextField!
    @IBOutlet weak var singleChoiceTittleTextField: UITextField!
    @IBOutlet weak var singleChoiceTitleBorderView: UIView!{
        didSet{
            singleChoiceTitleBorderView.layer.borderWidth = 1
            singleChoiceTitleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            singleChoiceTitleBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var singleChoiceOptionBorderView: UIView!{
        didSet{
            singleChoiceOptionBorderView.layer.borderWidth = 1
            singleChoiceOptionBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            singleChoiceOptionBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var singleChoiceOptionAddBtnView: UIView!{
        didSet{
            singleChoiceOptionAddBtnView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var singleChoiceTittleTextView: UIView!{
        didSet{
            singleChoiceTittleTextView.layer.borderWidth = 1
            singleChoiceTittleTextView.layer.cornerRadius = 10
            singleChoiceTittleTextView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var singleChoiceOptionTextView: UIView!{
        didSet{
            singleChoiceOptionTextView.layer.borderWidth = 1
            singleChoiceOptionTextView.layer.cornerRadius = 10
            singleChoiceOptionTextView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var singleChoiceOptionView: UIView!
    //*******************************************************************
    
    //***************************MultipleChoiceContainer*****************
    var multipleChoiceOptionArray: [String] = []
    
    @IBOutlet weak var multipleChoiceOptionTextLbl: UILabel!{
        didSet{
            self.multipleChoiceOptionTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            multipleChoiceOptionTextLbl.numberOfLines = 1
            multipleChoiceOptionTextLbl.sizeToFit()
            multipleChoiceOptionTextLbl.adjustsFontSizeToFitWidth = true
            multipleChoiceOptionTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var multipleChoiceTittleTextLbl: UILabel!{
        didSet{
            self.multipleChoiceTittleTextLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            multipleChoiceTittleTextLbl.numberOfLines = 1
            multipleChoiceTittleTextLbl.sizeToFit()
            multipleChoiceTittleTextLbl.adjustsFontSizeToFitWidth = true
            multipleChoiceTittleTextLbl.textAlignment = .center
        }
    }
    @IBOutlet weak var multipleChoiceSubmitBtnView: UIView!
    @IBOutlet weak var multipleChoiceTableView: UITableView!
    @IBOutlet weak var multipleChoiceTittleTextField: UITextField!
    @IBOutlet weak var multipleChoiceOptionTextField: UITextField!
    @IBOutlet weak var multipleChoiceTitleBorderView: UIView!{
        didSet{
            multipleChoiceTitleBorderView.layer.borderWidth = 1
            multipleChoiceTitleBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            multipleChoiceTitleBorderView.layer.cornerRadius = 10
            
        }
    }
    @IBOutlet weak var multipleChoiceOptionBorderView: UIView!{
        didSet{
            multipleChoiceOptionBorderView.layer.borderWidth = 1
            multipleChoiceOptionBorderView.layer.borderColor = UIColor(red: 247/255, green: 149/255, blue: 118/255, alpha: 1).cgColor
            multipleChoiceOptionBorderView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var multipleChoiceOptionAddBtnView: UIView!{
        didSet{
            multipleChoiceOptionAddBtnView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var MultipleChoiceOptionTextView: UIView!{
        didSet{
            MultipleChoiceOptionTextView.layer.borderWidth = 1
            MultipleChoiceOptionTextView.layer.cornerRadius = 10
            MultipleChoiceOptionTextView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var multipleChoiceTittleTextView: UIView!{
        didSet{
            multipleChoiceTittleTextView.layer.borderWidth = 1
            multipleChoiceTittleTextView.layer.cornerRadius = 10
            multipleChoiceTittleTextView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var multipleChoiceOptionView: UIView!
    //*******************************************************************
    
    
    var elementName = ["Text Field","Dropdown", "Date Picker", "Upload", "Single Choice", "Multiple Choice"]
    var elementImage = ["icon_text_selection","icon_dropdown_selection","icon_datetime_selection","icon_upload_selection","icon_singlechoice_selection","icon_multiple_selection"]
    
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    var fileQuestionIndex: Int = 0
    var isFile: Bool = false
    var isFileEdit: Bool = false
    var fileQuestionArray: [String] = []
    var dynamicArray = [[String:Any]]()
    
    
    //optionStore dynamic array
    var textFieldData = [[String:String]]()
    var datePickerData = [[String:String]]()
    var fileUploadData = [[String:String]]()
    var dropdownData = [[String:Any]]()
    var singleChoiceData = [[String:Any]]()
    var multipleChoiceData = [[String:Any]]()
    var fullFormViewData: [NSDictionary] = [NSDictionary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFullFormView = appDelegate.isFullFormView
        uploadTittleTextField.delegate = self
        uploadMaxSizeFileTextField.delegate = self
        uploadFileTypeValueLbl.delegate = self
        textFieldQuestionTextField.delegate = self
        textFieldPlaceholderTextField.delegate = self
        dropdownQuestionTextField.delegate = self
        datepickerTittleTextField.delegate = self
        
        
        dropDown.anchorView = uploadFileTypeView
        dropDown.dataSource = uploadDropDownMenuArray
        dropDown.direction = .bottom
        collectionView.dataSource = self
        collectionView.delegate = self
        selectOptionContainer.alpha = 0
        textFieldContainer.alpha = 0
        dropdownContainer.alpha = 0
        uploadContainer.alpha = 0
        datepickerView.alpha = 0
        singleChoiceContainer.alpha = 0
        multipleChoiceContainer.alpha = 0
        
        scrollView.frame.size.width = self.view.frame.size.width
        //scrollView.frame.size.height = self.view.frame.size.height
        tableView.frame.size.width = self.view.frame.size.width
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        //scrollView.addSubview(self.tableView)
        
        selectOptionContainer.frame.size.width = self.view.frame.size.width
        textFieldContainer.frame.size.width = self.view.frame.size.width
        dropdownContainer.frame.size.width = self.view.frame.size.width
        uploadContainer.frame.size.width = self.view.frame.size.width
        datepickerView.frame.size.width = self.view.frame.size.width
        singleChoiceContainer.frame.size.width = self.view.frame.size.width
        multipleChoiceContainer.frame.size.width = self.view.frame.size.width
        
        selectOptionContainer.frame.size.height = self.view.frame.size.height
        textFieldContainer.frame.size.height = self.view.frame.size.height
        dropdownContainer.frame.size.height = self.view.frame.size.height
        uploadContainer.frame.size.height = self.view.frame.size.height
        datepickerView.frame.size.height = self.view.frame.size.height
        singleChoiceContainer.frame.size.height = self.view.frame.size.height
        multipleChoiceContainer.frame.size.height = self.view.frame.size.height
        
        self.view.addSubview(selectOptionContainer)
        self.view.addSubview(textFieldContainer)
        self.view.addSubview(dropdownContainer)
        self.view.addSubview(uploadContainer)
        self.view.addSubview(datepickerView)
        self.view.addSubview(singleChoiceContainer)
        self.view.addSubview(multipleChoiceContainer)
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        formSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        textFieldSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        dropdownSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        uploadSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        datepickerSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        singleChoiceSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        multipleChoiceSubmitBtnView!.roundCorners([.topLeft, .topRight], radius: 20.0)
        self.scrollView.addSubview(tableView)
//        let tapGesture = UITapGestureRecognizer(target: self,
//                                 action: #selector(hideKeyboard))
//                view.addGestureRecognizer(tapGesture)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.uploadFileTypeValueLbl.text = uploadDropDownMenuArray[index]
        }
        
        
        
        //*********************Dropdown******************
        self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
        self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
        //self.dropdownOptionTableView.frame.size.height = CGFloat(30 * dropdownOptionArray.count)
        //*******************************
        
        //*********************SingleChoice******************
        self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
        self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
        //self.dropdownOptionTableView.frame.size.height = CGFloat(30 * dropdownOptionArray.count)
        //*******************************
        
        //*********************MultipleChoice******************
        self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
        self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
        //self.dropdownOptionTableView.frame.size.height = CGFloat(30 * dropdownOptionArray.count)
        //*******************************
        
        if isFullFormView{
            getFullFormViewData()
            //isFullFormView = false
        }

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = scrollView.bounds
    }
    
//    @objc func hideKeyboard() {
//            view.endEditing(true)
//        }
    
    func getFullFormViewData(){
        if appDelegate.isSharedFormView{
            print("UserDetails/\(appDelegate.uniqueId)/Form/\(appDelegate.formNameText!)/data")
            self.ref.child("UserDetails/\(appDelegate.sharedFormUniqueId)/Form/\(appDelegate.formNameText!)/data").queryOrderedByKey().observe(.value){ snapshot in
                
                guard let data = snapshot.value as? [NSDictionary] else { return }
                self.fullFormViewData.append(contentsOf: (data))
                self.extractData()
            }
        }else{
            self.ref.child("UserDetails/\(appDelegate.uniqueID!)/Form/\(appDelegate.formNameText!)/data").queryOrderedByKey().observe(.value){ snapshot in
                
                guard let data = snapshot.value as? [NSDictionary] else { return }
                self.fullFormViewData.append(contentsOf: (data))
                self.extractData()
            }
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
        self.tableView.reloadData()
    }
    
    @IBAction func itemAddBtn(_ sender: Any) {
        self.textFieldQuestionTextField.text = ""
        selectOptionContainer.alpha = 1
        
    }
    
    //********************container open and hide*************************
    
    @IBAction func selectOptionCancelBtnPressed(_ sender: Any) {
        selectOptionContainer.alpha = 0
        textFieldContainer.alpha = 0
        dropdownContainer.alpha = 0
        
    }
    
    @IBAction func textFieldCancelBtnPressed(_ sender: Any) {
        if isEdit{
            self.isEdit = false
            textFieldQuestionTextField.resignFirstResponder()
            textFieldPlaceholderTextField.resignFirstResponder()
            selectOptionContainer.alpha = 0
            textFieldContainer.alpha = 0
            dropdownContainer.alpha = 0
        }else{
            textFieldQuestionTextField.resignFirstResponder()
            textFieldPlaceholderTextField.resignFirstResponder()
            selectOptionContainer.alpha = 1
            textFieldContainer.alpha = 0
            dropdownContainer.alpha = 0
        }
    }
    @IBAction func textFieldSubmitBtnPressed(_ sender: Any) {
        
        if isEdit{
            if textFieldQuestionTextField.text?.count == 0 {
        
            }
            else if textFieldPlaceholderTextField.text?.count == 0 {
        
            }
            else{
                textFieldData.append([ "title" : "\(textFieldQuestionTextField.text!)"])
                textFieldData.append([ "placeholder" : "\(textFieldPlaceholderTextField.text!)"])
                let val = "\(dynamicArray[editIndexNumber].first!.key)"
                dynamicArray.insert(["\(val)" : textFieldData], at: editIndexNumber)
                dynamicArray.remove(at: editIndexNumber + 1)
                textFieldData.removeAll()
                textFieldQuestionTextField.resignFirstResponder()
                textFieldPlaceholderTextField.resignFirstResponder()
                tableView.reloadData()
                selectOptionContainer.alpha = 0
                textFieldContainer.alpha = 0
                textFieldQuestionTextField.text = ""
                textFieldPlaceholderTextField.text = ""
                print(dynamicArray)
                self.isEdit = false
            }
        }else{
            if textFieldQuestionTextField.text?.count == 0 {
        
            }
            else if textFieldPlaceholderTextField.text?.count == 0 {
        
            }
            else{
                var startDate = Date()
                let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
                textFieldData.append([ "title" : "\(textFieldQuestionTextField.text!)"])
                textFieldData.append([ "placeholder" : "\(textFieldPlaceholderTextField.text!)"])
                dynamicArray.append(["\(appDelegate.uniqueID!)_\(startTimeStamp)_Text" : textFieldData])
                textFieldData.removeAll()
                textFieldQuestionTextField.resignFirstResponder()
                textFieldPlaceholderTextField.resignFirstResponder()
                tableView.reloadData()
                selectOptionContainer.alpha = 0
                textFieldContainer.alpha = 0
                textFieldQuestionTextField.text = ""
                textFieldPlaceholderTextField.text = ""
                print(dynamicArray)
            }
        }
    }
    //*************DropdownContainer***********************
    @IBAction func dropDownCancelBtnPressed(_ sender: Any) {
        if isEdit{
            self.isEdit = false
            dropdownQuestionTextField.resignFirstResponder()
            dropdownOptionTextField.resignFirstResponder()
            self.dropdownOptionArray.removeAll()
            selectOptionContainer.alpha = 0
            textFieldContainer.alpha = 0
            dropdownContainer.alpha = 0
            dropdownOptionTableView.reloadData()
        }else{
            dropdownQuestionTextField.resignFirstResponder()
            dropdownOptionTextField.resignFirstResponder()
            self.dropdownOptionArray.removeAll()
            selectOptionContainer.alpha = 1
            textFieldContainer.alpha = 0
            dropdownContainer.alpha = 0
            dropdownOptionTableView.reloadData()
        }
    }
    
    @IBAction func dropdownSubmitBtnPressed(_ sender: Any) {
        
        if isEdit{
            if dropdownQuestionTextField.text?.count == 0 {
        
            }else{
                dropdownData.append(["title" : "\(dropdownQuestionTextField.text!)"])
                dropdownData.append(["option" : dropdownOptionArray])
                let val = "\(dynamicArray[editIndexNumber].first!.key)"
                dynamicArray.insert(["\(val)" : dropdownData], at: editIndexNumber)
                dynamicArray.remove(at: editIndexNumber + 1)
                dropdownData.removeAll()
                dropdownOptionArray.removeAll()
                dropdownQuestionTextField.resignFirstResponder()
                dropdownOptionTableView.reloadData()
                tableView.reloadData()
                dropdownContainer.alpha = 0
                selectOptionContainer.alpha = 0
                dropdownQuestionTextField.text = ""
                print(dynamicArray)
            }
            self.isEdit = false
        }else{
            if dropdownQuestionTextField.text?.count == 0 {
        
            }else{
                var startDate = Date()
                let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
                dropdownData.append(["title" : "\(dropdownQuestionTextField.text!)"])
                dropdownData.append(["option" : dropdownOptionArray])
                dynamicArray.append(["\(appDelegate.uniqueID!)_\(startTimeStamp)_Dropdown" : dropdownData])
                dropdownData.removeAll()
                dropdownOptionArray.removeAll()
                dropdownQuestionTextField.resignFirstResponder()
                dropdownOptionTableView.reloadData()
                tableView.reloadData()
                dropdownContainer.alpha = 0
                selectOptionContainer.alpha = 0
                dropdownQuestionTextField.text = ""
                print(dynamicArray)
            }
        }
    }
    
    @IBAction func optionAddBtnPressed(_ sender: Any) {
        
        dropdownOptionArray.append(dropdownOptionTextField.text!)
        self.dropdownOptionTextField.text = ""
        dropdownOptionTextField.resignFirstResponder()
        dropdownOptionTableView.reloadData()
    }
    
    //*********************************************************
    
    //**********************************UploadFile*****************
    
    @IBAction func uploadSubmitBtnPressed(_ sender: Any) {
        
        if isEdit{
            if uploadTittleTextField.text?.count == 0 {
        
            }
            if uploadMaxSizeFileTextField.text?.count == 0 {
        
            }
            else{
                uploadTittleTextField.resignFirstResponder()
                uploadFileTypeValueLbl.resignFirstResponder()
                uploadMaxSizeFileTextField.resignFirstResponder()
                fileUploadData.append(["title" : "\(uploadTittleTextField.text!)"])
                fileUploadData.append(["fileType" : "\(uploadFileTypeValueLbl.text!)"])
                fileUploadData.append(["fileSize" : "\(uploadMaxSizeFileTextField.text!)"])
                fileUploadData.append(["accecptableFile" : "\(accecptableFileDefaultValue)"])
                let val = "\(dynamicArray[editIndexNumber].first!.key)"
                dynamicArray.insert(["\(val)" : fileUploadData], at: editIndexNumber)
                dynamicArray.remove(at: editIndexNumber + 1)
                fileUploadData.removeAll()
                tableView.reloadData()
                uploadContainer.alpha = 0
                selectOptionContainer.alpha = 0
                uploadTittleTextField.text = ""
                uploadFileTypeValueLbl.text = ""
                uploadMaxSizeFileTextField.text = ""
                print(dynamicArray)
            }
            self.isEdit = false
        }else{
            if uploadTittleTextField.text?.count == 0 {
        
            }
            if uploadMaxSizeFileTextField.text?.count == 0 {
        
            }
            else{
                uploadTittleTextField.resignFirstResponder()
                uploadFileTypeValueLbl.resignFirstResponder()
                uploadMaxSizeFileTextField.resignFirstResponder()
                var startDate = Date()
                let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
                fileUploadData.append(["title" : "\(uploadTittleTextField.text!)"])
                fileUploadData.append(["fileType" : "\(uploadFileTypeValueLbl.text!)"])
                fileUploadData.append(["fileSize" : "\(uploadMaxSizeFileTextField.text!)"])
                fileUploadData.append(["accecptableFile" : "\(accecptableFileDefaultValue)"])
                dynamicArray.append(["\(appDelegate.uniqueID!)_\(startTimeStamp)_File" : fileUploadData])
                fileUploadData.removeAll()
                tableView.reloadData()
                uploadContainer.alpha = 0
                selectOptionContainer.alpha = 0
                uploadTittleTextField.text = ""
                uploadFileTypeValueLbl.text = ""
                uploadMaxSizeFileTextField.text = ""
                print(dynamicArray)
            }
        }
    }
    @IBAction func uploadCancelBtnPressed(_ sender: Any) {
        if isEdit{
            self.isEdit = false
            uploadTittleTextField.resignFirstResponder()
            uploadFileTypeValueLbl.resignFirstResponder()
            uploadMaxSizeFileTextField.resignFirstResponder()
            uploadContainer.alpha = 0
            selectOptionContainer.alpha = 0
        }else{
            uploadTittleTextField.resignFirstResponder()
            uploadFileTypeValueLbl.resignFirstResponder()
            uploadMaxSizeFileTextField.resignFirstResponder()
            uploadContainer.alpha = 0
            selectOptionContainer.alpha = 1
        }
    }
    
    @IBAction func uploadFileTypeDropDownPressed(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func accecptableFileFirstBtnClicked(_ sender: Any) {
        self.accecptableFileDefaultValue = "Single"
        self.accecptableFileFirstImageView.image = UIImage(named:"radio_button_select")
        self.accecptableFileSecondImageView.image = UIImage(named:"radio_button_unselect")
    }
    
    @IBAction func accecptableFileSecondBtnClicked(_ sender: Any) {
        self.accecptableFileDefaultValue = "Multiple"
        self.accecptableFileFirstImageView.image = UIImage(named:"radio_button_unselect")
        self.accecptableFileSecondImageView.image = UIImage(named:"radio_button_select")
    }
    
    //**************************************************************
    
    //**********************************DatePicker*****************
    
    @IBAction func datePickerSubmitBtnPressed(_ sender: Any) {
       
        if isEdit{
            if datepickerTittleTextField.text?.count == 0 {
        
            }else{
                datepickerTittleTextField.resignFirstResponder()
                datePickerData.append(["title" : "\(datepickerTittleTextField.text!)"])
                datePickerData.append(["dateFormat" : "\(dateFormatValue)"])
                datePickerData.append(["defaultValue" : "\(datePickerDefaultValue)"])
                let val = "\(dynamicArray[editIndexNumber].first!.key)"
                dynamicArray.insert(["\(val)" : datePickerData], at: editIndexNumber)
                dynamicArray.remove(at: editIndexNumber + 1)
                datePickerData.removeAll()
                tableView.reloadData()
                datepickerView.alpha = 0
                selectOptionContainer.alpha = 0
                datepickerTittleTextField.text = ""
                print(dynamicArray)
            }
            self.isEdit = false
        }else{
            if datepickerTittleTextField.text?.count == 0 {
        
            }else{
                datepickerTittleTextField.resignFirstResponder()
                var startDate = Date()
                let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
                datePickerData.append(["title" : "\(datepickerTittleTextField.text!)"])
                datePickerData.append(["dateFormat" : "\(dateFormatValue)"])
                datePickerData.append(["defaultValue" : "\(datePickerDefaultValue)"])
                dynamicArray.append(["\(appDelegate.uniqueID!)_\(startTimeStamp)_Date" : datePickerData])
                datePickerData.removeAll()
                tableView.reloadData()
                datepickerView.alpha = 0
                selectOptionContainer.alpha = 0
                datepickerTittleTextField.text = ""
                print(dynamicArray)
            }
        }
    }
    
    @IBAction func datepickerCancelBtnPressed(_ sender: Any) {
        if isEdit{
            self.isEdit = false
            datepickerTittleTextField.resignFirstResponder()
            datepickerView.alpha = 0
            selectOptionContainer.alpha = 0
        }else{
            datepickerTittleTextField.resignFirstResponder()
            datepickerView.alpha = 0
            selectOptionContainer.alpha = 1
        }
    }
    
    @IBAction func dateFormatFirstBtnClicked(_ sender: Any) {
        self.dateFormatValue = "DD-MM-YYYY"
        self.dateFormatFirstImageView.image = UIImage(named:"radio_button_select")
        self.dateFormatSecondImageView.image = UIImage(named:"radio_button_unselect")
    }
    
    @IBAction func dateFormatSecondBtnClicked(_ sender: Any) {
        self.dateFormatValue = "MM-DD-YYYY"
        self.dateFormatFirstImageView.image = UIImage(named:"radio_button_unselect")
        self.dateFormatSecondImageView.image = UIImage(named:"radio_button_select")
    }
    
    @IBAction func defaultValueFirstBtnClicked(_ sender: Any) {
        self.datePickerDefaultValue = "None"
        self.defaultvalueFirstImageView.image = UIImage(named:"radio_button_select")
        self.defaultValueSecondImageView.image = UIImage(named:"radio_button_unselect")
    }
    @IBAction func defaultValueSecondBtnClicked(_ sender: Any) {
        self.datePickerDefaultValue = "Today"
        self.defaultvalueFirstImageView.image = UIImage(named:"radio_button_unselect")
        self.defaultValueSecondImageView.image = UIImage(named:"radio_button_select")
    }
    
    //****************************************************************
    
    //**********************************SingleChoice*****************
    @IBAction func singleChoiceSubmitBtnPressed(_ sender: Any) {
        
        if isEdit{
            if singleChoiceTittleTextField.text?.count == 0 {
        
            }else{
                singleChoiceData.append(["title" : "\(singleChoiceTittleTextField.text!)"])
                singleChoiceData.append(["option" : singleChoiceOptionArray])
                let val = "\(dynamicArray[editIndexNumber].first!.key)"
                dynamicArray.insert(["\(val)" : singleChoiceData], at: editIndexNumber)
                dynamicArray.remove(at: editIndexNumber + 1)
                singleChoiceData.removeAll()
                singleChoiceOptionArray.removeAll()
                singleChoiceTittleTextField.resignFirstResponder()
                singleChoiceTableView.reloadData()
                tableView.reloadData()
                singleChoiceContainer.alpha = 0
                selectOptionContainer.alpha = 0
                singleChoiceTittleTextField.text = ""
                print(dynamicArray)
            }
            self.isEdit = false
        }else{
            if singleChoiceTittleTextField.text?.count == 0 {
        
            }else{
                var startDate = Date()
                let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
                singleChoiceData.append(["title" : "\(singleChoiceTittleTextField.text!)"])
                singleChoiceData.append(["option" : singleChoiceOptionArray])
                dynamicArray.append(["\(appDelegate.uniqueID!)_\(startTimeStamp)_SingleChoice" : singleChoiceData])
                singleChoiceData.removeAll()
                singleChoiceOptionArray.removeAll()
                singleChoiceTittleTextField.resignFirstResponder()
                singleChoiceTableView.reloadData()
                tableView.reloadData()
                singleChoiceContainer.alpha = 0
                selectOptionContainer.alpha = 0
                singleChoiceTittleTextField.text = ""
                print(dynamicArray)
            }
        }
        
    }
    @IBAction func singleChoiceCancelBtnPressed(_ sender: Any) {
        if isEdit{
            self.isEdit = false
            singleChoiceTittleTextField.resignFirstResponder()
            singleChoiceOptionTextField.resignFirstResponder()
            self.singleChoiceOptionArray.removeAll()
            singleChoiceContainer.alpha = 0
            selectOptionContainer.alpha = 0
            self.singleChoiceTableView.reloadData()
        }else{
            singleChoiceTittleTextField.resignFirstResponder()
            singleChoiceOptionTextField.resignFirstResponder()
            self.singleChoiceOptionArray.removeAll()
            singleChoiceContainer.alpha = 0
            selectOptionContainer.alpha = 1
            self.singleChoiceTableView.reloadData()
        }
    }
    @IBAction func singleChoiceOptionAddBtnPressed(_ sender: Any) {
        singleChoiceOptionArray.append(singleChoiceOptionTextField.text!)
        self.singleChoiceOptionTextField.text = ""
        singleChoiceOptionTextField.resignFirstResponder()
        singleChoiceTableView.reloadData()
    }
    
    //**********************************************************
    
    //**********************************MultipleChoice*****************
    
    @IBAction func multipleChoiceSubmitBtnPressed(_ sender: Any) {

        if isEdit{
            if multipleChoiceTittleTextField.text?.count == 0 {
        
            }else{
                multipleChoiceData.append(["title" : "\(multipleChoiceTittleTextField.text!)"])
                multipleChoiceData.append(["option" : multipleChoiceOptionArray])
                let val = "\(dynamicArray[editIndexNumber].first!.key)"
                dynamicArray.insert(["\(val)" : multipleChoiceData], at: editIndexNumber)
                dynamicArray.remove(at: editIndexNumber + 1)
                multipleChoiceData.removeAll()
                multipleChoiceOptionArray.removeAll()
                multipleChoiceTittleTextField.resignFirstResponder()
                self.multipleChoiceTableView.reloadData()
                tableView.reloadData()
                multipleChoiceContainer.alpha = 0
                selectOptionContainer.alpha = 0
                multipleChoiceTittleTextField.text = ""
                print(dynamicArray)
            }
            self.isEdit = false
        }else{
            if multipleChoiceTittleTextField.text?.count == 0 {
        
            }else{
                var startDate = Date()
                let startTimeStamp : Int = Int(startDate.timeIntervalSince1970)
                multipleChoiceData.append(["title" : "\(multipleChoiceTittleTextField.text!)"])
                multipleChoiceData.append(["option" : multipleChoiceOptionArray])
                dynamicArray.append(["\(appDelegate.uniqueID!)_\(startTimeStamp)_MultipleChoice" : multipleChoiceData])
                multipleChoiceData.removeAll()
                multipleChoiceOptionArray.removeAll()
                multipleChoiceTittleTextField.resignFirstResponder()
                self.multipleChoiceTableView.reloadData()
                tableView.reloadData()
                multipleChoiceContainer.alpha = 0
                selectOptionContainer.alpha = 0
                multipleChoiceTittleTextField.text = ""
                print(dynamicArray)
            }
        }
    }
    
    @IBAction func multipleChoiceCancelBtnPressed(_ sender: Any) {
        if isEdit{
            self.isEdit = false
            multipleChoiceTittleTextField.resignFirstResponder()
            multipleChoiceOptionTextField.resignFirstResponder()
            self.multipleChoiceOptionArray.removeAll()
            multipleChoiceContainer.alpha = 0
            selectOptionContainer.alpha = 0
            self.multipleChoiceTableView.reloadData()
        }else{
            multipleChoiceTittleTextField.resignFirstResponder()
            multipleChoiceOptionTextField.resignFirstResponder()
            self.multipleChoiceOptionArray.removeAll()
            multipleChoiceContainer.alpha = 0
            selectOptionContainer.alpha = 1
            self.multipleChoiceTableView.reloadData()
        }
    }
    
    @IBAction func multipleChoiceOptionAddBtnPressed(_ sender: Any) {
        multipleChoiceOptionArray.append(multipleChoiceOptionTextField.text!)
        self.multipleChoiceOptionTextField.text = ""
        multipleChoiceOptionTextField.resignFirstResponder()
        multipleChoiceTableView.reloadData()
    }
    //****************************************************************
    
    //*************************************************************
    
    
//    @IBAction func questionSubmitBtn(_ sender: Any) {
//
//        if isFile == true{
//            if textFieldQuestionTextField.text?.count == 0 {
//
//            }else{
//                self.isFile = false
//                questionArray.append(textFieldQuestionTextField.text ?? "Empty")
//                typeArray.append("File")
//                combineArray.append(["\(textFieldQuestionTextField.text!)" : "File"])
//                textFieldQuestionTextField.resignFirstResponder()
//                tableView.reloadData()
//            }
//        }else{
//            if textFieldQuestionTextField.text?.count == 0 {
//
//            }else{
//                questionArray.append(textFieldQuestionTextField.text ?? "Empty")
//                typeArray.append("Text")
//                combineArray.append(["\(textFieldQuestionTextField.text!)" : "Text"])
//                textFieldQuestionTextField.resignFirstResponder()
//                tableView.reloadData()
//            }
//        }
//    }
    @IBAction func backBtn(_ sender: Any) {
        appDelegate.isFullFormView = false
        self.navigationController?.popToRootViewController(animated: true)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
//
////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//
//        let navCon = UINavigationController.init(rootViewController: loginVC!)
//        navCon.navigationBar.isHidden = true
//        navCon.toolbar.isHidden = true
//        appDelegate.window?.rootViewController = navCon
//        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func formSubmisionButton(_ sender: Any) {
        if (self.dynamicArray.count == 0){
            appDelegate.myDatePicker.showSingleButtonAlert(message: "You can't submit empty form", okText: "Ok", vc: self)
            return
        }
        appDelegate.combineArray = self.dynamicArray
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createDateTimeViewController = storyboard.instantiateViewController(withIdentifier: "CreateDateTimeViewController") as? CreateDateTimeViewController
        self.navigationController?.pushViewController(createDateTimeViewController!, animated: true)
        
//        LoadingIndicatorView.show()
//        var path: String = "\(appDelegate.uniqueID!)/\("Form")/\((self.formNameField.text?.replacingOccurrences(of: " ", with: ""))!)"
//        var path2: String = "\(appDelegate.uniqueID!)\((self.formNameField.text?.replacingOccurrences(of: " ", with: ""))!)"
//        let credential = ["data" : questionArray]
//        self.ref.child(path).setValue(credential)
//        self.ref.child(path2).setValue(credential)
//        LoadingIndicatorView.hide()
//        self.navigationController?.popViewController(animated: true)
        
    }
    
}



extension FormBuilderViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFullFormView{
            if tableView == self.tableView{
                return dynamicArray.count
            }
            else if(tableView == self.dropdownOptionTableView){
                print(dropdownOptionArray.count)
                if (dropdownOptionArray.count == 0){
                    self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
                }
                return dropdownOptionArray.count
            }
            else if(tableView == self.singleChoiceTableView){
                print(singleChoiceOptionArray.count)
                if (singleChoiceOptionArray.count == 0){
                    self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
                }
                return singleChoiceOptionArray.count
            }
            else if(tableView == self.multipleChoiceTableView){
                print(multipleChoiceOptionArray.count)
                if (multipleChoiceOptionArray.count == 0){
                    self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
                }
                return multipleChoiceOptionArray.count
            }
            else{
                return 0
            }
        }else{
            if tableView == self.tableView{
                return dynamicArray.count
            }
            else if(tableView == self.dropdownOptionTableView){
                print(dropdownOptionArray.count)
                if (dropdownOptionArray.count == 0){
                    self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
                }
                return dropdownOptionArray.count
            }
            else if(tableView == self.singleChoiceTableView){
                print(singleChoiceOptionArray.count)
                if (singleChoiceOptionArray.count == 0){
                    self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
                }
                return singleChoiceOptionArray.count
            }
            else if(tableView == self.multipleChoiceTableView){
                print(multipleChoiceOptionArray.count)
                if (multipleChoiceOptionArray.count == 0){
                    self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
                }
                return multipleChoiceOptionArray.count
            }
            else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFullFormView{
            if tableView == self.tableView{
                if dynamicArray.count > 0{
                    let fullString = dynamicArray[indexPath.row].keys.first!
                    var afterEqualsTo = ""
                    if let index = fullString.range(of: "_", options: .backwards)?.upperBound {
                        afterEqualsTo = String(fullString.suffix(from: index))
                    }
                    if ("\(afterEqualsTo)" == "Text"){
                        let cellTextField: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                        cellTextField.ansTextField.alpha = 1
                        cellTextField.deteteButton.tag = indexPath.row + 1
                        cellTextField.cellEditBtn.tag = indexPath.row + 1
                        cellTextField.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellTextField.didUpdate = { [weak self] tag in
                            var textDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            self?.textFieldQuestionTextField.text = (textDataValue?[0]["title"])! as? String
                            self?.textFieldPlaceholderTextField.text = (textDataValue?[1]["placeholder"])! as? String
                            self?.textFieldContainer.alpha = 1
                            textDataValue?.removeAll()
                            
                        }
                        var textDataValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        print((textDataValue?[0]["title"])! as! String)
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((textDataValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellTextField.questionName.text = stringWithExtraSpace
                        //cellTextField.questionName.text = (textDataValue?[0]["tittle"])! as? String
                        cellTextField.questionName.numberOfLines = 0
                        cellTextField.questionName.adjustsFontSizeToFitWidth = true
                        cellTextField.questionName.sizeToFit()
                        cellTextField.ansTextField.placeholder = (textDataValue?[1]["placeholder"])! as? String
                        textDataValue?.removeAll()
                        return cellTextField
                    }
                    else if("\(afterEqualsTo)" == "File"){
                        let cellFile: UploadFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UploadFileTableViewCell", for: indexPath) as! UploadFileTableViewCell
                        cellFile.deleteBtn.tag = indexPath.row + 1
                        cellFile.editBtn.tag = indexPath.row + 1
                        cellFile.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellFile.didUpdate = { [weak self] tag in
                            var fileUploadValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            self?.uploadTittleTextField.text = fileUploadValue?[0]["title"] as? String
                            self?.uploadMaxSizeFileTextField.text = (fileUploadValue?[2]["fileSize"]) as? String
                            self?.uploadContainer.alpha = 1
                            if ((fileUploadValue?[3]["accecptableFile"])! as? String == "Single"){
                                self?.accecptableFileFirstImageView.image = UIImage(named:"radio_button_select")
                                self?.accecptableFileSecondImageView.image = UIImage(named:"radio_button_unselect")
                            }else{
                                self?.accecptableFileSecondImageView.image = UIImage(named:"radio_button_select")
                                self?.accecptableFileFirstImageView.image = UIImage(named:"radio_button_unselect")
                            }
                            fileUploadValue?.removeAll()
                        }
                        var fileUploadValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        cellFile.uploadFileMaxSize.text = "Maximum Size \((fileUploadValue?[2]["fileSize"])! as! String)MB"

                        
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((fileUploadValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellFile.fileUploadTittleLbl.text = stringWithExtraSpace
                        //cellFile.fileUploadTittleLbl.text = fileUploadValue?[0]["tittle"] as? String
                        cellFile.fileUploadTittleLbl.numberOfLines = 0
                        cellFile.fileUploadTittleLbl.adjustsFontSizeToFitWidth = true
                        cellFile.fileUploadTittleLbl.sizeToFit()
                        fileUploadValue?.removeAll()
                        return cellFile
                    }
                    else if("\(afterEqualsTo)" == "Date"){
                        let cellDatepicker: DatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
                        cellDatepicker.datePickerDeleteBtn.tag = indexPath.row + 1
                        cellDatepicker.datePickerEditBtn.tag = indexPath.row + 1
                        cellDatepicker.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellDatepicker.didUpdate = { [weak self] tag in
                            var datePickerValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            self?.datepickerTittleTextField.text = datePickerValue?[0]["title"] as? String
                            if ((datePickerValue?[1]["dateFormat"])! as? String == "DD-MM-YYYY"){
                                self?.dateFormatFirstImageView.image = UIImage(named:"radio_button_select")
                                self?.dateFormatSecondImageView.image = UIImage(named:"radio_button_unselect")
                            }else{
                                self?.dateFormatSecondImageView.image = UIImage(named:"radio_button_select")
                                self?.dateFormatFirstImageView.image = UIImage(named:"radio_button_unselect")
                            }
                            if ((datePickerValue?[2]["defaultValue"])! as? String == "None"){
                                self?.defaultvalueFirstImageView.image = UIImage(named:"radio_button_select")
                                self?.defaultValueSecondImageView.image = UIImage(named:"radio_button_unselect")
                            }else{
                                self?.defaultValueSecondImageView.image = UIImage(named:"radio_button_select")
                                self?.defaultvalueFirstImageView.image = UIImage(named:"radio_button_unselect")
                            }
                            self?.datepickerView.alpha = 1
                            datePickerValue?.removeAll()
                        }
                        var datePickerValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        cellDatepicker.dateTextField.text = (datePickerValue?[1]["dateFormat"])! as? String
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((datePickerValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDatepicker.datepickerCellTittle.text = stringWithExtraSpace
                        //cellDatepicker.datepickerCellTittle.text = datePickerValue?[0]["tittle"] as? String
                        cellDatepicker.datepickerCellTittle.numberOfLines = 0
                        cellDatepicker.datepickerCellTittle.adjustsFontSizeToFitWidth = true
                        cellDatepicker.datepickerCellTittle.sizeToFit()
                        datePickerValue?.removeAll()
                        return cellDatepicker
                    }
                    else if("\(afterEqualsTo)" == "Dropdown"){
                        let cellDropdown: DropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell", for: indexPath) as! DropdownTableViewCell
                        cellDropdown.dropdownEditBtn.tag = indexPath.row + 1
                        cellDropdown.dropdownDeleteBtn.tag = indexPath.row + 1
                        cellDropdown.dropdownOptionBtn.tag = indexPath.row + 1
                        cellDropdown.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellDropdown.didUpdate = { [weak self] tag in
                            var dropdownValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.dropdownQuestionTextField.text = dropdownValue?[0]["title"] as? String
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            var dropdownOptionValue = dropdownValue![1]["option"]! as? [String]
                            self?.dropdownOptionArray = dropdownOptionValue!
                            self?.dropdownOptionTextField.text = ""
                            self?.dropdownOptionTextField.resignFirstResponder()
                            self?.dropdownOptionTableView.reloadData()
                            self?.dropdownContainer.alpha = 1
                            dropdownOptionValue?.removeAll()
                            dropdownValue?.removeAll()
                            //  self?.dropdownOptionArray.removeAll()
                            
                        }
                        
                        var dropdownValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((dropdownValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDropdown.dropdownTittleLbl.text = stringWithExtraSpace
                        //cellDropdown.dropdownTittleLbl.text = dropdownValue?[0]["tittle"] as? String
                        cellDropdown.dropdownTittleLbl.numberOfLines = 0
                        cellDropdown.dropdownTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDropdown.dropdownTittleLbl.sizeToFit()
                        let dropdownOptionValue = dropdownValue![1]["option"]! as? [String]
    //                    dropdownOptionDropdown.anchorView = cellDropdown.dropdownOptionView
    //                    dropdownOptionDropdown.dataSource = dropdownOptionValue!
    //                    dropdownOptionDropdown.direction = .bottom
                    
                        cellDropdown.didOption = { [weak self] tag in
                            cellDropdown.dropdownOptionDropdown.show()
                            cellDropdown.dropdownOptionDropdown.dataSource = dropdownOptionValue!
                            cellDropdown.dropdownOptionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                              print("Selected item: \(item) at index: \(index)")
                                cellDropdown.dropdownOptionTextField.text = dropdownOptionValue![index]
                            }
                        }
                        dropdownValue?.removeAll()
                        return cellDropdown
                    }
                    
                    else if("\(afterEqualsTo)" == "SingleChoice"){
                        let cellSingleChoice: SingleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleChoiceTableViewCell", for: indexPath) as! SingleChoiceTableViewCell
                        appDelegate.formBuilderSingleChoice = []
                        var singleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((singleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellSingleChoice.singleChoiceTittleLbl.text = stringWithExtraSpace
                        //cellSingleChoice.singleChoiceTittleLbl.text = singleChoiceValue?[0]["tittle"] as? String
                        cellSingleChoice.singleChoiceTittleLbl.numberOfLines = 0
                        cellSingleChoice.singleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
                        cellSingleChoice.singleChoiceTittleLbl.sizeToFit()
                        var singleChoiceOptionValue = singleChoiceValue![1]["option"]! as? [String]
                        appDelegate.formBuilderSingleChoice = singleChoiceOptionValue!
                        cellSingleChoice.loadData()
                        print(singleChoiceOptionValue!)
                        cellSingleChoice.singleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        cellSingleChoice.cellView.frame.size.height = CGFloat(40 + (50 * singleChoiceOptionValue!.count))
                        cellSingleChoice.subCellView.frame.size.height = CGFloat(40 + (50 * singleChoiceOptionValue!.count))
                        cellSingleChoice.subCellView2.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        cellSingleChoice.singleChoiceDeleteBtn.tag = indexPath.row + 1
                        cellSingleChoice.singleChoiceEditBtn.tag = indexPath.row + 1
                        cellSingleChoice.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellSingleChoice.didUpdate = { [weak self] tag in
                            var singleChoiceEditValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.singleChoiceTittleTextField.text = singleChoiceEditValue?[0]["title"] as? String
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            var singleChoiceOptionEditValue = singleChoiceEditValue![1]["option"]! as? [String]
                            self?.singleChoiceOptionArray = singleChoiceOptionEditValue!
                            self?.singleChoiceOptionTextField.text = ""
                            self?.singleChoiceOptionTextField.resignFirstResponder()
                            self?.singleChoiceTableView.reloadData()
                            self?.singleChoiceContainer.alpha = 1
                            singleChoiceEditValue?.removeAll()
                            singleChoiceOptionEditValue?.removeAll()
                        }
                        singleChoiceOptionValue?.removeAll()
                        singleChoiceValue?.removeAll()
                        return cellSingleChoice
                    }
                    
                    else if("\(afterEqualsTo)" == "MultipleChoice"){
                        let cellMultipleChoice: MultipleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultipleChoiceTableViewCell", for: indexPath) as! MultipleChoiceTableViewCell
                        appDelegate.formBuilderMultipleChoice = []
                        var multipleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((multipleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellMultipleChoice.multipleChoiceTittle.text = stringWithExtraSpace
                       // cellMultipleChoice.multipleChoiceTittle.text = multipleChoiceValue?[0]["tittle"] as? String
                        cellMultipleChoice.multipleChoiceTittle.numberOfLines = 0
                        cellMultipleChoice.multipleChoiceTittle.adjustsFontSizeToFitWidth = true
                        cellMultipleChoice.multipleChoiceTittle.sizeToFit()
                        var multipleChoiceOptionValue = multipleChoiceValue![1]["option"]! as? [String]
                        appDelegate.formBuilderMultipleChoice = multipleChoiceOptionValue!
                        cellMultipleChoice.loadData()
                        print(multipleChoiceOptionValue!)
                        cellMultipleChoice.multipleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.cellBigView.frame.size.height = CGFloat(40 + (50 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.cellBigSubView.frame.size.height = CGFloat(40 + (50 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.cellSmallView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.multipleChoiceDeleteViewBtn.tag = indexPath.row + 1
                        cellMultipleChoice.multipleChoiceEditViewBtn.tag = indexPath.row + 1
                        cellMultipleChoice.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellMultipleChoice.didUpdate = { [weak self] tag in
                            var multipleChoiceEditValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.multipleChoiceTittleTextField.text = multipleChoiceEditValue?[0]["title"] as? String
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            var multipleChoiceOptionEditValue = multipleChoiceEditValue![1]["option"]! as? [String]
                            self?.multipleChoiceOptionArray = multipleChoiceOptionEditValue!
                            self?.multipleChoiceOptionTextField.text = ""
                            self?.multipleChoiceOptionTextField.resignFirstResponder()
                            self?.multipleChoiceTableView.reloadData()
                            self?.multipleChoiceContainer.alpha = 1
                            multipleChoiceEditValue?.removeAll()
                            multipleChoiceOptionEditValue?.removeAll()
                        }
                        multipleChoiceOptionValue?.removeAll()
                        multipleChoiceValue?.removeAll()
                        return cellMultipleChoice
                    }
                    else{
                        let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                        return cell
                    }
                }else{
                    let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                    return cell
                }
                
            }
            
            else if(tableView == self.dropdownOptionTableView){
                let cell: DropdownOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionTableViewCell", for: indexPath) as! DropdownOptionTableViewCell
        
                if (dropdownOptionArray.count > 0){
                    cell.dropdownOptionRemoveBtn.tag = indexPath.row + 1
                    cell.didDelete = { [weak self] tag in
                        self?.dropdownOptionArray.remove(at:tag - 1)
                        self?.dropdownOptionTableView.reloadData()
                    }
                    cell.dropdownOptionNameLbl.text = self.dropdownOptionArray[indexPath.row]
                    self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionTableView.frame.size.height = CGFloat(50 * dropdownOptionArray.count)
                }else{
                    self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionTableView.frame.size.height = CGFloat(50 * dropdownOptionArray.count)
                }
                
                return cell
            }
            
            else if(tableView == self.singleChoiceTableView){
                let cell: SingleChoiceOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleChoiceOptionTableViewCell", for: indexPath) as! SingleChoiceOptionTableViewCell
        
                if (singleChoiceOptionArray.count > 0){
                    cell.singleChoiceOptionRemoveBtn.tag = indexPath.row + 1
                    cell.didDelete = { [weak self] tag in
                        self?.singleChoiceOptionArray.remove(at:tag - 1)
                        self?.singleChoiceTableView.reloadData()
                    }
                    cell.singleChoiceOptionNameLbl.text = self.singleChoiceOptionArray[indexPath.row]
                    self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceTableView.frame.size.height = CGFloat(50 * singleChoiceOptionArray.count)
                }else{
                    self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceTableView.frame.size.height = CGFloat(50 * singleChoiceOptionArray.count)
                }
                
                return cell
            }
            
            else if(tableView == self.multipleChoiceTableView){
                let cell: MultipleChoiceOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultipleChoiceOptionTableViewCell", for: indexPath) as! MultipleChoiceOptionTableViewCell
        
                if (multipleChoiceOptionArray.count > 0){
                    cell.multipleChoiceOptionRemoveBtn.tag = indexPath.row + 1
                    cell.didDelete = { [weak self] tag in
                        self?.multipleChoiceOptionArray.remove(at:tag - 1)
                        self?.multipleChoiceTableView.reloadData()
                    }
                    cell.multipleChoiceOptionNameLbl.text = self.multipleChoiceOptionArray[indexPath.row]
                    self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceTableView.frame.size.height = CGFloat(50 * multipleChoiceOptionArray.count)
                }else{
                    self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceTableView.frame.size.height = CGFloat(50 * multipleChoiceOptionArray.count)
                }
                
                return cell
            }
            
            else{
                let cell: DropdownOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionTableViewCell", for: indexPath) as! DropdownOptionTableViewCell
                return cell
            }
        }else{
            if tableView == self.tableView{
                if dynamicArray.count > 0{
                    let fullString = dynamicArray[indexPath.row].keys.first!
                    var afterEqualsTo = ""
                    if let index = fullString.range(of: "_", options: .backwards)?.upperBound {
                        afterEqualsTo = String(fullString.suffix(from: index))
                    }
                    if ("\(afterEqualsTo)" == "Text"){
                        let cellTextField: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                        cellTextField.ansTextField.alpha = 1
                        cellTextField.deteteButton.tag = indexPath.row + 1
                        cellTextField.cellEditBtn.tag = indexPath.row + 1
                        cellTextField.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellTextField.didUpdate = { [weak self] tag in
                            
                            var textDataValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            self?.textFieldQuestionTextField.text = (textDataValue?[0]["title"])! as? String
                            self?.textFieldPlaceholderTextField.text = (textDataValue?[1]["placeholder"])! as? String
                            self?.textFieldContainer.alpha = 1
                            textDataValue?.removeAll()
                        }
                        var textDataValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        print((textDataValue?[0]["title"])! as! String)
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((textDataValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellTextField.questionName.text = stringWithExtraSpace
                        //cellTextField.questionName.text = (textDataValue?[0]["tittle"])! as? String
                        cellTextField.questionName.numberOfLines = 0
                        cellTextField.questionName.adjustsFontSizeToFitWidth = true
                        cellTextField.questionName.sizeToFit()
                        cellTextField.ansTextField.placeholder = (textDataValue?[1]["placeholder"])! as? String
                        textDataValue?.removeAll()
                        return cellTextField
                    }
                    else if("\(afterEqualsTo)" == "File"){
                        let cellFile: UploadFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UploadFileTableViewCell", for: indexPath) as! UploadFileTableViewCell
                        cellFile.deleteBtn.tag = indexPath.row + 1
                        cellFile.editBtn.tag = indexPath.row + 1
                        cellFile.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellFile.didUpdate = { [weak self] tag in
                            var fileUploadValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            self?.uploadTittleTextField.text = fileUploadValue?[0]["title"] as? String
                            self?.uploadMaxSizeFileTextField.text = (fileUploadValue?[2]["fileSize"]) as? String
                            self?.uploadContainer.alpha = 1
                            fileUploadValue?.removeAll()
                        }
                        var fileUploadValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        cellFile.uploadFileMaxSize.text = "Maximum Size \((fileUploadValue?[2]["fileSize"])! as! String)MB"
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((fileUploadValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellFile.fileUploadTittleLbl.text = stringWithExtraSpace
                        //cellFile.fileUploadTittleLbl.text = fileUploadValue?[0]["tittle"] as? String
                        cellFile.fileUploadTittleLbl.numberOfLines = 0
                        cellFile.fileUploadTittleLbl.adjustsFontSizeToFitWidth = true
                        cellFile.fileUploadTittleLbl.sizeToFit()
                        fileUploadValue?.removeAll()
                        return cellFile
                    }
                    else if("\(afterEqualsTo)" == "Date"){
                        let cellDatepicker: DatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
                        cellDatepicker.datePickerDeleteBtn.tag = indexPath.row + 1
                        cellDatepicker.datePickerEditBtn.tag = indexPath.row + 1
                        cellDatepicker.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellDatepicker.didUpdate = { [weak self] tag in
                            var datePickerValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            self?.datepickerTittleTextField.text = datePickerValue?[0]["title"] as? String
                            if ((datePickerValue?[1]["dateFormat"])! as? String == "DD-MM-YYYY"){
                                self?.dateFormatFirstImageView.image = UIImage(named:"radio_button_select")
                                self?.dateFormatSecondImageView.image = UIImage(named:"radio_button_unselect")
                            }else{
                                self?.dateFormatSecondImageView.image = UIImage(named:"radio_button_select")
                                self?.dateFormatFirstImageView.image = UIImage(named:"radio_button_unselect")
                            }
                            if ((datePickerValue?[2]["defaultValue"])! as? String == "None"){
                                self?.defaultvalueFirstImageView.image = UIImage(named:"radio_button_select")
                                self?.defaultValueSecondImageView.image = UIImage(named:"radio_button_unselect")
                            }else{
                                self?.defaultValueSecondImageView.image = UIImage(named:"radio_button_select")
                                self?.defaultvalueFirstImageView.image = UIImage(named:"radio_button_unselect")
                            }
                            self?.datepickerView.alpha = 1
                            datePickerValue?.removeAll()
                        }
                        var datePickerValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        cellDatepicker.dateTextField.text = (datePickerValue?[1]["dateFormat"])! as? String
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((datePickerValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDatepicker.datepickerCellTittle.text = stringWithExtraSpace
                        //cellDatepicker.datepickerCellTittle.text = datePickerValue?[0]["tittle"] as? String
                        cellDatepicker.datepickerCellTittle.numberOfLines = 0
                        cellDatepicker.datepickerCellTittle.adjustsFontSizeToFitWidth = true
                        cellDatepicker.datepickerCellTittle.sizeToFit()
                        datePickerValue?.removeAll()
                        return cellDatepicker
                    }
                    else if("\(afterEqualsTo)" == "Dropdown"){
                        let cellDropdown: DropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell", for: indexPath) as! DropdownTableViewCell
                        cellDropdown.dropdownEditBtn.tag = indexPath.row + 1
                        cellDropdown.dropdownDeleteBtn.tag = indexPath.row + 1
                        cellDropdown.dropdownOptionBtn.tag = indexPath.row + 1
                        cellDropdown.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellDropdown.didUpdate = { [weak self] tag in
                            var dropdownValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.dropdownQuestionTextField.text = dropdownValue?[0]["title"] as? String
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            var dropdownOptionValue = dropdownValue![1]["option"]! as? [String]
                            self?.dropdownOptionArray = dropdownOptionValue!
                            self?.dropdownOptionTextField.text = ""
                            self?.dropdownOptionTextField.resignFirstResponder()
                            self?.dropdownOptionTableView.reloadData()
                            self?.dropdownContainer.alpha = 1
                            dropdownOptionValue?.removeAll()
                            dropdownValue?.removeAll()
                        }
                        
                        var dropdownValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((dropdownValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellDropdown.dropdownTittleLbl.text = stringWithExtraSpace
                        //cellDropdown.dropdownTittleLbl.text = dropdownValue?[0]["tittle"] as? String
                        cellDropdown.dropdownTittleLbl.numberOfLines = 0
                        cellDropdown.dropdownTittleLbl.adjustsFontSizeToFitWidth = true
                        cellDropdown.dropdownTittleLbl.sizeToFit()
                        let dropdownOptionValue = dropdownValue![1]["option"]! as? [String]
    //                    dropdownOptionDropdown.anchorView = cellDropdown.dropdownOptionView
    //                    dropdownOptionDropdown.dataSource = dropdownOptionValue!
    //                    dropdownOptionDropdown.direction = .bottom
                    
                        cellDropdown.didOption = { [weak self] tag in
                            cellDropdown.dropdownOptionDropdown.show()
                            cellDropdown.dropdownOptionDropdown.dataSource = dropdownOptionValue!
                            cellDropdown.dropdownOptionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                              print("Selected item: \(item) at index: \(index)")
                                cellDropdown.dropdownOptionTextField.text = dropdownOptionValue![index]
                            }
                        }
                        dropdownValue?.removeAll()
                        return cellDropdown
                    }
                    else if("\(afterEqualsTo)" == "SingleChoice"){
                        let cellSingleChoice: SingleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleChoiceTableViewCell", for: indexPath) as! SingleChoiceTableViewCell
                        appDelegate.formBuilderSingleChoice = []
                        var singleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((singleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellSingleChoice.singleChoiceTittleLbl.text = stringWithExtraSpace
                        //cellSingleChoice.singleChoiceTittleLbl.text = singleChoiceValue?[0]["tittle"] as? String
                        cellSingleChoice.singleChoiceTittleLbl.numberOfLines = 0
                        cellSingleChoice.singleChoiceTittleLbl.adjustsFontSizeToFitWidth = true
                        cellSingleChoice.singleChoiceTittleLbl.sizeToFit()
                        var singleChoiceOptionValue = singleChoiceValue![1]["option"]! as? [String]
                        appDelegate.formBuilderSingleChoice = singleChoiceOptionValue!
                        cellSingleChoice.loadData()
                        print(singleChoiceOptionValue!)
                        cellSingleChoice.singleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        cellSingleChoice.cellView.frame.size.height = CGFloat(40 + (50 * singleChoiceOptionValue!.count))
                        cellSingleChoice.subCellView.frame.size.height = CGFloat(40 + (50 * singleChoiceOptionValue!.count))
                        cellSingleChoice.subCellView2.frame.size.height = CGFloat(40 + (40 * singleChoiceOptionValue!.count))
                        cellSingleChoice.singleChoiceDeleteBtn.tag = indexPath.row + 1
                        cellSingleChoice.singleChoiceEditBtn.tag = indexPath.row + 1
                        cellSingleChoice.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellSingleChoice.didUpdate = { [weak self] tag in
                            var singleChoiceEditValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.singleChoiceTittleTextField.text = singleChoiceEditValue?[0]["title"] as? String
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            var singleChoiceOptionEditValue = singleChoiceEditValue![1]["option"]! as? [String]
                            self?.singleChoiceOptionArray = singleChoiceOptionEditValue!
                            self?.singleChoiceOptionTextField.text = ""
                            self?.singleChoiceOptionTextField.resignFirstResponder()
                            self?.singleChoiceTableView.reloadData()
                            self?.singleChoiceContainer.alpha = 1
                            singleChoiceEditValue?.removeAll()
                            singleChoiceOptionEditValue?.removeAll()
                        }
                        singleChoiceOptionValue?.removeAll()
                        singleChoiceValue?.removeAll()
                        return cellSingleChoice
                    }
                    else if("\(afterEqualsTo)" == "MultipleChoice"){
                        let cellMultipleChoice: MultipleChoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultipleChoiceTableViewCell", for: indexPath) as! MultipleChoiceTableViewCell
                        appDelegate.formBuilderMultipleChoice = []
                        var multipleChoiceValue = dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                        let stringWithExtraSpace: String = String(repeating: " ", count: 1) + "\((multipleChoiceValue?[0]["title"])!)" + String(repeating: " ", count: 2)
                        cellMultipleChoice.multipleChoiceTittle.text = stringWithExtraSpace
                        //cellMultipleChoice.multipleChoiceTittle.text = multipleChoiceValue?[0]["tittle"] as? String
                        cellMultipleChoice.multipleChoiceTittle.numberOfLines = 0
                        cellMultipleChoice.multipleChoiceTittle.adjustsFontSizeToFitWidth = true
                        cellMultipleChoice.multipleChoiceTittle.sizeToFit()
                        var multipleChoiceOptionValue = multipleChoiceValue![1]["option"]! as? [String]
                        appDelegate.formBuilderMultipleChoice = multipleChoiceOptionValue!
                        cellMultipleChoice.loadData()
                        print(multipleChoiceOptionValue!)
                        cellMultipleChoice.multipleChoiceBorderView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.cellBigView.frame.size.height = CGFloat(40 + (50 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.cellBigSubView.frame.size.height = CGFloat(40 + (50 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.cellSmallView.frame.size.height = CGFloat(40 + (40 * multipleChoiceOptionValue!.count))
                        cellMultipleChoice.multipleChoiceDeleteViewBtn.tag = indexPath.row + 1
                        cellMultipleChoice.multipleChoiceEditViewBtn.tag = indexPath.row + 1
                        cellMultipleChoice.didDelete = { [weak self] tag in
                            self?.dynamicArray.remove(at:tag - 1)
                            self?.tableView.reloadData()
                        }
                        cellMultipleChoice.didUpdate = { [weak self] tag in
                            var multipleChoiceEditValue = self?.dynamicArray[indexPath.row]["\(fullString)"]! as? [[String:Any]]
                            self?.multipleChoiceTittleTextField.text = multipleChoiceEditValue?[0]["title"] as? String
                            self?.isEdit = true
                            self?.editIndexNumber = tag - 1
                            var multipleChoiceOptionEditValue = multipleChoiceEditValue![1]["option"]! as? [String]
                            self?.multipleChoiceOptionArray = multipleChoiceOptionEditValue!
                            self?.multipleChoiceOptionTextField.text = ""
                            self?.multipleChoiceOptionTextField.resignFirstResponder()
                            self?.multipleChoiceTableView.reloadData()
                            self?.multipleChoiceContainer.alpha = 1
                            multipleChoiceEditValue?.removeAll()
                            multipleChoiceOptionEditValue?.removeAll()
                        }
                        multipleChoiceOptionValue?.removeAll()
                        multipleChoiceValue?.removeAll()
                        return cellMultipleChoice
                    }
                    else{
                        let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                        return cell
                    }
                }else{
                    let cell: FormBuilderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormBuilderTableViewCell", for: indexPath) as! FormBuilderTableViewCell
                    return cell
                }
                
            }
            
            else if(tableView == self.dropdownOptionTableView){
                let cell: DropdownOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionTableViewCell", for: indexPath) as! DropdownOptionTableViewCell
        
                if (dropdownOptionArray.count > 0){
                    cell.dropdownOptionRemoveBtn.tag = indexPath.row + 1
                    cell.didDelete = { [weak self] tag in
                        self?.dropdownOptionArray.remove(at:tag - 1)
                        self?.dropdownOptionTableView.reloadData()
                    }
                    cell.dropdownOptionNameLbl.text = self.dropdownOptionArray[indexPath.row]
                    self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionTableView.frame.size.height = CGFloat(50 * dropdownOptionArray.count)
                }else{
                    self.dropdownOptionBorderView.frame.size.height = CGFloat(80 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionView.frame.size.height = CGFloat(94 + (50 * dropdownOptionArray.count))
                    self.dropdownOptionTableView.frame.size.height = CGFloat(50 * dropdownOptionArray.count)
                }
                
                return cell
            }
            
            else if(tableView == self.singleChoiceTableView){
                let cell: SingleChoiceOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleChoiceOptionTableViewCell", for: indexPath) as! SingleChoiceOptionTableViewCell
        
                if (singleChoiceOptionArray.count > 0){
                    cell.singleChoiceOptionRemoveBtn.tag = indexPath.row + 1
                    cell.didDelete = { [weak self] tag in
                        self?.singleChoiceOptionArray.remove(at:tag - 1)
                        self?.singleChoiceTableView.reloadData()
                    }
                    cell.singleChoiceOptionNameLbl.text = self.singleChoiceOptionArray[indexPath.row]
                    self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceTableView.frame.size.height = CGFloat(50 * singleChoiceOptionArray.count)
                }else{
                    self.singleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * singleChoiceOptionArray.count))
                    self.singleChoiceTableView.frame.size.height = CGFloat(50 * singleChoiceOptionArray.count)
                }
                
                return cell
            }
            
            else if(tableView == self.multipleChoiceTableView){
                let cell: MultipleChoiceOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultipleChoiceOptionTableViewCell", for: indexPath) as! MultipleChoiceOptionTableViewCell
        
                if (multipleChoiceOptionArray.count > 0){
                    cell.multipleChoiceOptionRemoveBtn.tag = indexPath.row + 1
                    cell.didDelete = { [weak self] tag in
                        self?.multipleChoiceOptionArray.remove(at:tag - 1)
                        self?.multipleChoiceTableView.reloadData()
                    }
                    cell.multipleChoiceOptionNameLbl.text = self.multipleChoiceOptionArray[indexPath.row]
                    self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceTableView.frame.size.height = CGFloat(50 * multipleChoiceOptionArray.count)
                }else{
                    self.multipleChoiceOptionBorderView.frame.size.height = CGFloat(80 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceOptionView.frame.size.height = CGFloat(94 + (50 * multipleChoiceOptionArray.count))
                    self.multipleChoiceTableView.frame.size.height = CGFloat(50 * multipleChoiceOptionArray.count)
                }
                
                return cell
            }
            
            else{
                let cell: DropdownOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionTableViewCell", for: indexPath) as! DropdownOptionTableViewCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isFullFormView{
            if tableView == self.tableView{
                let fullString = dynamicArray[indexPath.row].keys.first!
                var afterEqualsTo = ""
                if let index = fullString.range(of: "_", options: .backwards)?.upperBound {
                    afterEqualsTo = String(fullString.suffix(from: index))
                }
                if ("\(afterEqualsTo)" == "Text"){
                    return 120
                }else if ("\(afterEqualsTo)" == "File"){
                    return 220
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
            }
            else if(tableView == self.dropdownOptionTableView){
                return 50
            }
            else if(tableView == self.singleChoiceTableView){
                return 50
            }
            else if(tableView == self.multipleChoiceTableView){
                return 50
            }
            else{
                return 0
            }
        }else{
            if tableView == self.tableView{
                let fullString = dynamicArray[indexPath.row].keys.first!
                var afterEqualsTo = ""
                if let index = fullString.range(of: "_", options: .backwards)?.upperBound {
                    afterEqualsTo = String(fullString.suffix(from: index))
                }
        
                if ("\(afterEqualsTo)" == "Text"){
                    return 120
                }else if ("\(afterEqualsTo)" == "File"){
                    return 220
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
            }
            else if(tableView == self.dropdownOptionTableView){
                return 50
            }
            else if(tableView == self.singleChoiceTableView){
                return 50
            }
            else if(tableView == self.multipleChoiceTableView){
                return 50
            }
            else{
                return 0
            }
        }
    }
    
    
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}

extension FormBuilderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: self.view.frame.size.width/3.75, height: self.view.frame.size.width/3.75)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectOptionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectOptionCollectionViewCell", for: indexPath) as! SelectOptionCollectionViewCell
        
        cell.cellTextField.text = elementName[indexPath.row]
        cell.cellImage.image = UIImage(named:"\(elementImage[indexPath.row])")
        cell.cellTextField.font = UIFont(name: "Barlow-Bold", size: 12.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            selectOptionContainer.alpha = 0
            textFieldContainer.alpha = 1
        }
        else if indexPath.row == 1{
            dropdownOptionArray.removeAll()
            selectOptionContainer.alpha = 0
            textFieldContainer.alpha = 0
            dropdownContainer.alpha = 1
        }
        else if indexPath.row == 2 {
            selectOptionContainer.alpha = 0
            datepickerView.alpha = 1
            dropdownContainer.alpha = 0
        }
        else if indexPath.row == 3{
            selectOptionContainer.alpha = 0
            uploadContainer.alpha = 1
        }
        else if indexPath.row == 4{
            selectOptionContainer.alpha = 0
            singleChoiceContainer.alpha = 1
        }
        else if indexPath.row == 5{
            selectOptionContainer.alpha = 0
            multipleChoiceContainer.alpha = 1
        }
        else{
            
        }
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
    
    
}


extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}
extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}
