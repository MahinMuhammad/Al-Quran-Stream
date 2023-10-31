//
//  HomeViewModel.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import Foundation

final class HomeViewModel:ObservableObject{
    let networkManager = NetworkManager()
    let numberOfSurahToFetch = 10
    @Published var playing = false
    @Published var surahs:[SurahModel] = []
    
    func loadSurah(){
        networkManager.fetchData(of: String(surahs.count+1)) { surah, error in
            if let surah{
                self.surahs.append(surah)
                if self.surahs.count < self.numberOfSurahToFetch{self.loadSurah()}
            }
        }
    }
}
