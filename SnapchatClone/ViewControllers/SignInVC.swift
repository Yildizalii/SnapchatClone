//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Ali on 6.03.2022.
//

import UIKit
import Firebase
class SignInVC: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signInButton(_ sender: Any) {
        if mailText.text != "" && passwordText.text != ""  {
            Auth.auth().signIn(withEmail: mailText.text!, password: passwordText.text!) { result, error in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Error!", titleInput: "Error!")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            self.makeAlert(messageInput: "Email?/Password?/Username?", titleInput: "Error!")
        }
    }

    @IBAction func signUpButton(_ sender: Any) {
        if mailText.text != "" && usernameText.text != "" && passwordText.text != ""  {
            Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!) { auth, error in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Error", titleInput: "Error!")
                }else {
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["Email" : self.mailText.text! , "Username" : self.usernameText.text!] as [String : Any]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            makeAlert(messageInput: "Email?/Password?/Username?", titleInput: "Error")
        }
    }

    func makeAlert(messageInput: String, titleInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}

