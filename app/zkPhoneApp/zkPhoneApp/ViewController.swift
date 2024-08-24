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
        
        let smsButton = UIButton()
        smsButton.setTitle("Go to the phone number input screen", for: .normal)
        smsButton.frame = CGRect(x: (view.bounds.size.width - 300) / 2, y: (view.bounds.height - 50) / 2, width: 300, height: 50)
        smsButton.setTitleColor(.black, for: .normal)
        smsButton.addTarget(self, action: #selector(smsButtonDidTapped), for: .touchUpInside)
        view.addSubview(smsButton)
        
        let verifyButton = UIButton()
        verifyButton.setTitle("Go to the Proof Verification screen", for: .normal)
        verifyButton.frame = CGRect(x: (view.bounds.size.width - 300) / 2, y: smsButton.frame.origin.y + smsButton.frame.height + 15.0, width: 300, height: 50)
        verifyButton.setTitleColor(.black, for: .normal)
        verifyButton.addTarget(self, action: #selector(verifyButtonDidTapped), for: .touchUpInside)
        view.addSubview(verifyButton)
    }

    @objc func smsButtonDidTapped() {
        let controller = InputPhoneNumberViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func verifyButtonDidTapped() {
        let defaultProof = Proof.proof
        let defaultPublicSignal = Proof.publicSignal
        
        if defaultProof.isEmpty || defaultPublicSignal.isEmpty {
            let alert = UIAlertController(title: "Please complete SMS verification to create the Proof.", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let controller = ProofVerifyViewController(proof: defaultProof, publicSignal: defaultPublicSignal)
        navigationController?.pushViewController(controller, animated: true)
    }

}

