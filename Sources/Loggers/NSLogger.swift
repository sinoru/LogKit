//
//  NSLogger.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//

import Foundation

@available(macOS, deprecated: 10.12, message:"Use OSLogger")
@available(iOS, deprecated: 10.0, message:"Use OSLogger")
@available(watchOS, deprecated: 3.0, message:"Use OSLogger")
@available(tvOS, deprecated: 10.0, message:"Use OSLogger")
public class NSLogger: Logger {
    private let prefix: String

    public required init(label: String?, sublabel: String?) {
        switch (label, sublabel) {
        case (let label?, let sublabel?):
            self.prefix = "(\(label)[\(sublabel)]): "
        case (let label?, _):
            self.prefix = "(\(label))"
        default:
            self.prefix = ""
        }
    }

    public func log(_ message: StaticString, dso: UnsafeRawPointer?, type: LogType, arguments: [CVarArg]) {
        let typeString: String?

        switch type {
        case .info:
            typeString = "[Info]"
        case .debug:
            typeString = "[Debug]"
        case .error:
            typeString = "[Error]"
        case .fault:
            typeString = "[Fault]"
        default:
            typeString = nil
        }

        withVaList(arguments) {
            NSLogv(self.prefix + [typeString, message.description].compactMap({$0}).joined(separator: " "), $0)
        }
    }
}
