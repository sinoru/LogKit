//
//  LoggerDescription.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//

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
