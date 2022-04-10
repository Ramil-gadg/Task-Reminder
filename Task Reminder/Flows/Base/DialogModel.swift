//
//  DialogModel.swift
//
//

import Foundation

struct DialogModel {
    
    let title: String
    let message: String
    let yesTitle: String
    let noTitle: String
    var onYes: CompletionBlock?
    var onNo: CompletionBlock?
}
