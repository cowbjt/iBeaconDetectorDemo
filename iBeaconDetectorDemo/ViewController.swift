//
//  ViewController.swift
//  iBeaconDetectorDemo
//
//  Created by cowbjt on 2017/11/25.
//  Copyright © 2017年 cowbjt. All rights reserved.
//

import UIKit
import CoreLocation

let defaultUuid = "594650A2-8621-401F-B5DE-6EB3EE398170"
let beaconId = "beacon.9487"

class ViewController: UIViewController {

    @IBOutlet weak var availableLable: UILabel!
    @IBOutlet weak var btn: UIButton!

    let locationManager = CLLocationManager()
    var beaconRegion: CLBeaconRegion? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        availableLable.text = "Available: \(checkAvailable() ? "OK":"NO")";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func detectClick(_ sender: Any) {
        guard let btnTitle = btn.title(for: .normal) else {
            return
        }

        if btnTitle == "Stop" {
            btn.setTitle("Detect", for: .normal)
            stopMonitor()
            stopRange()
            return
        }

        btn.setTitle("Stop", for: .normal)

        do {
            try startMonitor()
            try startRange()
        } catch {
            print("start to detect fail: \(error.localizedDescription)")
        }
    }
}

private extension ViewController {
    func checkAvailable() -> Bool {
        if !CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            return false
        }

        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.delegate = self

        return true
    }

    func startMonitor() throws {
        guard let beaconUuid = UUID(uuidString: defaultUuid) else {
            throw AppError(msg: "Invalid UUID")
        }

        let r = CLBeaconRegion(proximityUUID: beaconUuid, identifier: beaconId)
        r.notifyOnExit = true
        r.notifyOnEntry = true
        r.notifyEntryStateOnDisplay = true

        locationManager.startMonitoring(for: r)
        beaconRegion = r
    }

    func startRange() throws {
        if !CLLocationManager.isRangingAvailable() {
            throw AppError(msg: "Report NOT Supported")
        }

        guard let region = beaconRegion else {
            return
        }

        locationManager.startRangingBeacons(in: region)
    }

    func stopMonitor() {
        guard let region = beaconRegion else {
            return
        }

        locationManager.stopMonitoring(for: region)
    }

    func stopRange() {
        guard let region = beaconRegion else {
            return
        }

        if CLLocationManager.isRangingAvailable() {
            locationManager.stopRangingBeacons(in: region)
        }
    }
}

//MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count == 0 {
            print("No beacons")
            return
        }

        print("beacons: \(beacons)")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoringDidFailFor: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter: \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit: \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Start Monitoring")
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("didDetermineState : \(state == .inside ? "`In`" : "`Out` "): \(region)")
    }
}

