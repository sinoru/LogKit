//
//  OSLogger.swift
//  LogKit
//
//  Created by Sinoru on 19/03/2019.
//

#if canImport(os)

import Foundation
import os

// MARK: - Workaround
// https://github.com/apple/swift/blob/6e7051eb1e38e743a514555d09256d12d3fec750/stdlib/public/Darwin/os/os_log.swift#L34

import _SwiftOSOverlayShims

@available(macOS 10.12, iOS 10.0, *)
private func os_log(
    _ message: StaticString,
    dso: UnsafeRawPointer? = #dsohandle,
    log: OSLog = .default,
    type: OSLogType = .default,
    arguments: [CVarArg])
{
    guard log.isEnabled(type: type) else { return }
    let ra = _swift_os_log_return_address()

    message.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
        // Since dladdr is in libc, it is safe to unsafeBitCast
        // the cstring argument type.
        buf.baseAddress!.withMemoryRebound(
            to: CChar.self, capacity: buf.count
        ) { str in
            withVaList(arguments) { valist in
                _swift_os_log(dso, ra, log, type, str, valist)
            }
        }
    }
}
// MARK: -

@available(macOS 10.12, iOS 10.0, *)
public class OSLogger: Logger {
    let osLog: OSLog

    public required init(label: String?, sublabel: String?) {
        if let label = label, let sublabel = sublabel {
            self.osLog = OSLog(subsystem: label, category: sublabel)
        } else {
            self.osLog = OSLog.default
        }
    }

    public func log(_ message: StaticString, dso: UnsafeRawPointer?, type: LogType, arguments: [CVarArg]) {
        let osLogType: OSLogType = {
            switch type {
            case .info:
                return .info
            case .debug:
                return .debug
            case .error:
                return .error
            case .fault:
                return .fault
            default:
                return .default
            }
        }()

        os_log(message, dso: dso, log: self.osLog, type: osLogType, arguments: arguments)
    }
}

#endif
