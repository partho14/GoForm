//
//  MyServeyDetailsViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 22/12/22.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseStorage
import UniformTypeIdentifiers
import PDFKit

class MyServeyDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formEditView: UIView!
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var submitBtnView: UIView!
    @IBOutlet weak var formFillErrorMsg: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    var formNameText: String? = ""
    
    var imagePicker: UIImagePickerController!
    var storageRef: StorageReference!
    var documentPicker: UIDocumentPickerDelegate!
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    
    var pdfDownloadUrl: [String] = []
    var questionArray : [String] = []
    var ansArray: [String] = []
    var questionArray2: [DataSnapshot] = []
    var endInterval: DataSnapshot!
    var filterQuestionArray: [NSDictionary] = []
    var combineArray = [[String:String]]()
    var show: Bool = false
    var shareUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference()
        self.submitBtnView.alpha = 0
        self.formEditView.alpha = 0
        let index = appDelegate.formNameText?.index(appDelegate.formNameText!.startIndex, offsetBy: 21)
        let subString = appDelegate.formNameText?.substring(from: index!)
        self.formName.text = subString
        self.formNameText = appDelegate.formNameText
        LoadingIndicatorView.show()
        docRef = Firestore.firestore().document("")
        self.ref = Database.database().reference()
        self.scrollView.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                 action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.getData()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Database.database().reference().removeAllObservers()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getData(){
        questionArray.removeAll()
        questionArray2.removeAll()
        ansArray.removeAll()
        filterQuestionArray.removeAll()
        self.ref.child(appDelegate.uniqueID!).child("Servey").child(formNameText!).child("data").queryOrderedByKey().observe(.value){ (snapshot)  in
            self.questionArray.removeAll()
            self.ansArray.removeAll()
            self.questionArray2.removeAll()
            for event in snapshot.children.allObjects {
    
                self.questionArray2.append(event as! DataSnapshot)
            }
            print(self.questionArray2)
            self.questionArray.removeAll()
            self.ansArray.removeAll()
            for i in 0 ..< (self.questionArray2.count) {
            
                self.filterQuestionArray.append((self.questionArray2[i].value) as! NSDictionary)
            }
            print(self.filterQuestionArray)
            for i in 0 ..< (self.filterQuestionArray.count) {
                self.combineArray.append(["\((self.filterQuestionArray[i].allKeys)[0])" : "\((self.filterQuestionArray[i].allValues)[0])"])
                self.questionArray.append(((self.filterQuestionArray[i].allKeys)[0]) as! String)
                self.ansArray.append((self.filterQuestionArray[i].allValues)[0] as! String)
            }
            
            print(self.questionArray)
            print(self.ansArray)
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
            
//            print(self.questionArray)
//            self.tableView.reloadData()
//            LoadingIndicatorView.hide()
        }
        
        self.ref.child(formNameText!).child("End").child("Time").queryOrderedByKey().observe(.value){ (snapshot)  in
            self.endInterval = snapshot
            print(self.endInterval.value!)
            
          
            let date = Date(timeIntervalSince1970: self.endInterval.value! as? TimeInterval ?? 0.00)
            
            if date > Date.now {
                self.show = true
            }
            else{
                self.show = false
                
            }
            if self.show == true {
                self.submitBtnView.alpha = 1
                self.formFillErrorMsg.alpha = 0
            }else{
                self.submitBtnView.alpha = 1
                self.submitBtn.alpha = 0
                self.formFillErrorMsg.text = "This Form is Closed"
                self.formFillErrorMsg.alpha = 1
            }
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
        }
        
    }
    
    @IBAction func formReSubmitBtn(_ sender: Any) {
        LoadingIndicatorView.show()
        
        let serveyPath: String = "\(appDelegate.uniqueID!)/\("Servey")/\(appDelegate.formNameText!)"
        let path: String = "\(appDelegate.formNameText!)"
        let path2: String = "\(appDelegate.uniqueID!)"
        print(questionArray.count)
        for i in 0 ..< questionArray.count {
            print(questionArray[i])
            print(ansArray[i])
            self.ref.child(path).child("Servey").child(path2).child("UniqueName").child("Name").setValue("\(appDelegate.currentUserName)")
            self.ref.child(path).child("Servey").child(path2).child("Data").child("\(questionArray[i])").setValue("\(ansArray[i])")
            self.ref.child(serveyPath).child("Data").child("\(questionArray[i])").setValue("\(ansArray[i])")

        }

        LoadingIndicatorView.hide()
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension MyServeyDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyServeyDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyServeyDetailsTableViewCell", for: indexPath) as! MyServeyDetailsTableViewCell
        if questionArray.count > 0{
//            cell.deteteButton.tag = indexPath.row + 1
//            cell.cellEditBtn.tag = indexPath.row + 1
//            cell.didDelete = { [weak self] tag in
//               self?.questionArray.remove(at:tag - 1)
//               self?.tableView.reloadData()
//            }
//            cell.didUpdate = { [weak self] tag in
//                self?.index = indexPath.row
//                self?.formEditView.alpha = 1
//                self?.formEditTextField.text = self?.questionArray[indexPath.row]
//            }
            if ansArray[indexPath.row] == "File"{
                
                
                cell.pdfShowBtn.alpha = 1
                cell.formQuestion.text = questionArray[indexPath.row]
                //cell.formQuestionAns.text = ansArray[indexPath.row]
                cell.addFileView.alpha = 1
                cell.formQuestionAns.alpha = 0
                cell.pdfNameLbl.text = "File.Pdf"
                cell.pdfNameLbl.attributedText = NSAttributedString(string: "File.Pdf", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.pdfNameLbl.alpha = 1
                cell.formQuestionAns.tag = indexPath.row
                cell.didSaveText = { [weak self] tag in
                    self?.index = 0
                    self?.index = indexPath.row
                    print(self?.index)
                    self?.ansArray.remove(at: self!.index)
                    self?.ansArray.insert((cell.formQuestionAns.text)!, at: self!.index)
                    //self?.questionArray2.remove(at: self!.index + 1)
                    //self?.tableView.reloadData()
                }
                cell.didPdfShow = { [weak self] tag in
                    appDelegate.pdfFileUrl =  self!.questionArray[indexPath.row]
                    self?.shareUrl = "\(self!.questionArray[indexPath.row])"
                    self?.fileOpen()
                }
            }else{
                cell.pdfShowBtn.alpha = 0
                cell.pdfNameLbl.alpha = 0
                cell.addFileView.alpha = 0
                cell.formQuestionAns.alpha = 1
                cell.formQuestion.text = questionArray[indexPath.row]
                cell.formQuestionAns.text = ansArray[indexPath.row]
                
                    
                cell.formQuestionAns.tag = indexPath.row
                cell.didSaveText = { [weak self] tag in
                    self?.index = 0
                    self?.index = indexPath.row
                    print(self?.index)
                    self?.ansArray.remove(at: self!.index)
                    self?.ansArray.insert((cell.formQuestionAns.text)!, at: self!.index)
                    //self?.questionArray2.remove(at: self!.index + 1)
                    //self?.tableView.reloadData()
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

    //Create URL to the source file you want to download
        let islandRef = self.storageRef.child(appDelegate.formNameText!).child("\(appDelegate.myFormPdfShowID)\(appDelegate.storeFormName)").child(self.shareUrl).child("File.pdf")
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
