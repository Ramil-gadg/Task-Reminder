//
//  PinManager.swift
//
//

import Foundation

class PinManager {
    
    static let shared = PinManager()
    private var timeBeginBackground: Double?
    
    var pinCodeTrigger: CompletionBlock?
    
    private init() {
    }
    
    func didEnterBackground() {
        timeBeginBackground = Date().timeIntervalSince1970
    }
    
    func willEnterForeground() {
        let timeNow = Date().timeIntervalSince1970
        guard let timeBeginBackground = timeBeginBackground,
              timeNow - timeBeginBackground >= 10 else {
            self.timeBeginBackground = nil
            return
        }
        
        DispatchQueue.main.async {
            self.timeBeginBackground = nil
            self.pinCodeTrigger?()
        }
    }
}
