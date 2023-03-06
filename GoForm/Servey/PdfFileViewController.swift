//
//  PdfFileViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 6/1/23.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseStorage
import UniformTypeIdentifiers
import PDFKit

class PdfFileViewController: UIViewController {
    
    var storageRef: StorageReference!
    var pdfFileUrl: String? = ""
    @IBOutlet weak var pdfView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoadingIndicatorView.show()
        storageRef = Storage.storage().reference()
        self.pdfFileUrl  = appDelegate.pdfFileUrl
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicatorView.show()
        self.pdfShow(questionName: self.pdfFileUrl!)
    }
    
    func pdfShow(questionName: String){
        
        if appDelegate.pdfOpenFromServeyList == true {
            
            let islandRef = self.storageRef.child(appDelegate.formNameText!).child("\(appDelegate.myFormPdfShowID)\(appDelegate.storeFormName)").child(questionName).child("File.pdf")
                islandRef.downloadURL { url, error in
                    if let error = error {
                        print(error)
                    } else {
                            let pdfView = PDFView()
                            pdfView.translatesAutoresizingMaskIntoConstraints = false
                            self.pdfView.addSubview(pdfView)

                            pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                            pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                            pdfView.topAnchor.constraint(equalTo: self.pdfView.safeAreaLayoutGuide.topAnchor).isActive = true
                            pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                            

                            if let document = PDFDocument(url: URL.init(string: "\(url!)")!) {
                                pdfView.document = document
                            }
                        LoadingIndicatorView.hide()
                    }
                }
            
        }else{
            
            if appDelegate.sharedFormTotalView{
                
                let index = appDelegate.peopleServeyScreenFormName.index(appDelegate.peopleServeyScreenFormName.startIndex, offsetBy: 28)
                let subString = appDelegate.peopleServeyScreenFormName.substring(from: index)
                let uniqueIdSubString = appDelegate.peopleServeyScreenFormName.take(28)
                print(appDelegate.peoplwServeyUniqueId)
                print(appDelegate.peopleServeyScreenFormName)
                print(uniqueIdSubString)
                //Create URL to the source file you want to download
                let islandRef = self.storageRef.child(appDelegate.peoplwServeyUniqueId).child("\(appDelegate.peopleServeyScreenFormName)").child(questionName).child("File.pdf")
                islandRef.downloadURL { url, error in
                    if let error = error {
                        print(error)
                    } else {
                            let pdfView = PDFView()
                            pdfView.translatesAutoresizingMaskIntoConstraints = false
                            self.pdfView.addSubview(pdfView)

                            pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                            pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                            pdfView.topAnchor.constraint(equalTo: self.pdfView.safeAreaLayoutGuide.topAnchor).isActive = true
                            pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                            

                            if let document = PDFDocument(url: URL.init(string: "\(url!)")!) {
                                pdfView.document = document
                            }
                        LoadingIndicatorView.hide()
                    }
                }
            }else{
                let islandRef = self.storageRef.child(appDelegate.peoplwServeyUniqueId).child("\(appDelegate.uniqueID!)\(appDelegate.peopleServeyScreenFormName)").child(questionName).child("File.pdf")
                islandRef.downloadURL { url, error in
                    if let error = error {
                        print(error)
                    } else {
                            let pdfView = PDFView()
                            pdfView.translatesAutoresizingMaskIntoConstraints = false
                            self.pdfView.addSubview(pdfView)

                            pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                            pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                            pdfView.topAnchor.constraint(equalTo: self.pdfView.safeAreaLayoutGuide.topAnchor).isActive = true
                            pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                            

                            if let document = PDFDocument(url: URL.init(string: "\(url!)")!) {
                                pdfView.document = document
                            }
                        LoadingIndicatorView.hide()
                    }
                }
            }
        }
    }

}
