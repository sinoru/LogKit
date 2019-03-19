//
//  StandardStreamsLogger.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//

import Foundation

private struct StandardErrorOutputStream: TextOutputStream {
    public mutating func write(_ string: String) {
        fputs(string, stderr)
    }
}

public class StandardStreamsLogger: Logger {
    private let prefix: String
    private var standErrorOuputStream = StandardErrorOutputStream()

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

        let message = String(format: self.prefix + [typeString, message.description].compactMap({$0}).joined(separator: " "), arguments: arguments)

        if [.error, .fault].contains(type) {
            print(message, to: &standErrorOuputStream)
        } else {
            print(message)
        }
    }
}
