//
//  motionManager.swift
//  SensorRecorder
//
//  Created by jarvis on 2021/9/8.
//

import Foundation
import Combine
import CoreMotion

class MotionManager: ObservableObject{

    private var motionManager: CMMotionManager
    private let Freq: Double = 50.0
    @Published private(set) var sensorData: SensorData
    @Published private(set) var LineChartDataX: Array<Double>
    @Published private(set) var LineChartDataY: Array<Double>
    @Published private(set) var LineChartDataZ: Array<Double>
    @Published private(set) var TimeList: Array<Double>
    private var curT: Double = 0.0
    init() {
        sensorData = SensorData()
        self.motionManager = CMMotionManager()
        self.motionManager.magnetometerUpdateInterval = 1/Freq
        LineChartDataX = Array<Double>()
        LineChartDataY = Array<Double>()
        LineChartDataZ = Array<Double>()
        TimeList = Array<Double>()
    }
    func start() {
        //self.motionManager.startMagnetometerUpdates(to: .main) { (magnetometerData, error) in
        self.motionManager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let data = motionData {
                self.sensorData.attitude.x = data.attitude.pitch
                self.sensorData.attitude.y = data.attitude.roll
                self.sensorData.attitude.z = data.attitude.yaw
                
                self.sensorData.acc.x = data.gravity.x
                self.sensorData.acc.y = data.gravity.y
                self.sensorData.acc.z = data.gravity.z
                
                self.sensorData.gyr.x = data.rotationRate.x
                self.sensorData.gyr.y = data.rotationRate.y
                self.sensorData.gyr.z = data.rotationRate.z
                
                self.LineChartDataX.append(data.gravity.x * 9.81)
                self.LineChartDataY.append(data.gravity.y * 9.81)
                self.LineChartDataZ.append(data.gravity.z * 9.81)
                self.curT += 1/self.Freq
                self.TimeList.append(self.curT)
                if self.LineChartDataX.count > 80 {
                    self.LineChartDataX.removeFirst()
                    self.LineChartDataY.removeFirst()
                    self.LineChartDataZ.removeFirst()
                    self.TimeList.removeFirst()
                }
            }
        }
        self.motionManager.startMagnetometerUpdates(to: .main) { (magnetometerData, error) in
            guard error == nil else {
                print(error!)
                return;
            }
            if let magneticData = magnetometerData {
                self.sensorData.mag.x = magneticData.magneticField.x
                self.sensorData.mag.y = magneticData.magneticField.y
                self.sensorData.mag.z = magneticData.magneticField.z
            }
        }
    }
    
    func stop() {
        print("stop")
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopMagnetometerUpdates()
    }
    
    struct SensorData {
        var attitude: Attitude = Attitude()
        var acc: AccData = AccData()
        var gyr: GyrData = GyrData()
        var mag: MagData = MagData()
    }
    struct Attitude {
        
        var x: Double = 0.0
        var y: Double = 0.0
        var z: Double = 0.0
    }
    struct AccData {
        var x: Double = 0.0
        var y: Double = 0.0
        var z: Double = 0.0
    }
    struct GyrData {
        var x: Double = 0.0
        var y: Double = 0.0
        var z: Double = 0.0
    }
    struct MagData {
        var x: Double = 0.0
        var y: Double = 0.0
        var z: Double = 0.0
    }
    
}
