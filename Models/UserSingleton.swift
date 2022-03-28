//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Ali on 25.03.2022.
//

import Foundation

class UserSingleton {
  static let sharedUserInfo = UserSingleton()
  var email = ""
  var userName = ""

  private init() {
  }
}
