//
//  BeaconDB.swift
//  BeaconDemo
//
//  Created by 이정진 on 2021/04/16.
//

import Foundation

class BeaconDB
{
    var Timestamp: String = ""
    var DeviceID: String = ""
    var major: Int = 0
    var minor: Int = 0
    var prox: String = ""
    var acc: Double
    var rssi: Int = 0
    
    
    init(Timestamp: String, DeviceID: String, major: Int, minor: Int, prox: String, acc: Double, rssi: Int)
    {
        self.Timestamp = Timestamp
        self.DeviceID = DeviceID
        self.major = major
        self.minor = minor
        self.prox = prox
        self.acc = acc
        self.rssi = rssi
        
    }
}

