//
//  SetttingsVC.swift
//  SnapchatClone
//
//  Created by Ali on 23.03.2022.
//

import UIKit
import Firebase
class SetttingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func logOutButton(_ sender: Any) {
      do{
        try Auth.auth().signOut()
        self.performSegue(withIdentifier: "toSignInVC", sender: nil)
      }catch {
      }
    }
}
