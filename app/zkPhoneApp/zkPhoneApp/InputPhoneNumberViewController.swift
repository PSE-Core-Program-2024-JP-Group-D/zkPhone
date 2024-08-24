//
//  InputPhoneNumberViewController.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import Foundation
import UIKit
import CryptoKit

class InputPhoneNumberViewController: UIViewController {
    
    var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let naviHeight: CGFloat = 84.0
        
        let label = UILabel()
        label.text = "電話番号"
        label.textColor = .black
        label.frame = CGRect(x: 20.0, y: naviHeight + 20.0, width: view.bounds.size.width, height: 20.0)
        view.addSubview(label)
        
        textField = UITextField()
        textField.textColor = .black
        textField.frame = CGRect(
            x: 20.0,
            y: label.frame.origin.y + label.frame.size.height + 20.0,
            width: view.bounds.size.width - 40.0,
            height: 20.0
        )
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(textField)
        
        let smsButton = UIButton()
        smsButton.setTitle("SMSを受け取る", for: .normal)
        smsButton.frame = CGRect(
            x: (view.bounds.size.width - 200) / 2,
            y: textField.frame.origin.y + textField.frame.size.height + 20.0,
            width: 200,
            height: 50
        )
        smsButton.setTitleColor(.white, for: .normal)
        smsButton.backgroundColor = UIColor.systemBlue
        smsButton.clipsToBounds = true
        smsButton.layer.cornerRadius = 10.0
        smsButton.addTarget(self, action: #selector(smsButtonDidTapped), for: .touchUpInside)
        view.addSubview(smsButton)
    }
    
    @objc func smsButtonDidTapped() {
        let phone = textField.text ?? ""
        if phone.isEmpty {
            let alert = UIAlertController(title: "電話番号を入力してください。", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let hashdPhone = sha256(input: phone)
        
        let controller = InputSMSViewController(hashdPhoneNumber: hashdPhone)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func sha256(input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
