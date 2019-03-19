//
//  LogType.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//

import Foundation

public struct LogType: RawRepresentable, Equatable, Hashable {
    public typealias RawValue = Int

    public let rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

extension LogType {
    public static let `default` = LogType(rawValue: 1 << 0 + 0)
    public static let info = LogType(rawValue: 1 << 0 + 1)
    public static let debug = LogType(rawValue: 1 << 0 + 2)

    public static let error = LogType(rawValue: 1 << 4 + 0)
    public static let fault = LogType(rawValue: 1 << 4 + 1)
}
