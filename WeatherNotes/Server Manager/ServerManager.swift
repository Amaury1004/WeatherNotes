//
//  Server Manager.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

import Foundation

let apiKey = "0e1e46d485c5cdce03a05014e800310a"

enum BaseURLType: String {
    case currentWeather = "https://api.openweathermap.org/data/2.5/"
    
}

final class ServerManager {
    static let shared = ServerManager()
    
    
    func request<R: NetworkReqest> (
        _ request: R,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
        completion: @escaping (Result<R.Response, Error>) -> Void
    ) {
        guard var urlComponents = URLComponents(string: "\(BaseURLType.currentWeather.rawValue)\(request.method)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        var queryItems = [URLQueryItem(name: "appid", value: apiKey)]
        if let dict = request.parameters as? [String: Any] {
                    for (key, value) in dict {
                        queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
                    }
                } else if let encodable = request.parameters as? Encodable {
                    if let data = try? JSONEncoder().encode(AnyEncodable(encodable)),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (key, value) in json {
                            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
                        }
                    }
                }
        print(request.parameters ?? "xyz")
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("OpenWeatherClient", forHTTPHeaderField: "User-Agent")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Full URL: \(urlComponents.url?.absoluteString ?? "nil")")

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decoded = try decoder.decode(R.Response.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
}
        
    


struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self.encodeClosure = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
