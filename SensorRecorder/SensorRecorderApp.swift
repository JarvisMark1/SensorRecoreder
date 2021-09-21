//
//  SensorRecorderApp.swift
//  SensorRecorder
//
//  Created by jarvis on 2021/8/29.
//

import SwiftUI

@main
struct SensorRecorderApp: App {
    let viewModel = MotionManager() //create viewModel
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
