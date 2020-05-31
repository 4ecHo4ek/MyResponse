//
//  ViewController.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 26.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - определяем
    @IBOutlet weak var tableView: UITableView!
    private var objects: Results<Response>!
    private var colors: Results<Colors>!
    private var filtredResponse: Results<Response>!
    private var searchBarIsEnpty: Bool {
        guard let text = seachController.searchBar.text else { return false }
        return text.isEmpty
    }
    private let seachController = UISearchController(searchResultsController: nil)
    private var isFilteing: Bool {
        return seachController.isActive && !searchBarIsEnpty
    }
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(Response.self)
        colors = realm.objects(Colors.self)
        startPresentation()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.style = .plain
        self.navigationItem.leftBarButtonItem?.title = "Передвинуть"
        
        seachController.searchResultsUpdater = self
        seachController.obscuresBackgroundDuringPresentation = false
        seachController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = seachController
        definesPresentationContext = true
    }
    
    //MARK: - начальное заполнение цветов
    private func beginingWork() {
        var (r,g,b): (Double, Double, Double) = (0,0,0)
        for number in 0...4 {
            switch number {
            case 0:
                (r,g,b) = (1,0,0)
            case 1:
                (r,g,b) = (1,0.5,0)
            case 2:
                (r,g,b) = (1,1,0.5)
            case 3:
                (r,g,b) = (0.5,1,0.5)
            case 4:
                (r,g,b) = (0,1,0)
            default:
                break
            }
            let setColor = Colors(red: r, green: g, blue: b, alpha: 0.5)
            StorageManager.saveColor(withNumbers: setColor)
        }
    }
    
    //приветствие
    //создаем бд
    func startPresentation() {
        let userDefaults = UserDefaults.standard
        let presentationWasViewed = userDefaults.bool(forKey: "presentationWasViewed")
        if !presentationWasViewed {
            if let pageViewController = storyboard?.instantiateViewController(
                withIdentifier: "PageViewController") as? PageViewController {
                present(pageViewController, animated: true, completion: nil)
            }
            beginingWork()
        }
    }
    
    //MARK: - table view cell
    //отображаем информацию о ячейки
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilteing {
            return filtredResponse.count
        }
        return objects.isEmpty ? 0 : objects.count
    }
    
    //настройка вида ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! CustomTableViewCell
        var object = Response()
        
        if isFilteing {
            object = filtredResponse[indexPath.row]
        } else {
            object = objects[indexPath.row]
        }
        
        cell.nameLabel?.text = object.name
        cell.descriptionLabel.text = object.describe
        cell.markLabel.text = String(object.mark)
        cell.imageOfObject.image = UIImage(data: object.imageData!)
        cell.imageOfObject.layer.cornerRadius = cell.imageOfObject.frame.size.height / 2
        cell.imageOfObject.clipsToBounds = true
        
        if object.haveColor {
            let id = setColor(mark: object.mark)
            let backColor = UIColor(red: CGFloat(colors[id].red),
                                    green: CGFloat(colors[id].green),
                                    blue: CGFloat(colors[id].blue),
                                    alpha: CGFloat(colors[id].alpha))
            cell.backgroundColor = backColor
        } else {
            cell.backgroundColor = .none
        }
        
        return cell
    }
    
    //MARK: - table view delegate
    //прописываем действие при удалении
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let object = objects[indexPath.row]
            StorageManager.deleteObject(myResponse: object)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //метод по снятию фокуса при отжимания пальца от ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //хз что, может и не работает (чтоб сразу срабатывал свайп слева)
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        var index = indexPath
        
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        index = tableView.indexPathForSelectedRow!
        
        return index
    }
    
    //MARK: - table view segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let object: Response
        if isFilteing {
            object = filtredResponse[indexPath.row]
        } else {
            object = objects[indexPath.row]
        }
        let newObjectVC = segue.destination as! TableViewController
        newObjectVC.responce = object
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        if let newObjectVC = segue.source as? TableViewController {
            newObjectVC.saveObject()
        } else if segue.source is ColorsSelection {
            colors = realm.objects(Colors.self)
        }
        tableView.reloadData()
    }
    
    
    //MARK: - new elements
    
    private func setColor(mark: Int ) -> Int {
        var id = 0
        
        switch mark {
        case 0...2:
            id = 0
        case 3...4:
            id = 1
        case 5...6:
            id = 2
        case 7...8:
            id = 3
        case 9...10:
            id = 4
        default:
            id = 0
        }
        return id
    }
    
    //метод по добавлению действия при свайпе влево
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let color = makeColor(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [color])
    }
    
    //при перемещении ячейки неокрашенной на место окрашенной, она окрашивается
    func makeColor(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "color") { (action, view, complite) in
            
            try! realm.write{
                self.objects[indexPath.row].haveColor = !self.objects[indexPath.row].haveColor
            }
            self.makeBackground(at: indexPath)
        }
        action.backgroundColor = .blue
        self.tableView.reloadData()
        action.image = UIImage(systemName: "paintbrush")
        return action
    }
    
    //метод по изменению цвета фона ячейки
    private func makeBackground(at index: IndexPath) {
        if self.objects[index.row].haveColor {
            let id = self.setColor(mark: self.objects[index.row].mark)
            let backColor = UIColor(red: CGFloat(self.colors[id].red),
                                    green: CGFloat(self.colors[id].green),
                                    blue: CGFloat(self.colors[id].blue),
                                    alpha: CGFloat(self.colors[id].alpha))
            self.tableView.cellForRow(at: index)!.backgroundColor = backColor
        } else {
            self.tableView.cellForRow(at: index)?.backgroundColor = .none
        }
        
    }
    
    //MARK: - делаем перемещение ячеек (не работает)
    //разрешаем двигать
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //само движение ячейки
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
     
        
        var movingArray = [Response]()
        for element in objects {
            movingArray.append(element)
        }
        let movingElement = movingArray.remove(at: sourceIndexPath.row)
        movingArray.insert(movingElement, at: destinationIndexPath.row)

        //изменение цвета при передвижении ячеик
        self.tableView.cellForRow(at: sourceIndexPath)?.backgroundColor = .none
        self.tableView.cellForRow(at: destinationIndexPath)?.backgroundColor = .none
        
        for elenemt in objects {
        StorageManager.deleteObject(myResponse: elenemt)
        }
        for element in movingArray {
            StorageManager.saveObject(myResponse: element)
        }
        
        objects = realm.objects(Response.self)
        
        if sourceIndexPath.row > destinationIndexPath.row {
            for element in 0...sourceIndexPath.row {
                redrawCells(inElement: element)
            }
        } else {
            for element in 0...destinationIndexPath.row {
                redrawCells(inElement: element)
            }
        }

        tableView.reloadData()
    }
    
    private func redrawCells(inElement element: Int) {
        
        if self.objects[element].haveColor {
            let id = self.setColor(mark: self.objects[element].mark)
            self.tableView.cellForRow(at: IndexPath(row: element, section: 0))?.backgroundColor =
                UIColor(red: CGFloat(self.colors[id].red),
                        green: CGFloat(self.colors[id].green),
                        blue: CGFloat(self.colors[id].blue),
                        alpha: CGFloat(self.colors[id].alpha))
        } else {
            self.tableView.cellForRow(at: IndexPath(row: element, section: 0))?.backgroundColor = .none
        }
    }
    

    
}

//MARK: - создаем расширения для работы с UISearchController

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filerContentForSearchText(seachController.searchBar.text!)
    }
    
    private func filerContentForSearchText(_ searchText: String) {
        filtredResponse =
            objects.filter("name CONTAINS[c] %@ OR describe CONTAINS[c] %@", searchText,
                           searchText)
        tableView.reloadData()
    }
    
}

//MARK: - иконка
//MARK: - добавить теги
//MARK: - настроить смарт добавление тега
//MARK: - сделать так, чтоб при нажатии на поле поиска выплывало окно с выбором тега

