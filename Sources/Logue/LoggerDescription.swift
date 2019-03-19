//
//  LoggerDescription.swift
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

public struct LoggerDescription {
    public let loggerType: Logger.Type
    public var logTypes: Set<LogType>?

    public init(_ loggerType: Logger.Type, logTypes: Set<LogType>? = nil) {
        self.loggerType = loggerType
        self.logTypes = logTypes
    }
}

extension LoggerDescription: Equatable {
    public static func == (lhs: LoggerDescription, rhs: LoggerDescription) -> Bool {
        return lhs.loggerType == rhs.loggerType && lhs.logTypes == rhs.logTypes
    }
}

extension LoggerDescription: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self.loggerType))
    }
}
