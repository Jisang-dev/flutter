import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var start : Double = 0
    var count : Int = 0
    var cycle : Int = 60
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "sample.hyla981020.com/bg", binaryMessenger: controller)
        
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "initLocation" || call.method == "stop" || call.method == "start" || call.method == "cp1" || call.method == "cp2" else {
                result(FlutterMethodNotImplemented)
                return
            }
            if (call.method == "initLocation") {
                self?.initLocation(result: result)
            } else if (call.method == "stop") {
                self?.stop(result: result)
            } else if (call.method == "start") {
                self?.start(result: result)
            } else if (call.method == "cp1") {
                self?.cp1(result: result)
            } else if (call.method == "cp2") {
                self?.cp2(result: result)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    private func initLocation(result: FlutterResult) {
        start = NSDate().timeIntervalSince1970
        count = 0
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.pausesLocationUpdatesAutomatically = false
        //        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //        locationManager.distanceFilter = 400
        locationManager.startUpdatingLocation()
    }
    private func start(result: FlutterResult) {
        cycle = 60
        count = 0
    }
    private func cp1(result: FlutterResult) {
        cycle = 30
        count = 0
    }
    private func cp2(result: FlutterResult) {
        cycle = 5
        count = 0
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if ((locations.last?.timestamp.timeIntervalSince1970)! > Double(count * cycle) + start) {
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let channel = FlutterMethodChannel(name: "sample.hyla981020.com/bg", binaryMessenger: controller)
            channel.invokeMethod("background", arguments: "\(locations.last?.coordinate.latitude ?? 0),\(locations.last?.coordinate.longitude ?? 0)")
            count = count + 1
            if (count < Int(((locations.last?.timestamp.timeIntervalSince1970)! - start)) / cycle) {
                count = Int(((locations.last?.timestamp.timeIntervalSince1970)! - start)) / cycle
            }
            if (count < 0) {
                count = 0
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
    
    private func stop(result: FlutterResult) {
        locationManager.stopUpdatingLocation()
    }
}
