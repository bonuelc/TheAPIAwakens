//
//  SWAPIClient.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 9/30/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import Foundation

enum SWAPI: Endpoint {
    
    case Characters
    case Vehicles
    case Starships
    case Planet(apiIndex: Int)
    
    var baseURL: String {
        return "https://swapi.co"
    }
    
    var path: String {
        switch self {
        case .Characters: return "/api/people/"
        case .Vehicles: return "/api/vehicles/"
        case .Starships: return "/api/starships/"
        case .Planet(let apiIndex): return "/api/planets/\(apiIndex)/"
        }
    }
    
    var parameters: [String : AnyObject] {
        return [:]
    }
}

final class SWAPIClient: APIClient {
    
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
}