//
//  Log.swift
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

open class Log {
    public static let `default` = Log()

    open private(set) var label: String?
    open private(set) var sublabel: String?

    private lazy var queue: DispatchQueue = {
        let identifier = withUnsafePointer(to: self, {
            "io.sinoru.Logue.Log.\($0)"
        })

        return DispatchQueue(label: identifier + ".queue", attributes: [.concurrent], target: DispatchQueue.global(qos: .utility))
    }()

    open var loggerDescriptions: Set<LoggerDescription> = [] {
        didSet {
            self.reloadLoggers()
        }
    }

    private var loggers = [LoggerDescription: Logger]()
    private var loggerTypesDidChangedObservation: NSObjectProtocol?

    public init(label: String? = nil, sublabel: String? = nil) {
        self.label = label
        self.sublabel = sublabel

        self.loggerTypesDidChangedObservation = NotificationCenter.default.addObserver(forName: Log._loggerTypesChanged, object: Log.self, queue: nil) { [unowned self](_) in
            self.reloadLoggers()
        }

        self.reloadLoggers()
    }

    deinit {
        self.loggerTypesDidChangedObservation.flatMap { NotificationCenter.default.removeObserver($0) }
    }

    open func log(_ type: LogType, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, arguments args: [CVarArg]) {
        let loggers = self.loggers
        let group = DispatchGroup()

        loggers.forEach { (loggerDescription, logger) in
            self.queue.async(group: group) {
                guard loggerDescription.logTypes?.contains(type) != false else {
                    return
                }

                logger.log(message, dso: dso, type: type, arguments: args)
            }
        }

        group.wait()
    }

    private func reloadLoggers() {
        self.queue.sync(flags: [.barrier]) {
            var loggers = [LoggerDescription: Logger]()

            Log.loggerDescriptions.union(self.loggerDescriptions).forEach {
                loggers[$0] = self.loggers[$0] ?? $0.loggerType.init(label: self.label, sublabel: self.sublabel)
            }

            self.loggers = loggers
        }
    }
}

extension Log {
    private static let _loggerTypesChanged = NSNotification.Name("LogLoggerTypesChangedNotification")

    public static var loggerDescriptions: Set<LoggerDescription> = [LoggerDescription(StandardStreamsLogger.self)] {
        didSet {
            NotificationCenter.default.post(name: Log._loggerTypesChanged, object: self)
        }
    }
}

extension Log {
    @inlinable
    open func log(_ type: LogType = .default, dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        self.log(type, dso: dso, message, arguments: args)
    }

    @inlinable
    open func info(dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        self.log(.info, dso: dso, message, arguments: args)
    }

    @inlinable
    open func debug(dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        self.log(.debug, dso: dso, message, arguments: args)
    }

    @inlinable
    open func error(dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        self.log(.error, dso: dso, message, arguments: args)
    }

    @inlinable
    open func fault(dso: UnsafeRawPointer? = #dsohandle, _ message: StaticString, _ args: CVarArg...) {
        self.log(.fault, dso: dso, message, arguments: args)
    }

    @inlinable
    open class func log(_ type: LogType = .default, dso: UnsafeRawPointer? = #dsohandle, log: Log = Log.default, _ message: StaticString, _ args: CVarArg...) {
        log.log(type, dso: dso, message, arguments: args)
    }

    @inlinable
    open class func info(dso: UnsafeRawPointer? = #dsohandle, log: Log = Log.default, _ message: StaticString, _ args: CVarArg...) {
        log.log(.info, dso: dso, message, arguments: args)
    }

    @inlinable
    open class func debug(dso: UnsafeRawPointer? = #dsohandle, log: Log = Log.default, _ message: StaticString, _ args: CVarArg...) {
        log.log(.debug, dso: dso, message, arguments: args)
    }

    @inlinable
    open class func error(dso: UnsafeRawPointer? = #dsohandle, log: Log = Log.default, _ message: StaticString, _ args: CVarArg...) {
        log.log(.error, dso: dso, message, arguments: args)
    }

    @inlinable
    open class func fault(dso: UnsafeRawPointer? = #dsohandle, log: Log = Log.default, _ message: StaticString, _ args: CVarArg...) {
        log.log(.fault, dso: dso, message, arguments: args)
    }
}

extension Log: TextOutputStream {
    public func write(_ string: String) {
        self.log(.default, "%@", string)
    }
}
