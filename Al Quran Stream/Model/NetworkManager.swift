//
//  NetworkManager.swift
//  Al Quran Stream
//
//  Created by Md. Mahinur Rahman on 10/30/23.
//

/*
 Copyright 2023 Md. Mahinur Rahman
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

final class NetworkManager{
    
    func fetchData(completion: @escaping ([SurahModel], Error?)->Void){
        let urlString = "https://api.quran.gading.dev/surah/"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error{
                    print("Failed to fetch data with error: \(error.localizedDescription)")
                    completion([],error)
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
                            completion([], error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    //I will uncomment when I will let uer to download a surah
//    func fetchAudio(from urlString:String, completion: @escaping (URL?, Error?)->Void){
//        if let url = URL(string: urlString){
//            let session = URLSession(configuration: .default)
//            let task = session.downloadTask(with: url) { url, response, error in
//                if let error{
//                    print("Failed to download audio contents with error: \(error.localizedDescription)")
//                }else{
//                    completion(url, error)
//                }
//            }
//            task.resume()
//        }
//    }
}
