//
//  DialogModel.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 14.01.2022.
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
