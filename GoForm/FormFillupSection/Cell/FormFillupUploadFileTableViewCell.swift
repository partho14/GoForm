//
//  FormFillupUploadFileTableViewCell.swift
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


class FormFillupUploadFileTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var uploadFileBigView: UIView!
    @IBOutlet weak var uploadFileBigView2: UIView!
    
    @IBOutlet weak var uploadFileBorderView: UIView!{
        didSet{
            uploadFileBorderView.layer.borderWidth = 1
            uploadFileBorderView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            uploadFileBorderView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var uploadFileTittleLbl: UILabel!{
        didSet{
            self.uploadFileTittleLbl.font = UIFont(name: "Barlow-Bold", size: 14.0)
            uploadFileTittleLbl.numberOfLines = 1
            uploadFileTittleLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var uploadImageView: UIView!{
        didSet{
            uploadImageView.layer.borderWidth = 1
            uploadImageView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            uploadImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var cellImageView: UIImageView!{
        didSet{
            cellImageView.layer.borderWidth = 1
            cellImageView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            cellImageView.layer.cornerRadius = 10
        }
    }
    
    
    @IBOutlet weak var uploadFileView: UIView!{
        didSet{
            uploadFileView.layer.borderWidth = 1
            uploadFileView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            uploadFileView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var uploadFileMaxSizeLbl: UILabel!{
        didSet{
            self.uploadFileMaxSizeLbl.font = UIFont(name: "Barlow-Regular", size: 14.0)
            uploadFileMaxSizeLbl.numberOfLines = 1
            uploadFileMaxSizeLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    @IBOutlet weak var fileUploadBtn: UIButton!
    @IBOutlet weak var chooseFileTextLbl: UILabel!{
        didSet{
            self.chooseFileTextLbl.font = UIFont(name: "Barlow-Regular", size: 12.0)
            chooseFileTextLbl.numberOfLines = 1
            chooseFileTextLbl.adjustsFontSizeToFitWidth = true
            //questionName.sizeToFit()
            //questionName.textAlignment = .left
        }
    }
    
    @IBOutlet weak var editBtnView: UIView!{
        didSet{
            editBtnView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var deleteBtnView: UIView!{
        didSet{
            deleteBtnView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var imageDeleteBtn: UIButton!{
        didSet{
            imageDeleteBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imageReplaceBtn: UIButton!{
        didSet{
            imageReplaceBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var fileDeleteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var didUpload: (Int) -> ()  = { _ in }
    var didDelete: (Int) -> ()  = { _ in }
    var didImageReplace: (Int) -> ()  = { _ in }
    var didImageDelete: (Int) -> ()  = { _ in }
    var didUpdate: (Int) -> ()  = { _ in }
    var indexValue: Int = 0
    var storageRef: StorageReference!
    var imagePicker = UIImagePickerController()
    var storeIndex: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storageRef = Storage.storage().reference()
       // imagePicker.delegate = appDelegate.currentNav?.visibleViewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.isHidden = false
    }
    
    func loadData(){
        self.storeIndex = appDelegate.multiplePhotoStoreIndex
        self.tableView.reloadData()
    }
    
    
    @IBAction func fileUploadBtnPressed(_ sender: Any) {
        didUpload(fileUploadBtn.tag)
    }
    
    @IBAction func fileDeleteBtnPressed(_ sender: Any) {
        didDelete(fileDeleteBtn.tag)
    }
    
    @IBAction func imageReplaceBtnPressed(_ sender: Any) {
        didImageReplace(imageReplaceBtn.tag)
    }
    @IBAction func imageDeleteBtnPressed(_ sender: Any) {
        didImageDelete(imageDeleteBtn.tag)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (appDelegate.hasImageValue == true){
            return storeIndex.count + 1
        }else{
            return 1  
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MultipleImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultipleImageTableViewCell", for: indexPath) as! MultipleImageTableViewCell
        cell.photoEditBtn.tag = indexPath.row + 1
        cell.photoDeleteBtn.tag = indexPath.row + 1
        cell.photoUploadBtn.tag = indexPath.row + 1
        cell.didUpload = { [weak self] tag in
            self?.indexValue = indexPath.row + 1
            self?.didUpdate(tableView.tag)
        }
        cell.didEdit = { [weak self] tag in
            self?.didUpdate(tableView.tag)
        }
        cell.didDelete = { [weak self] tag in
            self?.didUpdate(tableView.tag)
        }
        if (appDelegate.hasImageValue == true){
            print(storeIndex.count)
            if (indexPath.row == storeIndex.count){
                cell.nonImageView.alpha = 1
                cell.withImageView.alpha  = 0
            }else{
                let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                indicator.color = UIColor.orange
                indicator.translatesAutoresizingMaskIntoConstraints = false
                indicator.startAnimating()
                cell.withImageView.addSubview(indicator)
                
                indicator.centerXAnchor.constraint(equalTo: cell.withImageView.centerXAnchor).isActive = true
                indicator.centerYAnchor.constraint(equalTo: cell.withImageView.centerYAnchor).isActive = true
                let islandRef = self.storageRef.child(storeIndex[indexPath.row])
                print(appDelegate.multipleImageGetUrl)
                islandRef.getData(maxSize: (10 * 1024 * 1024)) { (data, error) in
                        if let err = error {
                           print(err)
                      } else {
                          print(data)
                        if let image  = data {
                            let seconds = 1.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                let image1 = UIImage(data: data!)
                                cell.cellImageView.image = image1
                                cell.cellImageView.contentMode = .scaleAspectFill
                                indicator.removeFromSuperview()
                            }
                             // Use Image
                        }
                     }
                }
                cell.nonImageView.alpha = 0
                cell.withImageView.alpha  = 1
            }
        }else{
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: Int) -> CGFloat {
            return 10
        }
    
    func chooseImage() {
            print("hello");
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            appDelegate.currentNav?.visibleViewController?.present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageData = [String:String]()
        
        
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        
        print(fileUrl.lastPathComponent)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageData["filename"] = fileUrl.lastPathComponent
            selectedImageData["data"] = pickedImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
            let storage = Storage.storage()
            let localFile = URL(string: "\(fileUrl)")
            let storageRef = storage.reference().child(appDelegate.multipleImageGetUrl).child("\(indexValue)")
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
            self.didUpdate(tableView.tag)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                //self.tableView.reloadData()
                appDelegate.formFillupViewController?.tableView.reloadData()
            }
           
        }
        
        appDelegate.currentNav?.visibleViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        appDelegate.currentNav?.visibleViewController?.dismiss(animated: true, completion: nil)
    }
    
}
