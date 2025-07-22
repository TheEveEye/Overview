/*
 Window/Window.swift
 Overview

 Created by William Pierce on 1/5/25.
*/

import Foundation

struct Window: Codable, Equatable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
    let windowName: String?

    var frame: NSRect {
        NSRect(x: x, y: y, width: width, height: height)
    }

    init(frame: NSRect, windowName: String? = nil) {
        self.x = frame.origin.x
        self.y = frame.origin.y
        self.width = frame.width
        self.height = frame.height
        self.windowName = windowName
    }
}
