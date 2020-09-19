//
//  ContentView.swift
//  Covid-19Api
//
//  Created by Furkan Hanci on 9/19/20.
//

import SwiftUI

struct Country : Codable {
    
    var country : String
    var updated: Double
    var cases : Double
    var active : Double
    var recovered : Double
    var countryInfo : CountryInfo
    
}


struct CountryInfo : Codable {
    
    var _id: Int
    var iso2: String
    var iso3 : String
    var lat : Int
    var long : Int
    var flag : String
    
}


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


func getValue(data : Double) -> String {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    
    return format.string(from:  NSNumber(value : data))!
}


func getImage(imageString : String) -> UIImage {
    
    let imageURL = URL(string: imageString)
    let imageData = try! Data(contentsOf: imageURL!)
    let image = UIImage(data: imageData)
    return image!
    
}


struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
       
    }
    
}


struct ContentView: View {
    
    @ObservedObject var data = getData(country: "canada")
    
    @State var country: String = "canada"
    
    var body: some View {
        
        ZStack {
            
            
            if self.data.data != nil {
                
                VStack(alignment : .center) {
                    
                    Text("Covid-19 Virus")
                        .font(.system(size: 30))
                        .bold()
                    
                    HStack {
                        
                        TextField("Enter your country here" , text: $country)
                            .padding(10)
                            .font(Font.system(size: 15 , weight: .medium , design: .serif))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue , lineWidth: 1))
                        
                        Button(action: {
                            self.data.updateData(country: self.country)
                            
                        }) {
                            Text("Enter")
                        }
                        
                    }.frame(width: 250).padding()
                    
                    
                    Image(uiImage: getImage(imageString: data.data.countryInfo.flag))
                        .resizable()
                        .frame(width: 250, height: 125, alignment: .center)
                    Text("Total Cases: \(getValue(data: self.data.data.cases))")
                        .font(.title)
                        .fontWeight(.light)
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color.red)
                        .padding(20)
                    
                    Text("Active Cases: \(getValue(data: self.data.data.active))")
                        .font(.headline)
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.red)
                        .padding(20)
                    
                    Text("Recovered: \(getValue(data: self.data.data.recovered))")
                        .font(.headline)
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.green)
                    
                }
                
               
                
            } else {
                
                GeometryReader { geo in
                    VStack {
                        Indicator()
                    }
                }
                
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
