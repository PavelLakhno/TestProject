//
//  DataStore.swift
//  TestProject
//
//  Created by Павел Лахно on 29.10.2022.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    
    let icons = [
        "Heart",
        "Blood",
        "Lungs",
        "Virus"
    ]
    
    let titles = [
        "20 минут",
        "12 часов",
        "2 недели",
        "1 месяц"
    ]
    
    let descriptons = [
        "Уменьшается частота сердечных сокращений и давление",
        "Концентрация угарного газа в крови снижается до нормальных значений",
        "Улучшается кровообращение и дыхание легких",
        "Уменьшается одышка и кашель"
    ]
    
    private init() {}
}
