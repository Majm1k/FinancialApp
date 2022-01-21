//
//  ViewController.swift
//  FinancialApp
//
//  Created by Дмитрий Рузайкин on 25.09.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    //MARK: - PROPERTIES
    
    let realm = try! Realm() //Работа реалм
    var spendingDBArray: Results<SpendingDB>! //Массив для хранения извлеченных данных из realm
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var backKeyboard: UIButton!
    @IBOutlet weak var backLabel: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var availableForSpending: UILabel!
    @IBOutlet weak var ForThePeriod: UILabel!
    @IBOutlet weak var allSpending: UILabel!
    
    @IBOutlet var backCategory: [UIButton]!{
        didSet{
            for button in backCategory{
                button.layer.cornerRadius = 20
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOpacity = 0.2
                button.layer.shadowOffset = .zero
                button.layer.shadowRadius = 3
            }
        }
    }
    
    @IBOutlet var numberForKeyboard: [UIButton]!{ //Массив, куда добавили все аутлеты с цифрами, чтобы им всем сразу придать один вид
        didSet{
            for button in numberForKeyboard{
                button.layer.cornerRadius = 5
            }
        }
    }
    
    var cleanTaping = false
    var categoryName: String = ""
    var displayValue: Int = 1
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!) //Узнать где файл реалм
        //Тени и скругления
        backKeyboard.layer.cornerRadius = 20
        backKeyboard.layer.shadowColor = UIColor.black.cgColor
        backKeyboard.layer.shadowOpacity = 0.2
        backKeyboard.layer.shadowOffset = .zero
        backKeyboard.layer.shadowRadius = 3
        backLabel.layer.cornerRadius = 15
        
        spendingDBArray = realm.objects(SpendingDB.self)
        
        leftLabels() //функция ниже
        spendingAllTime() //функция ниже
    }
    
    //MARK: - NUMBER PRESSED
    @IBAction func numberPressed(_ sender: UIButton) { //Привязали все кнопки на этот экшен
        let number = sender.currentTitle! //Вызвали у sender метод для считывания названия
        
        if number == "0" && displayLabel.text == "0"{
            cleanTaping = false
        } else{
            if cleanTaping == false{
                displayLabel.text = number //текта равен нажатой кнопке
                cleanTaping = true
            } else{ //и если переменная true, то...
                if displayLabel.text!.count < 15{ //Ограничение на ввод символов (15 цифр)
                    displayLabel.text = displayLabel.text! + number //текст label равен тексту label + название кнопки
                }
            }
        }
        sender.pulsate() //Анимация нажатия на кнопку из ExtensionPressedButton()
    }
    
    //MARK: - RESET BUTTON
    @IBAction func resetButton(_ sender: UIButton) { //Сброс всех цифр
        displayLabel.text = "0"
        cleanTaping = false //чтобы снова 0 не вставал в начало строки
        
        sender.pulsate() //Анимация нажатия на кнопку из ExtensionPressedButton()
    }
    
    //MARK: - CATEGORY PRESSED
    @IBAction func categoryPressed(_ sender: UIButton) { //Нажатие на категорию
        categoryName = sender.currentTitle!
        displayValue = Int(displayLabel.text!)! //Приведение к значению Int
        
        displayLabel.text = "0"
        cleanTaping = false //чтобы снова 0 не вставал в начало строки
        
        let value = SpendingDB(value: ["\(categoryName)", displayValue]) //Добавление в БД
        try! realm.write {
            realm.add(value)
        }
        leftLabels() //функция ниже
        spendingAllTime() //функция ниже
        sender.pulsate() //Анимация нажатия на кнопку из ExtensionPressedButton()
    }
    
    //MARK: - (ALERT) LIMIT PRESSED
    @IBAction func limitPressed(_ sender: UIBarButtonItem) {//Алерт, который устанавливает лимит
        let alertController = UIAlertController(title: "Установить доступный лимит", message: "Введите суммы и количетво дней", preferredStyle: .alert)
        //Отслеживание нажатия
        let alertInstall = UIAlertAction(title: "Установить", style: .default) { action in
            let textFieldAlertSum = alertController.textFields?[0].text //Строка ввода количество лимита
            
            let textFieldAlertDay = alertController.textFields?[1].text //Строка ввода количества дней
            
            guard textFieldAlertDay != "" && textFieldAlertSum != "" else {return} //Если дата не равна пустой строке и лимит не равен пустой строке, то идем дальше по коду, иначе выходим из метода и не записываем дату с лимитом
            
            self.limitLabel.text = textFieldAlertSum //Записываем в Label значения, которые ввели в TextField в Alert
            
            if let day = textFieldAlertDay{ //Проверка, тип есть ли вообще какие-то данные в textField
                let dateNow = Date() //Переменная dateNow равна Date(), которая всегда обозначает сегодняшнюю
                
                //К сегодняшней дате добавляем 1 день, который умножаем на кол-во дней, который вел пользователь
                let lastDay = dateNow.addingTimeInterval(60*60*24*Double(day)!) //Переменная lastDate равна сегодняшней дате + добавляем интервал (60*60*24 - это кол-во секунд в 1 дне), дальше берем кол-во дней из textField, куда в Alert записываем дату (day) и также умножаем P.S. Double для правильного формата
                
                let limitAll = self.realm.objects(Limit.self) //Создаем переменную, которая будет ранить все значения базы данных Limit
                
                if limitAll.isEmpty == true{ //Если данных нет, то записывает все в БД
                    let value = Limit(value: [self.limitLabel.text!, dateNow, lastDay]) //Добавление в БД
                    try! self.realm.write {
                        self.realm.add(value)
                    }
                } else{ //Иначе перезаписываем данные на новые, чтобы не было скопления данных, которые не нужны
                    try! self.realm.write{
                        limitAll[0].limitSum = self.limitLabel.text!
                        limitAll[0].limitDate = dateNow as NSDate //Приводим к формату NSDate
                        limitAll[0].limitLastDate = lastDay as NSDate //Приводим к формату NSDate
                    }
                }
            }
            
            self.leftLabels() //Чтобы при установке лимита данные все менялись и меняли свое значение
        }
        
        alertController.addTextField { money in //Добавление самой строки ввода количество лимита
            money.placeholder = "Сумма" //Надпись поверх textField
            money.keyboardType = .asciiCapableNumberPad //Установка клавиатуры с цифрами
        }
        
        alertController.addTextField { day in //Добавление самой строки ввода количества дней
            day.placeholder = "Количество дней" //Надпись поверх textField
            day.keyboardType = .asciiCapableNumberPad //Установка клавиатуры с цифрами
        }
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in} //Кнопка отмены
        
        alertController.addAction(alertInstall)
        alertController.addAction(alertCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func leftLabels(){ //Работа со всеми label
        let limit = self.realm.objects(Limit.self) //self указываем, тк рабоатем внутри метода
        
        guard limit.isEmpty == false else {return} //Если лимит не пустой, то идем дальше по коду, иначе если лимит пустой выходим из метода и ничего не делаем (чтобы приложение не ломалось при повторной загрузке)
        
        limitLabel.text = limit[0].limitSum //Указываем, что label с лимитом будет равен limit из БД (Вытаскиеваем данные)
        
        let calendar = Calendar.current //calendar равен календарю в зависимости от часового пояса (current - определяет часовой пояс)
        
        //Указываем формат даты
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        //Указываем, что новые переменные равны данным из ModelRealm() и приводим к формату Date
        let firstDay = limit[0].limitDate as Date
        let lastDay = limit[0].limitLastDate as Date
        
        //Устанавливаем формат указанной даты
        let firstComponent = calendar.dateComponents([.year, .month, .day], from: firstDay) //для первого дня (выше писали)
        let lastComponent = calendar.dateComponents([.year, .month, .day], from: lastDay) //для последнего дня (выше писали)
        
        //Финально форматируем дату
        let startDate = formatter.date(from: "\(firstComponent.year!)/\(firstComponent.month!)/\(firstComponent.day!) 00:00") //("2020/12/04 00:00") равно "\(firstComponent.year)/\(firstComponent.month)/\(firstComponent.day) 00:00") <- только тут указываем введеные данные
        let endDate = formatter.date(from: "\(lastComponent.year!)/\(lastComponent.month!)/\(lastComponent.day!) 23:59") //По аналогии с кодом выше (День заканчивается в 23:59)
        
        //Выборка из БД
        //"self.date >= %@ && self.date <= %@" -> Дату должна быть больше либо равна startDate и дата должна быть меньше или равна endDate
        //Дальше складываем все значения cost из ModelRealm()
        let filterLimit: Int = realm.objects(SpendingDB.self).filter("self.date >= %@ && self.date <= %@", startDate ?? "", endDate ?? "").sum(ofProperty: "cost") //В filter указываем условия по которым будем выбирать
        
        ForThePeriod.text = "\(filterLimit)" //Указываем, что label равен сумме всех трат за время, которое мы указали
        
        let a = Int(limitLabel.text!)!
        let b = Int(ForThePeriod.text!)!
        let c = a - b //Из нашего лимита вычитаем траты
        
        availableForSpending.text = "\(c)" //label "Доступно" равен с (с - сколько осталось для трат)
    }
    
    func spendingAllTime(){ //Чтобы все траты отображались вседа, не зависимо от других факторов
        let allSpend: Int = self.realm.objects(SpendingDB.self).sum(ofProperty: "cost") //Суммируем все траты и записываем в константу
        allSpending.text = "\(allSpend)" //label всех трат равен сумме всех трат
    }
}

