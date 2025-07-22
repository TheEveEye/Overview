/*
 Settings/Services/LoginItemService.swift
 Overview

 Created by William Pierce on 3/19/25.

 Manages enabling or disabling Overview as a login item by
 creating or removing a LaunchAgent in the user's Library.
*/

import Foundation

@MainActor
final class LoginItemService: ObservableObject {
    static let shared = LoginItemService()
    private let logger = AppLogger.settings

    private init() {}

    func setLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try createLaunchAgent()
                logger.info("Enabled launch at login")
            } else {
                try removeLaunchAgent()
                logger.info("Disabled launch at login")
            }
        } catch {
            logger.logError(error, context: "Updating launch at login")
        }
    }

    private var agentURL: URL {
        let bundleID = Bundle.main.bundleIdentifier ?? "com.overview"
        return FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents")
            .appendingPathComponent("\(bundleID).launchAgent.plist")
    }

    private func createLaunchAgent() throws {
        let directory = agentURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        let contents: [String: Any] = [
            "Label": Bundle.main.bundleIdentifier ?? "com.overview",
            "ProgramArguments": [Bundle.main.bundlePath],
            "RunAtLoad": true
        ]

        let data = try PropertyListSerialization.data(fromPropertyList: contents, format: .xml, options: 0)
        try data.write(to: agentURL, options: .atomic)
    }

    private func removeLaunchAgent() throws {
        if FileManager.default.fileExists(atPath: agentURL.path) {
            try FileManager.default.removeItem(at: agentURL)
        }
    }
}
