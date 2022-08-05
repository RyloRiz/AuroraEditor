//
//  Formatters.swift
//  AuroraEditor
//
//  Created by Nanashi Li on 2022/08/04.
//  Copyright © 2022 Aurora Company. All rights reserved.
//

extension Formatters {
    public static let `default` = Formatter("[%@] %@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .location,
        .level,
        .message
    ])

    public static let minimal = Formatter("%@ %@: %@", [
        .location,
        .level,
        .message
    ])

    public static let detailed = Formatter("[%@] %@.%@:%@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .file(fullPath: false, fileExtension: false),
        .function,
        .line,
        .level,
        .message
    ])
}