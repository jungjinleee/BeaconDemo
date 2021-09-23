//
//  ViewController.swift
//  BeaconDemo
//  
//  Created by 이정진 on 2021/04/13.
//


import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    private var locationManager: CLLocationManager?
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    var db:DBHelper = DBHelper()
    var BeaconDBs:[BeaconDB] = []
    
    var Timestamp: NSMutableArray!
    var BeaconUuid: NSMutableArray!
    var Beaconmajor: NSMutableArray!
    var Beaconminor: NSMutableArray!
    var Beaconprox: NSMutableArray!
    var Beaconrssi: NSMutableArray!
    var Beaconacc: NSMutableArray!
    var BeaconCount: Int = 0
    var BeaconNum: Int = 5
    
    let uuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
    let name = UIDevice.current.name
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways,
           CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
           CLLocationManager.isRangingAvailable(){
            startScanning()
        }
    }
    
    func startScanning() {
        let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString:uuid)!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "Mbeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        Timestamp = NSMutableArray()
        BeaconUuid = NSMutableArray()
        Beaconmajor = NSMutableArray()
        Beaconminor = NSMutableArray()
        Beaconrssi = NSMutableArray()
        Beaconprox = NSMutableArray()
        Beaconacc = NSMutableArray()
//        let formatter = DateFormatter()
//                    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//                    formatter.timeZone = TimeZone(abbreviation: "KST")
                
        
        if beacons.count >= BeaconNum {
            BeaconCount = BeaconNum
            
            for i in 0 ..< BeaconNum {
                
                let beacon = beacons[i]
                let timestamp = formatter.string(from: beacon.timestamp)
                let beaconUuid = beacon.uuid;
                let beaconmajor = beacon.major;
                let beaconminor = beacon.minor;
                let beaconrssi = beacon.rssi;
                let beaconacc = beacon.accuracy;
               
                var beaconprox: String {
                    switch (beacon.proximity) {
                    case CLProximity.far:
                        return "Far"
                    case CLProximity.near:
                        return "Near"
                    
                    case CLProximity.immediate:
                        return "Immediate";
                    default:
                        return "Unknown"
                    }
                }
                Beaconprox.add(beaconprox)
                              
                db.insert(Timestamp: timestamp, DeviceID: name, major: Int(truncating: beaconmajor), minor: Int(truncating: beaconminor), prox: beaconprox, acc: beaconacc, rssi: Int(beaconrssi))
                //Uuid 기존: beaconUuid.uuidString 에서 name으로 변경
                Timestamp.add(timestamp)
                BeaconUuid.add(beaconUuid.uuidString)
                Beaconmajor.add(Int(truncating: beaconmajor))
                Beaconminor.add(Int(truncating: beaconminor))
                Beaconrssi.add(String(beaconrssi))
                Beaconacc.add(String(beaconacc))
                
            }
            TableViewMain.reloadData()
        }
        
        else if beacons.count > 0 && beacons.count < BeaconNum {
            BeaconCount = beacons.count
            
            for i in 0 ..< beacons.count {
                
                let beacon = beacons[i]
                let timestamp = formatter.string(from: beacon.timestamp)
                let beaconUuid = beacon.uuid;
                let beaconmajor = beacon.major;
                let beaconminor = beacon.minor;
                let beaconrssi = beacon.rssi;
                let beaconacc = beacon.accuracy;
               
                var beaconprox: String {
                    switch (beacon.proximity) {
                    case CLProximity.far:
                        return "Far"
                    case CLProximity.near:
                        return "Near"
                    
                    case CLProximity.immediate:
                        return "Immediate";
                    default:
                        return "Unknown"
                    }
                }
                Beaconprox.add(beaconprox)
                              
                db.insert(Timestamp: timestamp, DeviceID: name, major: Int(truncating: beaconmajor), minor: Int(truncating: beaconminor), prox: beaconprox, acc: beaconacc, rssi: Int(beaconrssi))
                
                Timestamp.add(timestamp)
                BeaconUuid.add(beaconUuid.uuidString)
                Beaconmajor.add(Int(truncating: beaconmajor))
                Beaconminor.add(Int(truncating: beaconminor))
                Beaconrssi.add(String(beaconrssi))
                Beaconacc.add(String(beaconacc))
                
            }
            TableViewMain.reloadData()
        }
        else {
            print("no detected")
            BeaconCount = 0
            TableViewMain.reloadData()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeaconCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "ViewType1", for: indexPath) as! ViewType1
        cell.Timestamp.text = "Time: \(Timestamp[indexPath.row])"
        cell.DeviceID.text = "\(BeaconUuid[indexPath.row])"
        cell.Major.text = "Major: \(Beaconmajor[indexPath.row])"
        cell.Minor.text = "Minor: \(Beaconminor[indexPath.row])"
        cell.Prox.text = "Prox: \(Beaconprox[indexPath.row])"
        cell.Rssi.text = "RSSI: \(Beaconrssi[indexPath.row])"
        cell.Acc.text = "Accuracy: \(Beaconacc[indexPath.row]) [m]"
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        BeaconDBs = db.read()
    }
}

