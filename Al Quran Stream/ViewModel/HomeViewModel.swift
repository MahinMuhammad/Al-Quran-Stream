//
//  HomeViewModel.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import Foundation
import AVFoundation

enum MasterButtonStatus{
    case playPause
    case reload
}

final class HomeViewModel:ObservableObject{
    let networkManager = NetworkManager()
    @Published var surahs:[SurahModel] = []
    
    @Published var player:AVPlayer?
    @Published var playing = false
    @Published var buttonStatus = MasterButtonStatus.playPause
    
    let finishPlayingNotification = NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
    
    
    func loadSurah(){
        networkManager.fetchData { surahs, error in
            if surahs.count > 0{
                self.surahs = surahs
            }
        }
    }
    
    func replaySurah(){
        player?.seek(to: .zero)
        player?.play()
        buttonStatus = .playPause
    }
    
    func playPauseButtonPressed(){
        if let player{
            if player.timeControlStatus == .playing{
                player.pause()
                playing = false
            }else{
                player.play()
                playing = true
            }
        }else{
            print("AVPlayer not loaded")
        }
    }
    
    func loadAudio(of number:String){
        if let url = URL(string: "https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/\(number).mp3"){
            let item = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: item)
            player?.play()
            playing = true
        }
    }
}
