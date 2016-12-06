//
//  SoundcloudPlayerSwift.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 13/11/2015.
//  Copyright © 2015 Culture Concorde. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Array
{
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if (i != j){
                swap(&self[i], &self[j])
            }
        }
    }
}

class SoundcloudSwiftPlayer {
    
    struct Song {
        var id: Int
        var songName: String
        var artistName: String
        var soundcloudURL: String
    }
    
    ///////////////// VARIABLES
    
    var playlistChillwave = [Song]()
    var playlistFunkyHouse = [Song]()
    var playlistDeepAndTech = [Song]()
    var playlistMixtapes = [Song]()
    
    var random = true
    var currentPlaylist = [Song]()
    var currentSong = Song(id: 0, songName: "toto", artistName: "asticot", soundcloudURL: "url")
    var currentSongIndex = 0
    
    var readyToPlaySongs = false
    var jSONdata = JSON("")
    var streamUrl = "http://api.soundcloud.com/"
    var soundcloudEND = "?client_id=YourSoundcloudIdHere"
    
    
    ///////////////// GRAB
    
    func randomCurrentPlaylist(){
        currentPlaylist.shuffle()
    }
    
    func grabDataUser(userID: Int){
        //For init purposes
        //get user data for soundcloud to json
        
        func extablishConnexion(completion: @escaping (_ result: Bool) -> Void) {
            
            let url = streamUrl + "users/" + String(userID) + "/playlists" + soundcloudEND
            
            Alamofire.request(url)
                .responseJSON { response in
                    guard let value = response.result.value else {
                        print("Pas de connexion internet")
                        completion(false)
                        return
                    }
                    let jsonEntry = JSON(value)
                    self.jSONdata = jsonEntry
                    //print("The jsonEntry is: " + jsonEntry.description)
                    //print(jsonEntry["errors"][0]["error_message"])
                    
                    if(jsonEntry["errors"][0]["error_message"] != nil ){
                        completion(false)
                        return
                    } else {
                        completion(true)
                        return
                    }
            }
        }
        
        extablishConnexion(completion: { (result) -> Void in
            if (result == true) {
                print("Connection established with success")
                self.processAllSongs()
            }else {
                print("Failure while connecting")
                //handle error
            }
        })

        
    }
    
    
    ///////////////// PROCESS
    
    func processAllSongs() {
        if let data = jSONdata.array {
            for i in 0...data.count-1{
                
                if "Chillwave" == data[i]["title"] {
                    if let dataPlaylist = data[i]["tracks"].array {
                        for j in 0...dataPlaylist.count-1 {
                            if dataPlaylist[j]["streamable"].bool! {
                                let song = Song(id: dataPlaylist[j]["id"].int!, songName: dataPlaylist[j]["title"].string!, artistName: dataPlaylist[j]["user"]["username"].string!, soundcloudURL: dataPlaylist[j]["permalink_url"].string!)
                                playlistChillwave.append(song)
                            }
                        }
                    }
                }
                
                if "Funky House" == data[i]["title"] {
                    if let dataPlaylist = data[i]["tracks"].array {
                        for j in 0...dataPlaylist.count-1 {
                            if dataPlaylist[j]["streamable"].bool! {
                                let song = Song(id: dataPlaylist[j]["id"].int!, songName: dataPlaylist[j]["title"].string!, artistName: dataPlaylist[j]["user"]["username"].string!, soundcloudURL: dataPlaylist[j]["permalink_url"].string!)
                                playlistFunkyHouse.append(song)
                            }
                        }
                    }
                }
                
                if "Deep & Tech" == data[i]["title"] {
                    if let dataPlaylist = data[i]["tracks"].array {
                        for j in 0...dataPlaylist.count-1 {
                            if dataPlaylist[j]["streamable"].bool! {
                                let song = Song(id: dataPlaylist[j]["id"].int!, songName: dataPlaylist[j]["title"].string!, artistName: dataPlaylist[j]["user"]["username"].string!, soundcloudURL: dataPlaylist[j]["permalink_url"].string!)
                                playlistDeepAndTech.append(song)
                            }
                        }
                    }
                }
                
                if "Mixtapes" == data[i]["title"] {
                    if let dataPlaylist = data[i]["tracks"].array {
                        for j in 0...dataPlaylist.count-1 {
                            if dataPlaylist[j]["streamable"].bool! {
                                let song = Song(id: dataPlaylist[j]["id"].int!, songName: dataPlaylist[j]["title"].string!, artistName: dataPlaylist[j]["user"]["username"].string!, soundcloudURL: dataPlaylist[j]["permalink_url"].string!)
                                playlistMixtapes.append(song)
                            }
                        }
                    }
                }
            }
        }
        
        
        currentPlaylist = playlistChillwave
        randomCurrentPlaylist()
        print("Processing audio is done")
        playAfterInit()
    }
    
    
    ///////////////// PLAY
    
