//
//  InputSMSViewController.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import Foundation
import UIKit
import rapidsnark
import CryptoKit

class InputSMSViewController: UIViewController {
    
    let hashdPhoneNumber: String
    init(hashdPhoneNumber: String) {
        self.hashdPhoneNumber = hashdPhoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let naviHeight: CGFloat = 84.0
        
        let label = UILabel()
        label.text = "SMS contents you received"
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
        
        let proofButton = UIButton()
        proofButton.setTitle("Create Proof", for: .normal)
        proofButton.frame = CGRect(
            x: (view.bounds.size.width - 200) / 2,
            y: textField.frame.origin.y + textField.frame.size.height + 20.0,
            width: 200,
            height: 50
        )
        proofButton.setTitleColor(.white, for: .normal)
        proofButton.backgroundColor = UIColor.systemBlue
        proofButton.clipsToBounds = true
        proofButton.layer.cornerRadius = 10.0
        proofButton.addTarget(self, action: #selector(proofButtonDidTapped), for: .touchUpInside)
        view.addSubview(proofButton)
    }
    
    @objc func proofButtonDidTapped() {
        let content = textField.text ?? ""
        if content.isEmpty {
            let alert = UIAlertController(title: "Please input the contents of the SMS you received", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let hashedContent = sha256(input: content)
        // Todo: SMSの内容と電話番号のハッシュを処理する
        print("phone num hash: \(String(describing: hashdPhoneNumber))")
        print("sms content hash: \(hashedContent)")
        
        let zKey = ZKey.loadZKeyData()!
        let witness = WtnsKey.loadWtnsKeyData()!
        let proof = try! groth16Prove(zkey: zKey, witness: witness)
        
        Proof.proof = proof.proof
        Proof.publicSignal = proof.publicSignals
                
        let alert = UIAlertController(title: "The Proof has been created", message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func sha256(input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
