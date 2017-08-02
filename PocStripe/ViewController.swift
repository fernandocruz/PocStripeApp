//
//  ViewController.swift
//  PocStripe
//
//  Created by Luis Fernando Cruz Santos on 01/08/17.
//  Copyright © 2017 Ebanx. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class ViewController: UIViewController, STPPaymentCardTextFieldDelegate, UITextViewDelegate {

  @IBOutlet weak var valueTextField: UITextField!
  @IBOutlet weak var creditCardView: UIView!
  let  paymentField = STPPaymentCardTextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let margins = creditCardView.layoutMarginsGuide
    
    paymentField.borderColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    paymentField.textColor = UIColor.white
    paymentField.cursorColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    paymentField.placeholderColor = UIColor.white
    
    creditCardView.addSubview(paymentField)
    paymentField.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    paymentField.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    paymentField.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
    paymentField.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    paymentField.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    paymentField.translatesAutoresizingMaskIntoConstraints = false
    
    paymentField.delegate = self

  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  override func viewWillLayoutSubviews() {
    setupValueTextField()
  }



  @IBAction func topupButtonTapped(_ sender: Any) {
    
    let creditCard = STPCardParams()
    creditCard.number = paymentField.cardNumber
    creditCard.cvc = paymentField.cvc
    creditCard.expMonth = paymentField.expirationMonth
    creditCard.expYear = paymentField.expirationYear
    
    if STPCardValidator.validationState(forCard: creditCard) == .valid{
      
      STPAPIClient.shared().createToken(withCard: creditCard, completion: { (token:STPToken?, error:Error?) in
        if error != nil {
          print("has a error on create token")
          return
        }
        guard let token = token else {
          return
        }
        
        print("my token: \(token)")
        let payment = Payment(amount: Int(self.valueTextField.text ?? "0")!, token: token.tokenId, currency: "usd")
        
        let headers: HTTPHeaders = [
          "Accept": "application/json",
          "Content-Type":"application/json"
        ]

        Alamofire.request("http://192.168.100.5:8080/api/topup", method: .post, parameters: payment.toJson(), encoding: JSONEncoding.default, headers: headers)
        .responseJSON(completionHandler: { (response) in
          switch response.result {
          case .success:
            print("json:\(String(describing: response.result.value))")
          case .failure(let error):
            print(error)
          }
        })
      })
    }else{
      print("enter a valid credit card")
    }
  }

}

extension ViewController {
  
  func setupValueTextField(){
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0).cgColor
    border.frame = CGRect(x: 0, y: valueTextField.frame.size.height - width, width:  valueTextField.frame.size.width, height: valueTextField.frame.size.height)
    
    border.borderWidth = width
    valueTextField.layer.addSublayer(border)
    valueTextField.layer.masksToBounds = true
  }
  
}

