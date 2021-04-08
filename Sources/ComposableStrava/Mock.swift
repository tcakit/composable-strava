//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation

public extension StravaManager {
    static func unimplemented() -> Self { Self() }
}

func _unimplemented(
    _ function: StaticString, file: StaticString = #file, line: UInt = #line
) -> Never {
    fatalError(
        """
        `\(function)` was called but is not implemented. Be sure to provide an implementation for
        this endpoint when creating the mock.
        """,
        file: file,
        line: line
    )
}
