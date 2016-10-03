//
//  Entity.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/3/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

protocol Entity {
    var name: String { get }
    var size: Double? { get }
}

enum EntityType: String {
    case Characters, Vehicles, Starships
}