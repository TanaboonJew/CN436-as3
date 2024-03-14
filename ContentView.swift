//

//  ContentView.swift

//  API

//

//  Created by นายธนบูรณ์ จิวริยเวชช์ on 3/13/24.

//


import SwiftUI


struct ResponseBody: Codable {

    let name: String

    let main: Main

    let weather: [Weather]

}


struct Main: Codable {

    let temp: Double

}


struct Weather: Codable {

    let description: String

    let icon: String

}


struct WeatherView: View {

    var weather: ResponseBody

    

    var body: some View {

        VStack {

            Text("City: \(weather.name)")

                .bold()

                .font(.title)

            Text("Temperature: \(String(format: "%.2f", weather.main.temp)) °C")

            Text("Weather: \(weather.weather[0].description)")

            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"))

                .frame(width: 100, height: 100)

        }

    }

}


struct ContentView: View {

    @State private var city = "Bangkok" // Set default city to Bangkok

    @State private var weather: ResponseBody?

    

    var body: some View {

        VStack {

            TextField("Enter city name", text: $city)

                .textFieldStyle(RoundedBorderTextFieldStyle())

                .padding()

            

            Button("Get Weather") {

                fetchWeather(for: city)

            }

            .padding()

            

            if let weather = weather {

                WeatherView(weather: weather)

            } else {

                ProgressView()

            }

        }

        .padding()

        .onAppear {

            fetchWeather(for: city) // Fetch weather data for Bangkok when the view appears

        }

    }

    

    func fetchWeather(for city: String) {

        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=8dc9feb7efff7c0510e54601ecdad111&units=metric") else {

            return

        }

        

        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            

            if let decodedResponse = try? JSONDecoder().decode(ResponseBody.self, from: data) {

                DispatchQueue.main.async {

                    self.weather = decodedResponse

                }

                return

            }

        }.resume()

    }

}




struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView()

    }

}
