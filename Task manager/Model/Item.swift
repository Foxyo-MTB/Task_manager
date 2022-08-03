//
//  Item.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 01.08.2022.
//
// Creating new class for Task Manager to get correct checkmark indication because reusable cell dissapears when gets off the screen

import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
