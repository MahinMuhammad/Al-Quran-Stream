//
//  NetworkManager.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

import Foundation

final class NetworkManager{
    
    func fetchData(of numberOfSurah:String, completion: @escaping (SurahModel?, Error?)->Void){
        let urlString = "https://api.quran.gading.dev/surah/"
        if let url = URL(string: urlString+numberOfSurah){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error{
                    print("Failed to fetch data with error: \(error.localizedDescription)")
                    completion(nil,error)
                }else{
                    let decoder = JSONDecoder()
                    if let data{
                        do{
                            let result = try decoder.decode(Result.self, from: data)
                            DispatchQueue.main.async {
                                print("Data decoded successfully")
                                completion(result.data, nil)
                            }
                        }catch{
                            print("Failed to decode data with error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
