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
        
        // Do any additional setup after loading the view.
    }


}

