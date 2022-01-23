//
//  ModelRealm.swift
//  FinancialApp
//
//  Created by Дмитрий Рузайкин on 03.10.2021.
//

import RealmSwift
import Foundation

class SpendingDB: Object{ //Модель для базы данных (Сохранение в БД всех атрибутов)
    
    @objc dynamic var category = ""
    @objc dynamic var cost = 1
    @objc dynamic var date = NSDate()
    
}

class Limit: Object{ //Модель для базы данных (Сохранение в БД доступного лимита и до какой даты)
    @objc dynamic var limitSum = ""
    @objc dynamic var limitDate = NSDate()
    @objc dynamic var limitLastDate = NSDate()
    
}
