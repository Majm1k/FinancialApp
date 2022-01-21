//
//  TableViewController.swift
//  FinancialApp
//
//  Created by Дмитрий Рузайкин on 28.09.2021.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    let VC = ViewController()
    @IBOutlet var tableView2: UITableView!
    let realm = try! Realm() //Работа реалм
    var spendingDBArray: Results<SpendingDB>! //Массив для хранения извлеченных данных из realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65
        spendingDBArray = realm.objects(SpendingDB.self)
    }
    
    //Обновление таблицы
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

extension TableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingDBArray.count //Количество данных в БД
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell //Приведение типов, чтобы ячейка была кастомной, как мы ее и записали
        
        let spending = spendingDBArray.sorted(byKeyPath: "date", ascending: false)[indexPath.row] //Для того, чтобы индексы везде совпадали (sorted <- для тогор чтобы данные добавлялись не в низ, а на верх. byKeyPath <- сортируем по опеделенному значению, в нашем случае по дате, а в ascending указываем по возратанию или нет, у нас по убыванию, поэтому выключаем)
        
        cell.recordCategory.text = spending.category //Обращение к кастомным аутлетам из CustomTableViewCell (отображение категории)
        cell.recordMoney.text = "\(spending.cost)" //Отображение суммы
        
        print("work")
        
        switch spending.category { //Отображение в таблице картинок
        case "Дом": cell.recordImage.image = #imageLiteral(resourceName: "Frame 4")
        case "Одежда": cell.recordImage.image = #imageLiteral(resourceName: "Frame 8")
        case "Связь": cell.recordImage.image = #imageLiteral(resourceName: "Frame 7")
        case "Авто": cell.recordImage.image = #imageLiteral(resourceName: "Frame 3")
        case "Аптека": cell.recordImage.image = #imageLiteral(resourceName: "Frame 2")
        case "Продукты": cell.recordImage.image = #imageLiteral(resourceName: "Frame 1")
        case "Кафе": cell.recordImage.image = #imageLiteral(resourceName: "Frame 6")
        case "Прочее": cell.recordImage.image = #imageLiteral(resourceName: "Frame 5")
        default:
            cell.recordImage.image = #imageLiteral(resourceName: "Rectangle 1")
        }
        return cell
    }
    
    //Удаление записи
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = spendingDBArray.sorted(byKeyPath: "date", ascending: false)[indexPath.row] //Про sorted писал выше
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, completionHandler) in
            
            try! self.realm.write {
                self.realm.delete(editingRow)
                tableView.reloadData()
                
                ViewController().leftLabels() //функция во ViewController()
                ViewController().spendingAllTime() //функция во ViewController()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
