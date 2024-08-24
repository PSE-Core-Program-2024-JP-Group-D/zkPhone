//
//  ProofVerifyViewController.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import Foundation
import UIKit
import rapidsnark
import CryptoKit

class ProofVerifyViewController: UIViewController {
    
    let proof: String
    let publicSignal: String
    
    init(proof: String, publicSignal: String) {
        self.proof = proof
        self.publicSignal = publicSignal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var proofTextView: UITextView!
    var publicSignalTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let naviHeight: CGFloat = 84.0
        
        let label = UILabel()
        label.text = "Proof"
        label.textColor = .black
        label.frame = CGRect(x: 20.0, y: naviHeight + 20.0, width: view.bounds.size.width, height: 20.0)
        view.addSubview(label)
        
        proofTextView = UITextView()
        proofTextView.textColor = .black
        proofTextView.frame = CGRect(
            x: 20.0,
            y: label.frame.origin.y + label.frame.size.height + 20.0,
            width: view.bounds.size.width - 40.0,
            height: 150.0
        )
        proofTextView.layer.borderWidth = 0.8
        proofTextView.layer.borderColor = UIColor.gray.cgColor
        proofTextView.text = proof
        view.addSubview(proofTextView)
        
        publicSignalTextView = UITextView()
        publicSignalTextView.textColor = .black
        publicSignalTextView.frame = CGRect(
            x: 20.0,
            y: proofTextView.frame.origin.y + proofTextView.frame.size.height + 20.0,
            width: view.bounds.size.width - 40.0,
            height: 150.0
        )
        publicSignalTextView.layer.borderWidth = 0.8
        publicSignalTextView.layer.borderColor = UIColor.gray.cgColor
        publicSignalTextView.text = publicSignal
        view.addSubview(publicSignalTextView)
        
        let verifyButton = UIButton()
        verifyButton.setTitle("Verify the Proof", for: .normal)
        verifyButton.frame = CGRect(
            x: (view.bounds.size.width - 200) / 2,
            y: publicSignalTextView.frame.origin.y + publicSignalTextView.frame.size.height + 20.0,
            width: 200,
            height: 50
        )
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.backgroundColor = UIColor.systemBlue
        verifyButton.clipsToBounds = true
        verifyButton.layer.cornerRadius = 10.0
        verifyButton.addTarget(self, action: #selector(verifyButtonDidTapped), for: .touchUpInside)
        view.addSubview(verifyButton)
    }
    
    @objc func verifyButtonDidTapped() {
    
        let p = proofTextView.text ?? ""
        if p.isEmpty {
            let alert = UIAlertController(title: "Please input the contents of the Proof.", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let s = publicSignalTextView.text ?? ""
        if s.isEmpty {
            let alert = UIAlertController(title: "Please input the contents of the Public Signal", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
                
        let v = VerificationKey.loadVerificationKeyData()!
        var result = false
        var errorMessage: String? = nil
        do {
            result =  try groth16Verify(proof: p.data(using: .utf8)!, inputs: s.data(using: .utf8)!, verificationKey: v)
        } catch {
            errorMessage = error.localizedDescription
        }
        print(result)
        
        let phonenumber = "07013579246"
        
        var alertMessage = "Authentication result \(result)"
        if result {
            alertMessage = "Authentication result \(result): You have proven that this is your phone number\(phonenumber) by verifying the Proof."
        }
        let alert = UIAlertController(title: alertMessage, message: errorMessage, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func stringToBinaryArray(_ string: String) -> [String] {
        var binaryArray: [String] = []
        
        for character in string {
            // Convert the character to its Unicode scalar value
            guard let unicodeScalar = character.unicodeScalars.first else {
                print("Error: Unable to convert character to Unicode scalar.")
                return []
            }
            
            // Convert the Unicode scalar value to UInt8
            let byte = UInt8(unicodeScalar.value)
            
            // Convert the byte to a binary string with leading zeros
            let binaryString = String(byte, radix: 2).padLeft(toLength: 8, withPad: "0")
            
            // Append the binary string to the array
            binaryArray.append(binaryString)
        }
        
        return binaryArray
    }
    
    func flattenBinaryArray(from binaryStrings: [String]) -> [String] {
        return binaryStrings.flatMap { Array($0).map { String($0) } }
    }
    
    func binaryArrayToString(_ binaryArray: [String]) -> String? {
        guard binaryArray.count % 8 == 0 else {
            print("Error: The binary array length is not a multiple of 8.")
            return nil
        }
        
        var characters: [Character] = []
        
        for i in stride(from: 0, to: binaryArray.count, by: 8) {
            let byteArray = Array(binaryArray[i..<i+8])
            let byteString = byteArray.joined()
            
            if let byte = UInt8(byteString, radix: 2) {
                characters.append(Character(UnicodeScalar(byte)))
            } else {
                print("Error: Invalid binary string.")
                return nil
            }
        }
        
        return String(characters)
    }
}

extension String {
    func padLeft(toLength length: Int, withPad pad: String) -> String {
        guard self.count < length else { return self }
        let padLength = length - self.count
        let padding = String(repeating: pad, count: padLength)
        return padding + self
    }
}
