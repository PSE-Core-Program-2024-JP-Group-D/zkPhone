//
//  VerificationKey.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import Foundation

struct VerificationKey {
    static func loadVerificationKeyBuffer() -> [CChar]? {
       
        let filePath = Bundle.main.path(forResource: "verification_key", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
       
        do {
            // Read file contents into Data
            let fileData = try Data(contentsOf: fileURL)
            
            return fileData.withUnsafeBytes {
                Array($0.bindMemory(to: CChar.self))
            }
            
        } catch {
            // Handle errors, e.g., file not found or read error
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    static func loadVerificationKeyData() -> Data? {
       
        let filePath = Bundle.main.path(forResource: "verification_key", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
       
        do {
            // Read file contents into Data
            let fileData = try Data(contentsOf: fileURL)
            return fileData
            
            
        } catch {
            // Handle errors, e.g., file not found or read error
            print("Error reading file: \(error)")
            return nil
        }
    }
}


