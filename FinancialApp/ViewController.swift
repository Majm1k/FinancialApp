//
//  ViewController.swift
//  FinancialApp
//
//  Created by Дмитрий Рузайкин on 25.09.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var backKeyboard: UIButton!
    @IBOutlet weak var backCategory: UIButton!
    @IBOutlet weak var backLabel: UIButton!
    
    @IBOutlet weak var displayLabel: UILabel!
    var cleanTaping = false
    
    @IBOutlet var numberForKeyboard: [UIButton]!{ //Массив, куда добавили все аутлеты с цифрами, чтобы им всем сразу придать один вид
        didSet{
            for button in numberForKeyboard{
                button.layer.cornerRadius = 9
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Тени и скругления
        backCategory.layer.cornerRadius = 20
        backCategory.layer.shadowColor = UIColor.black.cgColor
        backCategory.layer.shadowOpacity = 0.2
        backCategory.layer.shadowOffset = .zero
        backCategory.layer.shadowRadius = 3
        
        backKeyboard.layer.cornerRadius = 20
        backKeyboard.layer.shadowColor = UIColor.black.cgColor
        backKeyboard.layer.shadowOpacity = 0.2
        backKeyboard.layer.shadowOffset = .zero
        backKeyboard.layer.shadowRadius = 3
        
        backLabel.layer.cornerRadius = 15
        
    }

    @IBAction func numberPressed(_ sender: UIButton) { //Привязали все кнопки на этот экшен
        let number = sender.currentTitle! //Вызвали у sender метод для считывания названия

        if cleanTaping == false{
            displayLabel.text = number //текта равен нажатой кнопке
            cleanTaping = true
        } else{ //и если переменная true, то...
            if displayLabel.text!.count < 15{ //Ограничение на ввод символов (15 цифр)
                displayLabel.text = displayLabel.text! + number //текст label равен тексту label + название кнопки
            }
        }
        
    }
    
    
    @IBAction func resetButton(_ sender: UIButton) { //Сброс всех цифр
        displayLabel.text = "0"
        cleanTaping = false //чтобы снова 0 не вставал в начало строки
    }
    
}

