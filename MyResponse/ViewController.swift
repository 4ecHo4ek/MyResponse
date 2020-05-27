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
    
    
}

