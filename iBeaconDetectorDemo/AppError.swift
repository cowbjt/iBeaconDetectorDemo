//
//  AppError.swift
//  iBeaconDetectorDemo
//
//  Created by cowbjt on 2017/11/25.
//  Copyright © 2017年 cowbjt. All rights reserved.
//

import Foundation

public struct AppError: Error {
    let msg: String
    let detail: String
    init(msg: String, detail: String = "") {
        self.msg = msg
        self.detail = detail
    }
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        if detail == "" {
            return msg
        }

        return "\(msg): \(detail)" // NSLocalizedString(msg, comment: "")
    }
}
