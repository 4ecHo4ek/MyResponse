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
    
    @IBOutlet weak var tableView: UITableView!
    var objects: Results<Response>!
    var colors: Results<Colors>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = realm.objects(Response.self)
        colors = realm.objects(Colors.self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.isEmpty ? 0 : objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! CustomTableViewCell
        
        let object = objects[indexPath.row]
        
        cell.nameLabel?.text = object.name // тут ? не было
        cell.descriptionLabel.text = object.describe
        cell.markLabel.text = String(object.mark)
        cell.imageOfObject.image = UIImage(data: object.imageData!)
        
        cell.imageOfObject.layer.cornerRadius = cell.imageOfObject.frame.size.height / 2
        cell.imageOfObject.clipsToBounds = true
        
        if object.haveColor {
           let id = setColor(mark: object.mark)
            let backColor = UIColor(red: CGFloat(colors[id].red), green: CGFloat(colors[id].green), blue: CGFloat(colors[id].blue), alpha: CGFloat(colors[id].alpha))
            cell.backgroundColor = backColor
        } else {
            cell.backgroundColor = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let object = objects[indexPath.row]
            StorageManager.deleteObject(myResponse: object)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let object = objects[indexPath.row]
        let newObjectVC = segue.destination as! TableViewController
        newObjectVC.responce = object
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newObjectVC = segue.source as? TableViewController else { return }
        newObjectVC.saveObject()
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
    
}

