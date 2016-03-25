//
//  ViewController.swift
//  AccessingMusicLib
//
//  Created by Nam (Nick) N. HUYNH on 3/25/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var buttonPickAndPlay: UIButton!
    @IBOutlet weak var buttonStopPlaying: UIButton!
    var myMusicPlayer: MPMusicPlayerController?
    var mediaPicker: MPMediaPickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Media picker..."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func displayMediaPickerAndPlayItem(sender: AnyObject) {
        
        mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.AnyAudio)
        if let picker = mediaPicker {
            
            println("Successfully instantiated a media picker")
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            picker.showsCloudItems = true
            picker.prompt = "Pick a song please..."
            picker.allowsPickingMultipleItems = true
            view.addSubview(picker.view)
            presentViewController(picker, animated: true, completion: nil)
            
        } else {
            
            println("Could not instantiate a media picker")
            
        }
        
    }

    @IBAction func stopPlayingAudio(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if let player = myMusicPlayer {
            
            player.stop()
            
        }
        
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController!, didPickMediaItems mediaItemCollection: MPMediaItemCollection!) {
        
        println("Media picker returned")
        myMusicPlayer = MPMusicPlayerController()
        if let player = myMusicPlayer {
            
            player.beginGeneratingPlaybackNotifications()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "musicPlayerStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "nowPlayingItemIsChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "volumeIsChanged:", name: MPMusicPlayerControllerVolumeDidChangeNotification, object: nil)
            player.setQueueWithItemCollection(mediaItemCollection)
            player.play()
            mediaPicker.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) {
        
        println("Media Picker was cancelled")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func musicPlayerStateChanged(notification: NSNotification) {
        
        println("Player state changed")
        let stateAsObject = notification.userInfo!["MPMusicPlayerControllerPlaybackStateKey"] as? NSNumber
        if let state = stateAsObject {
            
            switch MPMusicPlaybackState(rawValue: state.integerValue)! {
                
            case MPMusicPlaybackState.Stopped:
                println("Stopped")
            case MPMusicPlaybackState.Playing:
                println("Playing")
            case MPMusicPlaybackState.Paused:
                println("Paused")
            case MPMusicPlaybackState.Interrupted:
                println("Interrupted")
            case MPMusicPlaybackState.SeekingBackward:
                println("Seeking backward")
            case MPMusicPlaybackState.SeekingForward:
                println("Seeking forward")
                
            }
            
        }
        
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification) {
        
        println("Playing item changed")
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        let persistentID = notification.userInfo![key] as? NSString
        if let id = persistentID {
            
            println("Persistent ID = \(id)")
            
        }
        
    }
 
    func volumeIsChanged(notification: NSNotification) {
        
        println("Volume changed")
        
    }
    
}