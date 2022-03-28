//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Ali on 23.03.2022.
//

import UIKit
import Firebase
import SDWebImage
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var snapArray = [Snap]()
  var chosenSnap : Snap?
  let fireStoreDatabase = Firestore.firestore()

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    getSnapsFromFirebase()
    getUserInfo()
    self.tableView.reloadData()
    }

  func getSnapsFromFirebase() {
    fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snaphot, error in
      if error != nil {
        self.makeAlert(messageInput: error?.localizedDescription ?? "Error", titleInput: "Error!")
      }else {
        if snaphot?.isEmpty == false && snaphot != nil {
          self.snapArray.removeAll(keepingCapacity: false)
        for document in snaphot!.documents {
          let documentId = document.documentID
          if let userName = document.get("snapOwner") as? String {
            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
              if let date = document.get("date") as? Timestamp {
                if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                  if difference >= 24 {
                    self.fireStoreDatabase.collection("Snaps").document(documentId).delete()
                  }else {
                    let snap = Snap(userName: userName, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: Int(24.00) - difference)
                    self.snapArray.append(snap)
                  }
                }
              }
              }
            }
          }
          self.tableView.reloadData()
        }
      }
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
    cell.feedLabel.text = snapArray[indexPath.row].userName
    cell.feedImageView.sd_setImage(with:URL(string: snapArray[indexPath.row].imageUrlArray.last!))
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return snapArray.count
  }

  func getUserInfo() {
    fireStoreDatabase.collection("UserInfo").whereField("Email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
      if error != nil { 
        self.makeAlert(messageInput: error?.localizedDescription ?? "Error!", titleInput: "Error")
      }else{
        if snapshot?.isEmpty == false && snapshot != nil {
          for document in snapshot!.documents {
           if let userName = document.get("Username") as? String {
             UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
             UserSingleton.sharedUserInfo.userName = userName
            }
          }
        }
      }
    }
  }

  func makeAlert(messageInput: String, titleInput: String) {

      let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
      let button = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(button)
      self.present(alert, animated: true, completion: nil)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    chosenSnap = self.snapArray[indexPath.row]
    performSegue(withIdentifier: "toSnapVC", sender: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toSnapVC" {
      let destinationVC = segue.destination as! SnapVC
      destinationVC.selectedSnap = chosenSnap
    }
  }
}
