//
//  eventClass.swift
//  MainTime
//
//  Created by Jonay Brito Hernández on 01/03/2020.
//  Copyright © 2020 Jonay Brito Hernández. All rights reserved.
//

import Foundation

class EventClass {
    static var event = EventClass()
    private init() {}
    
    var nameEvent : String!
    var textDescription : String!
    var timesFor : Int! //nº de veces que se ha entrado al evento
    var timeTotal : Int!
}
