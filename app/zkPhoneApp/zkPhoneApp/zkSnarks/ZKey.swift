//
//  ZKey.swift
//  zkPhoneApp
//
//  Created by Hiroshi Chiba on 2024/08/24.
//

import Foundation

struct ZKey {
    static func loadZKeyBuffer() -> [UInt8]? {
       
        let filePath = Bundle.main.path(forResource: "zkPhone_0001", ofType: "zkey")!
        let fileURL = URL(fileURLWithPath: filePath)
       
        do {
            // Read file contents into Data
            let fileData = try Data(contentsOf: fileURL)
            
            // Convert Data to [UInt8]
            let buffer = [UInt8](fileData)
            return buffer
        } catch {
            // Handle errors, e.g., file not found or read error
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    static func loadZKeyData() -> Data? {
       
        let filePath = Bundle.main.path(forResource: "zkPhone_0001", ofType: "zkey")!
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