    func playAfterInit() {
        //Play random playlistAll
        
        //let nbOfSongs = currentPlaylist.count
        //arc4random_uniform(n) for a random integer between 0 and n-1
        //let getRandomNb = Int(arc4random_uniform(UInt32(nbOfSongs)) + 1)
        
        currentSong = Song(id: currentPlaylist[0].id, songName: currentPlaylist[0].songName, artistName: currentPlaylist[0].artistName, soundcloudURL: currentPlaylist[0].soundcloudURL)
        
        currentSongIndex = 0
        readyToPlaySongs = true
    }
    
    func play(nameOfPlaylist: String, songIndex: Int) {
        /*let track_id = jSONdata[0]["tracks"][0]["id"].int!
         
         let url : String = streamUrl + "tracks/" + String(track_id) + "/stream" + soundcloudEND
         
         let soundURL : NSURL = NSURL(string: url as String)!
         
         print(soundURL)
         
         player = AVPlayer(URL: soundURL)
         player.play()*/
    }
    
    func playNext() -> Bool {
        if currentSongIndex >= currentPlaylist.count-1 {
            currentSongIndex = 0
            currentSong = Song(id: currentPlaylist[currentSongIndex].id, songName: currentPlaylist[currentSongIndex].songName, artistName: currentPlaylist[currentSongIndex].artistName, soundcloudURL: currentPlaylist[currentSongIndex].soundcloudURL)
        } else {
            currentSongIndex += 1
            currentSong = Song(id: currentPlaylist[currentSongIndex].id, songName: currentPlaylist[currentSongIndex].songName, artistName: currentPlaylist[currentSongIndex].artistName, soundcloudURL: currentPlaylist[currentSongIndex].soundcloudURL)
        }
        print(currentSongIndex)
        return true
    }
    
    func playPrev() -> Bool {
        if currentSongIndex == 0 {
            currentSongIndex = currentPlaylist.count - 1
            currentSong = Song(id: currentPlaylist[currentSongIndex].id, songName: currentPlaylist[currentSongIndex].songName, artistName: currentPlaylist[currentSongIndex].artistName, soundcloudURL: currentPlaylist[currentSongIndex].soundcloudURL)
        } else {
            currentSongIndex -= 1
            currentSong = Song(id: currentPlaylist[currentSongIndex].id, songName: currentPlaylist[currentSongIndex].songName, artistName: currentPlaylist[currentSongIndex].artistName, soundcloudURL: currentPlaylist[currentSongIndex].soundcloudURL)
        }
        print(currentSongIndex)
        return true
    }
    
    func changePlaylist(name: String) -> Void {
        switch name {
            
        case "Chillwave":
            currentPlaylist = playlistChillwave
        case "Funky House":
            currentPlaylist = playlistFunkyHouse
        case "Deep & Tech":
            currentPlaylist = playlistDeepAndTech
        case "Mixtapes":
            currentPlaylist = playlistMixtapes
        default:
            print("default => shouldn't be here => check code")
            currentPlaylist = playlistChillwave
        }
        randomCurrentPlaylist()
        currentSong = Song(id: currentPlaylist[0].id, songName: currentPlaylist[0].songName, artistName: currentPlaylist[0].artistName, soundcloudURL: currentPlaylist[0].soundcloudURL)
        currentSongIndex = 0
        
    }
}
