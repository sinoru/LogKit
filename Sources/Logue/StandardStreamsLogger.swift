//
//  StandardStreamsLogger.swift
//  Logue
//
//  Created by Jaehong Kang on 19/03/2019.
//  Copyright © 2019 Jaehong Kang. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
