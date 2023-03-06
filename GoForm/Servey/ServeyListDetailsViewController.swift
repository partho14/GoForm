//
//  ServeyListDetailsViewController.swift
//  GoForm
//
//  Created by Annanovas IT Ltd on 23/12/22.
//

import UIKit
import Firebase
import GoogleSignIn

class ServeyListDetailsViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var formname: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var formNameText: String? = ""
    var storeFormName: String = ""
    
    var storageRef: StorageReference!
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    var ref = DatabaseReference.init()
    var index: Int = 0
    
    var questionArray : [String] = []
    var ansArray: [String] = []
    var questionArray2: [DataSnapshot] = []
    var filterQuestionArray: [NSDictionary] = []
    var combineArray = [[String:String]]()
    var shareUrl: String = ""
    var exectURL: URL!
    var sharedObjects:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if appDelegate.isSharedSubServeyDetails == true{
            let index = appDelegate.storeFormName.index(appDelegate.storeFormName.startIndex, offsetBy: 21)
            let subString = appDelegate.storeFormName.substring(from: index)
            self.formname.text = subString
        }else{
            self.formname.text = appDelegate.storeFormName
        }
        storageRef = Storage.storage().reference()
        self.storeFormName = appDelegate.storeFormName
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
       // appDelegate.isSharedSubServeyDetails = false
    }
    
    func getData(){
        questionArray.removeAll()
        ansArray.removeAll()
        if appDelegate.isSharedSubServeyDetails == true{
            self.ref.child("\(self.storeFormName)/Servey/").child(formNameText!).child("Data").child("data").queryOrderedByKey().observe(.value){ (snapshot)  in
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
            }
        }else{
            self.ref.child("\(appDelegate.uniqueID!)\(self.storeFormName)/Servey/").child(formNameText!).child("Data").child("data").queryOrderedByKey().observe(.value){ (snapshot)  in
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
            }
        }
        
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ServeyListDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServeyListDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ServeyListDetailsTableViewCell", for: indexPath) as! ServeyListDetailsTableViewCell
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
                cell.pdfnameLbl.text = "File.Pdf"
                cell.pdfnameLbl.attributedText = NSAttributedString(string: "File.Pdf", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.pdfnameLbl.alpha = 1
                cell.formQuestionAns.tag = indexPath.row
                cell.didPdfShow = { [weak self] tag in
                    
                    print(self!.questionArray[indexPath.row])
                    appDelegate.pdfFileUrl =  self!.questionArray[indexPath.row]
                    self?.shareUrl = "\(self!.questionArray[indexPath.row])"
                    self?.fileOpen()
                }
            }else{
                cell.pdfShowBtn.alpha = 0
                cell.pdfnameLbl.alpha = 0
                cell.addFileView.alpha = 0
                cell.formQuestionAns.alpha = 1
                cell.formQuestion.text = questionArray[indexPath.row]
                cell.formQuestionAns.text = ansArray[indexPath.row]
                
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
