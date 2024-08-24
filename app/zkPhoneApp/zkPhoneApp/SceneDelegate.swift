//
//  SceneDelegate.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import UIKit
import rapidsnark
import CryptoKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
            
        let controller = ViewController()
        let navi = UINavigationController(rootViewController: controller)
        window?.rootViewController = navi
        
       
        let zKey = ZKey.loadZKeyData()!
        let witness = WtnsKey.loadWtnsKeyData()!
        let proof = try! groth16Prove(zkey: zKey, witness: witness)
        
        if let data = proof.publicSignals.data(using: .utf8),
           let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
            print(array) // 出力: ["1", "1", "1", ...]
            
            print(binaryArrayToString(array))
            
        } else {
            print("Failed to parse JSON")
        }
        
        print(proof.publicSignals)
                
        // Convert CChar array to String array
        let strings = Public.loadPublicBuffer()!.map { UnicodeScalar(UInt32($0))! }.map { String($0)}
        print(strings)
        
        
//        let optcode = "1235"
//        let binaryStringArray:[String] = stringToBinaryArray(optcode)
//        let binaryCharactorArray = binaryStringArray.flatMap { Array($0) }.map { String($0)}
//        print(binaryStringArray)
//        
//        print(binaryCharactorArray)
//        
//        print(binaryArrayToString(binaryCharactorArray))
        
        
//        do {
//            result =  try groth16Verify(proof: p.data(using: .utf8)!, inputs: s.data(using: .utf8)!, verificationKey: v)
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        print(result)
//        
        
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
    
    private func sha256(input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
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
