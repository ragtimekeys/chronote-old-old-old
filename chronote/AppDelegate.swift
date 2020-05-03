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
    //begin copy
    print("ONE")
    let quackOnceAQuarterMinute = BGAppRefreshTaskRequest(identifier: "quackOnceAQuarterMinute")
    quackOnceAQuarterMinute.earliestBeginDate = Date(timeIntervalSinceNow: 20000)
      try! BGTaskScheduler.shared.submit(quackOnceAQuarterMinute)
    //end copy 
    print("TWO")
  }
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    print("setting up sound")
    let sound = NSDataAsset(name: "quack")!
    try! ringsAVAudioSession.setCategory(.playback)
    
    audioPlayer = try! AVAudioPlayer(data: sound.data)
    try! ringsAVAudioSession.setActive(true)
    application.beginReceivingRemoteControlEvents()
    audioPlayer.delegate = self
    
    let quackOnceAQuarterMinute = BGAppRefreshTaskRequest(identifier: "quackOnceAQuarterMinute")
    quackOnceAQuarterMinute.earliestBeginDate = Date(timeIntervalSinceNow: 20000)
    let quackTaskScheduler = BGTaskScheduler.shared.register(forTaskWithIdentifier: "quackOnceAQuarterMinute", using: nil) { (qoaqm) in
      self.qoaqmSaver = qoaqm
      //begin sound playing
      print("attempting to play sound")
      try! self.ringsAVAudioSession.setActive(true)
      self.audioPlayer.numberOfLoops = -1
      self.audioPlayer.volume = 1
      if (self.audioPlayer.prepareToPlay()) {
        self.audioPlayer.play()
      }
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

/*
 command to get it to run the task
 
 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"quackOnceAQuarterMinute"]
 */
