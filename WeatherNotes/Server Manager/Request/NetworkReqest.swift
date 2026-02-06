//
//  NetworkReqest.swift
//  WeatherNotes
//
//  Created by Maks on 06.02.26.
//

protocol NetworkReqest {
    associatedtype Response: Decodable
    associatedtype Request: Encodable
    
    var method: String { get }
    var parameters: Request { get }
}
