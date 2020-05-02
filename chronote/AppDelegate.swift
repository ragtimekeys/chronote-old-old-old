//
//  AppDelegate.swift
//  chronote
//
//  Created by Jimmy Granger on 3/29/20.
//  Copyright © 2020 Jimmy Granger. All rights reserved.
//

/*
 Lots of code taken from
 https://www.andyibanez.com/posts/modern-background-tasks-ios13/
 */

import UIKit
import BackgroundTasks
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {
  var audioPlayer = AVAudioPlayer()
  var ringsAVAudioSession = AVAudioSession()
  var qoaqmSaver:BGTask? = nil
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
  successfully flag: Bool) {
    try! self.ringsAVAudioSession.setActive(false)
    self.qoaqmSaver?.setTaskCompleted(success: true)
  }
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    print("setting up sound")
    let sound = NSDataAsset(name: "quack")!
    try! ringsAVAudioSession.setCategory(.playback)
    audioPlayer = try! AVAudioPlayer(data: sound.data)
    let quackOnceAQuarterMinute = BGAppRefreshTaskRequest(identifier: "quackOnceAQuarterMinute")
    quackOnceAQuarterMinute.earliestBeginDate = Date(timeIntervalSinceNow: 5)
    let quackTaskScheduler = BGTaskScheduler.shared.register(forTaskWithIdentifier: "quackOnceAQuarterMinute", using: nil) { (qoaqm) in
      self.qoaqmSaver = qoaqm
      //begin sound playing
      print("attempting to play sound")
      try! self.ringsAVAudioSession.setActive(true)
      self.audioPlayer.play()
      self.audioPlayer.delegate = self
      //end sound playing
    }
    print("quackTaskScheduler: \(quackTaskScheduler)")
    try! BGTaskScheduler.shared.submit(quackOnceAQuarterMinute)
    BGTaskScheduler.shared.getPendingTaskRequests { (bgtr) in
      print("HEH \(bgtr)")
    }
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
}

