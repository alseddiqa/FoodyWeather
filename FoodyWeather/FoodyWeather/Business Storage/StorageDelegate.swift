//
//  StorageDelegate.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/25/20.
//

import Foundation

protocol StorageDelegate {
    func updateBusiness(oldTask: SavedBusiness, newTask: SavedBusiness)
}
