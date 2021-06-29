//
//  GetData.swift
//  Covid-19Api
//
//  Created by Furkan Hanci on 6/29/21.
//

import Foundation
import Combine


class getData : ObservableObject {
    
    @Published var data : Country!
    
    init(country: String) {
        updateData(country: country)
        
    }
    
    func updateData(country : String) {
        let url = "https://corona.lmao.ninja/v3/covid-19/countries/\(country)"
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data , response , error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Country.self, from: data!)
                
                DispatchQueue.main.async {
                    self.data = json
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
}
