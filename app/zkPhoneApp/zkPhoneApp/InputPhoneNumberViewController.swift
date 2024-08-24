//
//  InputPhoneNumberViewController.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import Foundation
import UIKit

class InputPhoneNumberViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let naviHeight: CGFloat = 84.0
        
        let label = UILabel()
        label.text = "電話番号"
        label.textColor = .black
        label.frame = CGRect(x: 20.0, y: naviHeight + 20.0, width: view.bounds.size.width, height: 20.0)
        view.addSubview(label)
        
        let textField = UITextField()
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
        smsButton.setTitleColor(.black, for: .normal)
        smsButton.addTarget(self, action: #selector(smsButtonDidTapped), for: .touchUpInside)
        view.addSubview(smsButton)
    }
    
    @objc func smsButtonDidTapped() {
        
    }
}
