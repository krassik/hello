//
//  ViewController.swift
//  hw
//
//  Created by TEAM LIFTOFF on 10/20/19.
//

import UIKit
import MapKit
import RxSwift
import CoreMotion
import RxCoreMotion
import AudioToolbox

class ViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  let coreMotionManager = CMMotionManager.rx.manager {
    let manager = CMMotionManager()
    // Use this to control the gyro refresh rate
    manager.gyroUpdateInterval = 1.0 / 10.0  // 10 Hz
    return manager
  }
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    mapView.camera.altitude = Double.greatestFiniteMagnitude
    
    /* This is the agitator when you need it
        // Mind you refresh rate for better outcome
    Timer.scheduledTimer(withTimeInterval: 2 , repeats: true) { [weak self] timer in
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }*/
    
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  
    coreMotionManager
      .flatMapLatest { manager in
        manager.rotationRate ?? Observable.empty()
      }
      
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] rotationRate in
        
        // print(rotationRate)
        
        // Filter information here to stabilize your image
        
        // Comment to restrict the axis
        // as your visualization needs
        self?.mapView.camera.centerCoordinate.longitude += -rotationRate.x * 360
        // self?.mapView.camera.centerCoordinate.latitude  += -rotationRate.y * 360
        // self?.mapView.camera.heading                    += -rotationRate.z * 360
        
      })
      .disposed(by: disposeBag)
  }
}

