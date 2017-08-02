//
//  Payment.swift
//  PocStripe
//
//  Created by Luis Fernando Cruz Santos on 01/08/17.
//  Copyright © 2017 Ebanx. All rights reserved.
//

import Foundation
struct Payment {
  let amount: Int
  let token: String
  let currency: String
  
  func toJson() -> [String:Any] {
    return ["amount":amount, "token":token, "currency":currency]
  }
}
