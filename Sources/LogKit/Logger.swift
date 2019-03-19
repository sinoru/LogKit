//
//  Logger.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//

import Foundation

public protocol Logger: class {
    init(label: String?, sublabel: String?)

    func log(_ message: StaticString, dso: UnsafeRawPointer?, type: LogType, arguments: [CVarArg])
}

extension Logger {
    init() {
        self.init(label: nil, sublabel: nil)
    }
}
