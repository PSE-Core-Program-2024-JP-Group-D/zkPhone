//
//  ViewController.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import UIKit
import rapidsnark

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var zKey = ZKey.loadZKeyData()!
        var witness = WtnsKey.loadWtnsKeyData()!
        let proof = try! groth16Prove(zkey: zKey, witness: witness)
        print(proof)
        
        var v = VerificationKey.loadVerificationKeyData()!
        let result = try! groth16Verify(proof: proof.proof.data(using: .utf8)!, inputs: proof.publicSignals.data(using: .utf8)!, verificationKey: v)
        print(result)
        
        
        let smsButton = UIButton()
        smsButton.setTitle("電話番号入力画面へ", for: .normal)
        smsButton.frame = CGRect(x: (view.bounds.size.width - 200) / 2, y: (view.bounds.height - 50) / 2, width: 200, height: 50)
        smsButton.setTitleColor(.black, for: .normal)
        smsButton.addTarget(self, action: #selector(smsButtonDidTapped), for: .touchUpInside)
        view.addSubview(smsButton)
        
        let verifyButton = UIButton()
        verifyButton.setTitle("Proof検証画面へ", for: .normal)
        verifyButton.frame = CGRect(x: (view.bounds.size.width - 200) / 2, y: smsButton.frame.origin.y + smsButton.frame.height + 15.0, width: 200, height: 50)
        verifyButton.setTitleColor(.black, for: .normal)
        verifyButton.addTarget(self, action: #selector(verifyButtonDidTapped), for: .touchUpInside)
        view.addSubview(verifyButton)
    }

    @objc func smsButtonDidTapped() {
        
    }
    
    @objc func verifyButtonDidTapped() {
        
    }

}

