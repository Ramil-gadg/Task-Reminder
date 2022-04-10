//
//  SessionManager.swift
//
//

import Foundation

let defaults = UserDefaults.standard

enum SessionManager {
    
    static var didSetPin: Bool {
        get {
            defaults.bool(forKey: UserDefaultsKeys.didSetPin.rawValue)
        }
        set (newValue) {
            defaults.set(newValue, forKey: UserDefaultsKeys.didSetPin.rawValue)
        }
    }
    
    static var didSetBiometry: Bool {
        get {
            defaults.bool(forKey: UserDefaultsKeys.didSetBiometry.rawValue)
        }
        set (newValue) {
            defaults.set(newValue, forKey: UserDefaultsKeys.didSetBiometry.rawValue)
        }
    }
    
    /// Ключ авторизации, поидее должны получать с сервера после авторизации (но в данном случае просто  хардкодим) и расшифровываем пин кодом
    static var token: String? {
        willSet(value) {
            if value == nil {
                didSetPin = false
                didSetBiometry = false
                skipCreatePin = false
            }
        }
    }
    
    /// пропустить создание пин кода, тогда всегда придеться авторизовываться при старте
    static var skipCreatePin = false

}
