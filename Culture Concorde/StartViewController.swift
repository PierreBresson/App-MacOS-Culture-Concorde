//
//  ViewController.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 10/11/2015.
//  Copyright © 2015 Culture Concorde. All rights reserved.
//

import Cocoa
import PopStatusItem
import AVFoundation
import SPMediaKeyTap
import Alamofire
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class StartViewController: NSViewController, NSUserNotificationCenterDelegate, musicDelegate {
    
    //For update purposes
    var currentVersion:Int = 1

    //Social
    var shareUrl = ""
    var shareUrlFb = "https://www.facebook.com/sharer/sharer.php?u="
    var shareUrlTwitter = "https://twitter.com/intent/tweet?text="
    var endUrl = " 🎵 &via=CultureConcorde" + " is dope!"
    
    var mediaTap: SPMediaKeyTap?
    
    var streamUrl = "http://api.soundcloud.com/"
    var soundcloudEND = "?client_id=366fa018589594af5cedb95b713f9917"
    var player : AVPlayer! = nil
    var initplay = false
    var play = false
    var canChangeSong = false
    
    //pour la fonction random
    var currentPlaylistName = "Chillwave"
    
    //pour la taille de la fenetre
    var fullsize = true
    
    //instance de la classe principale que l'on va manipuler
    var toto = SoundcloudSwiftPlayer()
    
    
////////////////////// CONTROLS
    
    func playCurrentPlaylist(){
        if toto.readyToPlaySongs {
            if initplay {
                if play {
                    playPauseBtn.image = NSImage(named: "play")
                    player.pause()
                    play=false
                } else {
                    playPauseBtn.image = NSImage(named: "pause")
                    player.play()
                    play=true
                }
            }
            
            //just for init purposes
            if !initplay {
                let url : String = streamUrl + "tracks/" + String(toto.currentSong.id) + "/stream" + soundcloudEND
                let soundURL : URL = URL(string: url as String)!
                
                songName.stringValue = toto.currentSong.songName
                artistName.stringValue = toto.currentSong.artistName
                
                player = AVPlayer(url: soundURL)
                player.play()
                initplay = true
                canChangeSong = true
                play = true
                playPauseBtn.image = NSImage(named: "pause")
            }
            
            NotificationCenter.default.addObserver(self,
                selector: #selector(StartViewController.songFinished),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: player.currentItem)
        }
    }
    
    func songFinished() {
        changeSong("next")
    }
    
    func changeSong(_ direction: String) {
        if toto.readyToPlaySongs && canChangeSong {
            if direction == "next" {
                func nextSong(_ completion: (_ changeN: Bool) -> Void) {
                    completion(toto.playNext())
                }
                nextSong({ (changeN) -> Void in
                    //play
                    if changeN {
                        let url : String = self.streamUrl + "tracks/" + String(self.toto.currentSong.id) + "/stream" + self.soundcloudEND
                        let soundURL : URL = URL(string: url as String)!
                        
                        self.songName.stringValue = self.toto.currentSong.songName
                        self.artistName.stringValue = self.toto.currentSong.artistName
                        
                        self.player = AVPlayer(url: soundURL)
                        self.player.play()
                        self.play = true
                        self.canChangeSong = true
                        
                        self.playPauseBtn.image = NSImage(named: "pause")
                        
                        NotificationCenter.default.addObserver(self,
                            selector: #selector(StartViewController.songFinished),
                            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                            object: self.player.currentItem)
                    }
                })
            }
            if direction == "prev" {
                func prevSong(_ completion: (_ changeP: Bool) -> Void) {
                    completion(toto.playPrev())
                }
                prevSong({ (changeP) -> Void in
                    //play
                    if changeP {
                        let url : String = self.streamUrl + "tracks/" + String(self.toto.currentSong.id) + "/stream" + self.soundcloudEND
                        let soundURL : URL = URL(string: url as String)!
                        
                        self.songName.stringValue = self.toto.currentSong.songName
                        self.artistName.stringValue = self.toto.currentSong.artistName
                        
                        self.player = AVPlayer(url: soundURL)
                        self.player.play()
                        self.play = true
                        self.canChangeSong = true
                        
                        self.playPauseBtn.image = NSImage(named: "pause")

                        NotificationCenter.default.addObserver(self,
                            selector: #selector(StartViewController.songFinished),
                            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                            object: self.player.currentItem)
                    }
                })
            }
        }
    }
    
    
    @IBOutlet weak var songName: NSTextField!
    
    @IBOutlet weak var artistName: NSTextField!
    

    @IBAction func previousSong(_ sender: AnyObject) {
        changeSong("prev")
    }
    
    @IBOutlet weak var playPauseBtn: NSButton!
    @IBAction func playPause(_ sender: AnyObject) {
        playCurrentPlaylist()
    }


    @IBAction func nextSong(_ sender: AnyObject) {
        changeSong("next")
    }

    
    
    
////////////////////// CATEGORIES & MONTHLY PLAYLISTS ACTIONS
    
    
    @IBAction func shareOnTwitter(_ sender: AnyObject) {
        if initplay {
            
            shareUrl = shareUrlTwitter + songName.stringValue + " by " + artistName.stringValue + endUrl
            
            if let url = URL(string: shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
                NSWorkspace.shared().open(url)
            }
        }
    }
    

    @IBAction func goToSoundcloud(_ sender: AnyObject) {
        if initplay {
            if let url = URL(string: toto.currentSong.soundcloudURL) {
                NSWorkspace.shared().open(url)
            }
        }
    }

    
////////////////////// CATEGORIES & MONTHLY PLAYLISTS ACTIONS
    
    
    @IBOutlet weak var categoryIcon: NSImageView!
    
    @IBOutlet weak var categoryName: NSTextField!
    
    @IBAction func changePlaylist(_ sender: AnyObject) {
        if initplay {
            switch currentPlaylistName {
            case "Chillwave":
                //change name of the category displayed
                categoryName.stringValue = "Funky House"
                //change current category name
                currentPlaylistName = "Funky House"
                //update the image
                categoryIcon.image = NSImage(named: "house")
                //load new playlist and play it
                toto.changePlaylist(name: currentPlaylistName)
                initplay = false
                playCurrentPlaylist()
            case "Funky House":
                categoryName.stringValue = "Deep & Tech"
                currentPlaylistName = "Deep & Tech"
                categoryIcon.image = NSImage(named: "deep")
                toto.changePlaylist(name: currentPlaylistName)
                initplay = false
                playCurrentPlaylist()
            case "Deep & Tech":
                categoryName.stringValue = "Mixtapes"
                currentPlaylistName = "Mixtapes"
                categoryIcon.image = NSImage(named: "mixtape")
                toto.changePlaylist(name: currentPlaylistName)
                initplay = false
                playCurrentPlaylist()
            case "Mixtapes":
                categoryName.stringValue = "Chillwave"
                currentPlaylistName = "Chillwave"
                categoryIcon.image = NSImage(named: "chill")
                toto.changePlaylist(name: currentPlaylistName)
                initplay = false
                playCurrentPlaylist()
            default:
                categoryName.stringValue = "Chillwave"
                currentPlaylistName = "Chillwave"
                categoryIcon.image = NSImage(named: "chill")
                toto.changePlaylist(name: currentPlaylistName)
                initplay = false
                playCurrentPlaylist()
            }
        }
    }

    
    /*@IBAction func playAllSongs(sender: AnyObject) {
        currentPlaylistName = "Chillwave"
        toto.changePlaylist(currentPlaylistName)
        initplay = false
        playCurrentPlaylist()
    }*/
    
    
    
    
    
////////////////////// Menu & load stuffs
    

    @IBOutlet weak var menuDown: CPopUpButton!
    @IBAction func menuDownAction(_ sender: AnyObject) {
        if menuDown.titleOfSelectedItem == "About" {
            if let url = URL(string: "http://cultureconcorde.com") {
                NSWorkspace.shared().open(url)
            }
        }
        if menuDown.titleOfSelectedItem == "Quit" {
            NSApplication.shared().terminate(self)
        }
    }
    
    

    /* A garder! Permet de réduire le nspopover et d'ouvrir une fenetre
    @IBAction func menuBtn(sender: AnyObject) {
        //close nspopover
        let CurrrentappDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        CurrrentappDelegate.popStatusItem.hidePopover()
        
        //open menu
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    */

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupMediaTap()
                
        let newDimensionW = 372
        let newDimensionH = 258
        
        let appDelegate: AppDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.popStatusItem.popover.contentSize = NSSize(width: newDimensionW, height: newDimensionH)
                
        artistName.textColor = NSColor.black
        
        songName.textColor = NSColor.black
        
        //cc user id is 37585068
        toto.grabDataUser(userID: 37585068)
        
        //thread
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            while self.toto.readyToPlaySongs == false {
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.songName.stringValue = "Ready, you can click on play ✌️"
                self.artistName.stringValue = "Full thrust, V1, rotate!"
            })
        })
        
        
        func getUpdate(_ completion: @escaping (_ result: Bool) -> Void) {
            let urlupdate = "http://cultureconcorde.com/updates/updateMac.json"
            
            Alamofire.request(urlupdate)
                .responseJSON { response in
                    guard let value = response.result.value else {
                        print("Pas de connexion internet")
                        completion(false)
                        return
                    }
                    var jsonEntry = JSON(value)
                    
                    //print("The jsonEntry is: " + jsonEntry.description)
                    //print(jsonEntry["current_version"].int)
                    //jsonEntry["current_version"].int > self.currentVersion
                    
                    if(jsonEntry["current_version"].int > self.currentVersion){
                        completion(true)
                        return
                    } else {
                        completion(false)
                        return
                    }
            }
        }
        
        getUpdate({ (result) -> Void in
            if (result == true) {
                self.performSegue(withIdentifier: "updateView", sender: self)
            } else {
                //print("pas de mise à jour ou pas de connexion internet")
            }
        })

        
        
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player.currentItem?.status == .failed {
            changeSong("next")
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setupMediaTap() {
        mediaTap = SPMediaKeyTap(delegate: self)
        mediaTap?.startWatchingMediaKeys()
    }
    override func mediaKeyTap(_ keyTap: SPMediaKeyTap!, receivedMediaKeyEvent event: NSEvent!) {
        let keyCode = (event.data1 & 0xFFFF0000) >> 16
        let keyFlags = event.data1 & 0x0000FFFF
        let keyPressed = ((keyFlags & 0xFF00) >> 8) == 0xA
        
        if keyPressed {
            switch keyCode {
            case Int(NX_KEYTYPE_PLAY):
                playCurrentPlaylist()
                return
            case Int(NX_KEYTYPE_FAST):
                changeSong("next")
                return
            case Int(NX_KEYTYPE_REWIND):
                changeSong("prev")
                return
            default:
                return
            }
        }
    }
    

}

