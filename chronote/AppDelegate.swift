//
//  AppDelegate.swift
//  chronote
//
//  Created by Jimmy Granger on 3/29/20.
//  Copyright © 2020 Jimmy Granger. All rights reserved.
//

import UIKit
import BackgroundTasks
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var audioPlayer = AVAudioPlayer()
  var ringsAVAudioSession = AVAudioSession()
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    print("setting up sound")
    let sound = NSDataAsset(name: "quack")!
    try! ringsAVAudioSession.setCategory(.playback)
    audioPlayer = try! AVAudioPlayer(data: sound.data)
    let quackOnceAQuarterMinute = BGAppRefreshTaskRequest(identifier: "quackOnceAQuarterMinute")
    quackOnceAQuarterMinute.earliestBeginDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())
      //Date(timeIntervalSinceNow: 5)
    BGTaskScheduler.shared.cancelAllTaskRequests()
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "quackOnceAQuarterMinute", using: nil) { (qoaqm) in
      //begin sound playing
      print("attempting to play sound")
      try! self.ringsAVAudioSession.setActive(true)
      self.audioPlayer.play()
      try! self.ringsAVAudioSession.setActive(false)
      //end sound playing
      qoaqm.setTaskCompleted(success: true)
    }
    try! BGTaskScheduler.shared.submit(quackOnceAQuarterMinute)
    
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
}

