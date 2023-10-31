//
//  HomeViewModel.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import Foundation
import AVFoundation

final class HomeViewModel:ObservableObject{
    let networkManager = NetworkManager()
    let numberOfSurahToFetch = 10
    @Published var surahs:[SurahModel] = []
    var player = AVPlayer()
    @Published var playing = false
    
    func loadSurah(){
        networkManager.fetchData { surahs, error in
            if surahs.count > 0{
                self.surahs = surahs
            }
        }
    }
    
    func playPauseButtonPressed(){
        if player.timeControlStatus == .playing{
            player.pause()
        }else{
            player.play()
        }
    }
    
    func loadAudio(of number:String){
        if let url = URL(string: "https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/\(number).mp3"){
            print("Fetching audio...")
            player = AVPlayer(url: url)
            print("Playing audio...")
            player.play()
        }
    }
}
