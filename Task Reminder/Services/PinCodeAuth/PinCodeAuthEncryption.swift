//
//  PinCodeAuthEncryption.swift
//
//
//
import Foundation
import LocalAuthentication

// swiftlint:disable all
class PinCodeAuthEncryption {
    
    static private let publicKeyTag = Bundle.main.bundleIdentifier! + "public"
    static private let privateKeyLabel = Bundle.main.bundleIdentifier! + "private"
    
    @available(iOS 11.3, *)
    static func configure() {
        createKeyPair()
    }
    
    static func encode(string: String, error: (String) -> Void) -> Data? {
        
        guard let stringData = string.data(using: .utf8) else {
            error("String not converted to utf8")
            return nil
        }
        
        guard let publicKey = getPublicKey() else {
            error("Can't get Public Key")
            return nil
        }
        
        let converted = publicKey as! [String: Any]
        let keyRef = converted[kSecValueRef as String] as! SecKey
        
        guard let encryptedData = encrypt(stringData, publicKey: keyRef) else {
            error("Encryption fails!")
            return nil
        }
        
        return encryptedData
        
    }
    
    static func decode(encryptedData: Data, inContext context: LAContext, error: (String) -> Void) -> String? {
        
        guard let privateKey = getPrivateKey(context: context) else {
            error("Can't get Private Key!")
            return nil
        }
        
        guard let decriptedData = decrypt(encryptedData, privateKey: privateKey) else {
            error("Decription fails!")
            return nil
        }
        
        return String(data: decriptedData, encoding: .utf8)
        
    }
    
    static func encryptMessage(message: String, encryptionKey: String) throws -> String {
        
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
        
    }

    static func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
    
}

private extension PinCodeAuthEncryption {
    
    // create an Access Control
    @available(iOS 11.3, *)
    private static func createAccessControl() -> SecAccessControl? {
        var accessControlError: Unmanaged<CFError>?
        if let accessControl = SecAccessControlCreateWithFlags(
                kCFAllocatorDefault,
                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                [.biometryAny, .privateKeyUsage],
                &accessControlError
        ) {
            return accessControl
        }
        return nil
    }
    
    
    @available(iOS 11.3, *)
    static private func createKeyPair() {
        guard let accessControl = createAccessControl() else {
            print("Couldn't create accessControl")
            return
        }
        
        let privateKeyParams: [String: Any] = [
            kSecAttrLabel as String: privateKeyLabel,
            kSecAttrIsPermanent as String: true,
            kSecAttrAccessControl as String: accessControl,
            ]

        let params: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecPrivateKeyAttrs as String: privateKeyParams,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(params as CFDictionary, &error) else {
            print("Private key generation error")
            return
        }

        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            print("Public key generation error")
            return
        }

        storePublicKey(publicKey)
    }
    
    private static func storePublicKey(_ publicKey: SecKey) {
        // force store the public key in the keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrApplicationTag as String: publicKeyTag,
            kSecValueRef as String: publicKey,
            kSecAttrIsPermanent as String: true,
            kSecReturnData as String: true,
            ]

        // add the public key to the keychain
        var raw: CFTypeRef?
        var status = SecItemAdd(query as CFDictionary, &raw)
        
        if status == errSecSuccess {
            print("Public key Success stores in keychain")
        }

        // if it already exists, delete it and try to add it again
        if status == errSecDuplicateItem {
            status = SecItemDelete(query as CFDictionary)
            status = SecItemAdd(query as CFDictionary, &raw)
        }
    }
    
}

private extension PinCodeAuthEncryption {
    
    static func getPublicKey() -> CFDictionary? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: publicKeyTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecReturnData as String: true,
            kSecReturnRef as String: true,
            kSecReturnPersistentRef as String: true
        ]

        var publicKey: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &publicKey)

        guard status == errSecSuccess else {
            // couldn't get public key
            return nil
        }

        return (publicKey as! CFDictionary)
    }
    
    static func getPrivateKey(context: LAContext) -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrLabel as String: privateKeyLabel,
            kSecReturnRef as String: true,
            kSecUseOperationPrompt as String: "",
            kSecUseAuthenticationContext as String: context
        ]

        var privateKey: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &privateKey)

        guard status == errSecSuccess else {
            // couldn't get private key
            return nil
        }

        return (privateKey as! SecKey)
    }
    
}

private extension PinCodeAuthEncryption {

    static func encrypt(_ message: Data, publicKey: SecKey) -> Data? {
        var error : Unmanaged<CFError>?

        let result = SecKeyCreateEncryptedData(publicKey, .eciesEncryptionStandardX963SHA256AESGCM, message as CFData, &error)

        if let result = result {
            return result as Data
        }
        
        return nil
    }
    
    static func decrypt(_ encrypted: Data, privateKey: SecKey) -> Data? {
        var error : Unmanaged<CFError>?

        let result = SecKeyCreateDecryptedData(privateKey, .eciesEncryptionStandardX963SHA256AESGCM, encrypted as CFData, &error)
        
        if let result = result {
            return result as Data
        }
        
        return nil
    }
    
}
