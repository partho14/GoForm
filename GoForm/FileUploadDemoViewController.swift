//
//  FileUploadDemoViewController.swift
//  GoForm
//
//  Created by Annanovas IT on 4/1/23.
//

import UIKit
import Firebase
import FirebaseStorage
import GoogleSignIn
import UniformTypeIdentifiers

class FileUploadDemoViewController: UIViewController, UIDocumentPickerDelegate {
    
    class baseMakeUp {
        var name: String
        var price: String
        var imageUrl: String
        
        init (Brand: String, Color: String, ImageUrl: String) {
            self.name = Brand
            self.price = Color
            self.imageUrl = ImageUrl
        }
    }

    @IBOutlet weak var addFileView: UIView!{
        didSet{
            addFileView.layer.cornerRadius = 10
            addFileView.layer.borderWidth = 1
            addFileView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    var array : [baseMakeUp?] = []
    @IBOutlet weak var filePathName: UILabel!
    var imagePicker: UIImagePickerController!
    var storageRef: StorageReference!
    var documentPicker: UIDocumentPickerDelegate!
    override func viewDidLoad() {
        array.append(baseMakeUp(Brand: "Toyoto", Color: "250000000", ImageUrl: "vebkjfgckjbdvsgcjkkds"))
        array.append(baseMakeUp(Brand: "BMW", Color: "00000", ImageUrl: "vebkjfgckjbdvsgcjkkds"))
        super.viewDidLoad()
        self.filePathName.alpha = 0
        storageRef = Storage.storage().reference()
        for i in 0 ..< array.count{
            print(array[i]?.name)
        }
    }
    
    
    @IBAction func fileUploadBtn(_ sender: Any) {
        let attachSheet = UIAlertController(title: nil, message: "File attaching", preferredStyle: .actionSheet)
                
                
                attachSheet.addAction(UIAlertAction(title: "File", style: .default,handler: { (action) in
                    let supportedTypes: [UTType] = [UTType.png,UTType.jpeg, UTType.pdf]
                    var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
                    documentPicker.delegate = self
                    documentPicker.allowsMultipleSelection = false
                    documentPicker.shouldShowFileExtensions = true
                    self.present(documentPicker, animated: true, completion: nil)
                }))
                
//                attachSheet.addAction(UIAlertAction(title: "Photo/Video", style: .default,handler: { (action) in
//                    self.chooseImage()
//                }))
                
                
                attachSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.present(attachSheet, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let myURL = urls.first else {
                return
            }
            print("import result : \(myURL)")
            print(myURL.lastPathComponent)
            self.filePathName.alpha = 1
            self.filePathName.text = myURL.lastPathComponent
        
            let secondLocationRef = Storage.storage().reference()
            let storage = Storage.storage()
            let localFile = URL(string: "\(myURL)")
            let storageRef = storage.reference().child("abc.jpg")
            let uploadTask = storageRef.putFile(from: localFile!, metadata: nil) { metadata, error in
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
}
