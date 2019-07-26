//
//  MiListaTableViewController.swift
//  iFilms
//
//  Created by Alejandro on 14/07/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit
import CoreData

class MiListaTableViewController: UITableViewController {
    
    var peliculas = [NSManagedObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.view.setNeedsDisplay()
        navigationController?.navigationBar.isHidden = false
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Pelicula> = Pelicula.fetchRequest()
        do {
            let results = try managedContext.fetch(fetchRequest)
            peliculas = results as [NSManagedObject]
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mi Lista"

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let pelicula = peliculas[indexPath.row]
        cell!.textLabel!.text = pelicula.value(forKey: "nombre") as? String
        
        return cell!
    }
    
    func alertaEliminada(){
        let alertaEliminada = UIAlertController(title: "Eliminar", message: "Pelicula eliminada de tu lista correctamente", preferredStyle: .alert)
        alertaEliminada.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: { (cerrar) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertaEliminada, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminarPelicula = UIContextualAction(style: .normal, title: "Eliminar Pelicula") { (action, sourceView, completionHandler) in
            
            
            let cell = tableView.cellForRow(at: indexPath)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Pelicula")
            requestDel.returnsObjectsAsFaults = false
            
            do {
                let arrUsrObj = try context.fetch(requestDel)
                context.delete(arrUsrObj[indexPath.row] as! NSManagedObject)
                //cell?.textLabel?.text = "Película eliminada"
                
                print("PELICULA ELIMINADA")
                self.alertaEliminada()
            } catch {
                print("Failed")
            }
            do {
                try context.save()
                
            } catch {
                print("Failed saving")
            }
            
            completionHandler(true)
        }
        
        
        eliminarPelicula.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [eliminarPelicula])
        
        return swipeConfiguration
    }
    

}
