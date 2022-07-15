//
//  NetworkManager.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 06.07.2022.
//

import Foundation

class NetworkManager {

    static func fetchDataAfterCodeRequest(jsonUrl: String, phoneNumber: String, completion: @escaping (Answer) -> ()) {
        
        let newJsonUrl = jsonUrl + phoneNumber
    
        guard let url = URL(string: newJsonUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }
            
            print(data)

            do {
                let answer = try JSONDecoder().decode(Answer.self, from: data)

                DispatchQueue.main.async {
                    completion(answer)
                }
                print(answer)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    static func fetchDataAfterEnteringTheCode(jsonUrl: String, phoneNumber: String, password: String, completion: @escaping (Answer2) -> ()) {
        
        let newJsonUrl = jsonUrl + phoneNumber + "&password=" + password
        
        guard let url = URL(string: newJsonUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }
            
            print(data)

            do {
                let answer = try JSONDecoder().decode(Answer2.self, from: data)

                DispatchQueue.main.async {
                    completion(answer)
                }
                print(answer)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    static func fetchDataAfterUserRequest(searchString: String, completion: @escaping (Search) -> ()) {
        
        let jsonUrl = "https://utcoin.one/loyality/search?search_string="
        let newJsonUrl = jsonUrl + searchString
    
        guard let url = URL(string: newJsonUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }
            
            print(data)

            do {
                let search = try JSONDecoder().decode(Search.self, from: data)

                DispatchQueue.main.async {
                    completion(search)
                }
                print(search)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
