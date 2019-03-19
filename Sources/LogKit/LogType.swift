//
//  LogType.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//  Copyright © 2019 Sinoru. All rights reserved.
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
