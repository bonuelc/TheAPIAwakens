//
//  SWAPIClient.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 9/30/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import Foundation

enum SWAPI: Endpoint {
    
    case Characters(apiPageIndex: Int)
    case Vehicles(apiPageIndex: Int)
    case Starships(apiPageIndex: Int)
    
    case Character(apiIndex: Int)
    case Vehicle(apiIndex: Int)
    case Starship(apiIndex: Int)
    case Planet(apiIndex: Int)
    
    var baseURL: String {
        return "https://swapi.co"
    }
    
    var path: String {
        switch self {
        case .Characters: return "/api/people/"
        case .Vehicles: return "/api/vehicles/"
        case .Starships: return "/api/starships/"
        
        case .Character(let apiIndex): return "/api/people/\(apiIndex)/"
        case .Vehicle(let apiIndex): return "/api/vehicles/\(apiIndex)/"
        case .Starship(let apiIndex): return "/api/starships/\(apiIndex)/"
        case .Planet(let apiIndex): return "/api/planets/\(apiIndex)/"
        }
    }
    
    var parameters: [String : AnyObject] {
        switch self {
        case .Characters(let apiPageIndex): return apiPageIndex == 1 ?  [:] : ["page" : "\(apiPageIndex)"]
        case .Vehicles(let apiPageIndex): return apiPageIndex == 1 ?  [:] : ["page" : "\(apiPageIndex)"]
        case .Starships(let apiPageIndex): return apiPageIndex == 1 ?  [:] : ["page" : "\(apiPageIndex)"]
        default: return [:]
        }
    }
}

final class SWAPIClient: APIClient {
    
    let resultsKey = "results"
    
    let configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    init(configuration: NSURLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .defaultSessionConfiguration())
    }
    
    func fetchCharacters(apiPageIndex: Int, completion: APIResult<[Character]> -> Void) {
        
        let endpoint = SWAPI.Characters(apiPageIndex: apiPageIndex)
        
        fetch(endpoint, parse: { json -> [Character]? in
            
            guard let characters = json[self.resultsKey] as? [[String: AnyObject]] else { return nil }
            
            return characters.flatMap { return Character(JSON: $0) }
            
            }, completion: completion)
    }

    
    func fetchVehicles(apiPageIndex: Int, completion: APIResult<[Vehicle]> -> Void) {
        
        let endpoint = SWAPI.Vehicles(apiPageIndex: apiPageIndex)
        
        fetch(endpoint, parse: { json -> [Vehicle]? in
        
            guard let vehicles = json[self.resultsKey] as? [[String: AnyObject]] else { return nil }
            
            return vehicles.flatMap { return Vehicle(JSON: $0) }
            
            }, completion: completion)
    }
    
    
    func fetchStarships(apiPageIndex: Int, completion: APIResult<[Starship]> -> Void) {
        
        let endpoint = SWAPI.Starships(apiPageIndex: apiPageIndex)
        
        fetch(endpoint, parse: { json -> [Starship]? in
            
            guard let starships = json[self.resultsKey] as? [[String: AnyObject]] else { return nil }
            
            return starships.flatMap { return Starship(JSON: $0) }
            
            }, completion: completion)
    }
    
    func fetchCharacter(apiIndex: Int, completion: APIResult<Character> -> Void) {
        
        let endpoint = SWAPI.Character(apiIndex: apiIndex)
        
        fetch(endpoint, parse: { Character(JSON: $0) }, completion: completion)
    }
    
    func fetchVehicle(apiIndex: Int, completion: APIResult<Vehicle> -> Void) {
        
        let endpoint = SWAPI.Vehicle(apiIndex: apiIndex)
        
        fetch(endpoint, parse: { Vehicle(JSON: $0) }, completion: completion)
    }
    
    func fetchStarship(apiIndex: Int, completion: APIResult<Starship> -> Void) {
        
        let endpoint = SWAPI.Starship(apiIndex: apiIndex)
        
        fetch(endpoint, parse: { Starship(JSON: $0) }, completion: completion)
    }
    
    func fetchPlanet(apiIndex: Int, completion: APIResult<Planet> -> Void) {
        
        let endpoint = SWAPI.Planet(apiIndex: apiIndex)
        
        fetch(endpoint, parse: { Planet(JSON: $0) }, completion: completion)
    }
}
