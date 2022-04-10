//
//  PinCodeAuth.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//
//

import Foundation
import LocalAuthentication

final class PinCodeAuth {
    
}

// MARK: - Biometrical

// swiftlint:disable all
extension PinCodeAuth {
    
    private static let tokenLabel = Bundle.main.bundleIdentifier! + "storedToken"
    private static let pinCodeTokenLabel = Bundle.main.bundleIdentifier! + "storedPinCodeToken"
    
    @available(iOS 11.3, *)
    static func configureForBiometric() {
        PinCodeAuthEncryption.configure()
    }
    
    /// Stores `token` in Apple Enclave encrypted with pair of public/private keys
    @discardableResult
    static func storeTokenWithBiometric(token: String) -> Bool {
        
        guard let encryptedData = PinCodeAuthEncryption.encode(string: token, error: { error in
            print(error)
        }) else {
            return false
        }
        
        PinCodeAuthKeychain.save(key: tokenLabel, data: encryptedData)
        
        return true
    }
    
    /// Get `token` from Apple Enclave with succeeded evaluatePolicy of LAContext
    static func getToken(context: LAContext) -> String? {
        
        guard let encryptedData = PinCodeAuthKeychain.load(key: tokenLabel) else {
            return nil
        }
        
        guard let decryptedString = PinCodeAuthEncryption.decode(
                encryptedData: encryptedData,
                inContext: context,
                error: { error in
            print(error)
        }) else {
            return nil
        }
        
        return decryptedString
        
    }
    
}

// MARK: - With PinCode
extension PinCodeAuth {
    
    /// Stores encrypted `token` with `pinCode` in Keychain
    @discardableResult
    static func storeTokenWith(pinCode: String, token: String) -> Bool {
        
        guard let enryptedString = try? PinCodeAuthEncryption.encryptMessage(
                message: token,
                encryptionKey: pinCode
        ) else {
            print("Enryption with pinCode fails")
            return false
        }
        
        PinCodeAuthKeychain.save(key: pinCodeTokenLabel, data: enryptedString.data(using: .utf8)!)
        
        return true
    }
    
    /// Get `token` from Keychain and decrypt with pinCode
    static func getToken(pinCode: String) -> String? {
        
        guard let encryptedData = PinCodeAuthKeychain.load(key: pinCodeTokenLabel) else {
            return nil
        }
        
        let encodedString = String(decoding: encryptedData, as: UTF8.self)

        guard let enryptedString = try? PinCodeAuthEncryption.decryptMessage(
                encryptedMessage: encodedString,
                encryptionKey: pinCode
        ) else {
            print("Decryptioin with pinCode fails")
            return nil
        }
        
        return enryptedString
    }

}
