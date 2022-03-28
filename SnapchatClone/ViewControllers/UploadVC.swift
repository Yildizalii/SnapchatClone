//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Ali on 23.03.2022.
//

import UIKit
import Firebase
class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      uploadImageView.isUserInteractionEnabled = true
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
      uploadImageView.addGestureRecognizer(gestureRecognizer)
    }

  @objc func tappedImage() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    picker.delegate = self
    self.present(picker, animated: true, completion: nil)

  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    uploadImageView.image = info[.originalImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
  }

    @IBAction func uploadButton(_ sender: Any) {
      let storage = Storage.storage()
      let storageReferance = storage.reference()
      let mediaFolder = storageReferance.child("media")

      if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
        let uuid = UUID().uuidString
        let imageReferance = mediaFolder.child("\(uuid).jpg")
        imageReferance.putData(data, metadata: nil) { metadata, error in
          if error != nil {
          }else {
            imageReferance.downloadURL { url, error in
              if error == nil {
                let imageUrl = url?.absoluteString
                let fireStore = Firestore.firestore()
                fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.userName).getDocuments { snaphot, error in
                  if error != nil {
                  }else{
                    if snaphot?.isEmpty == false && snaphot != nil {
                      for document in snaphot!.documents {
                        let documentId = document.documentID
                        if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                          imageUrlArray.append(imageUrl!)
                          let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String: Any]
                          fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                            if error == nil {
                              self.tabBarController?.selectedIndex = 0
                              self.uploadImageView.image = UIImage(named: "select")
                            }
                          }
                        }
                      }
                    }else {
                      let snapDictionary = ["imageUrlArray": [imageUrl!], "snapOwner": UserSingleton.sharedUserInfo.userName, "date": FieldValue.serverTimestamp()] as [String: Any]
                      fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                        if error != nil {
                        }else {
                          self.tabBarController?.selectedIndex = 0
                          self.uploadImageView.image = UIImage(named: "select")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

}

