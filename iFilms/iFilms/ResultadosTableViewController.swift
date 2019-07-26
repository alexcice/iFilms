//
//  ResultadosTableViewController.swift
//  iFilms
//
//  Created by Alejandro on 13/07/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultadosTableViewController: UITableViewController {
    var peticiones = [[String : String]]()
    var imagenPeli = ""
    var peliRecibida = ""
    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=e34d8725c6bc59b9d690f1c8df2c7ab7&language=es-ES&query=\(peliRecibida)&page=1&include_adult=false"
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                let json = try? JSON(data: data)
                parsearJson(json: json!)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        if peliRecibida==""{
            alertaError()
        }
    }
    
    func alertaError(){
        let alerta = UIAlertController(title: "Atención", message: "No soy capaz de encontrar la pelicula que buscas. Por favor, intentalo de nuevo", preferredStyle: .actionSheet)
        //Accion cancelar
        let cancelar = UIAlertAction(title: "Entendido!👍🏼", style: .default) { (volver) in
            self.navigationController?.popViewController(animated: true)
        }
        alerta.addAction(cancelar)
        
        if let popoverController = alerta.popoverPresentationController{
            if let cell = tableView{
                popoverController.sourceView = cell
                popoverController.sourceRect = CGRect(x: tableView.frame.width / 2, y: tableView.frame.height / 2, width: 500, height: 500)
            }
        }
        present(alerta, animated: true, completion: nil)
    }
 
    func volver(){
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peticiones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = peticiones[indexPath.row]["claveTitulo"]
        cell.detailTextLabel?.text = peticiones[indexPath.row]["claveAño"]
        
        return cell
    }
    
    func parsearJson(json: JSON) {
        let resultados = json["results"].arrayValue
        
        for resultado in resultados{
            let tituloPeli = resultado["title"].stringValue
            let anoPeli = resultado["release_date"].stringValue
            imagenPeli = resultado["poster_path"].stringValue
            id = resultado["id"].intValue
            let peticionDicc = ["claveTitulo": tituloPeli, "claveAño": anoPeli, "claveImagen": imagenPeli, "claveId": String(id)]
            peticiones.append(peticionDicc)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalle"{
            let controladorDestino = segue.destination as! DetalleViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                controladorDestino.imagenPeli = peticiones[indexPath.row]["claveImagen"]!
                controladorDestino.idRecibida = peticiones[indexPath.row]["claveId"]!
            }
        }
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilmDetail"{
            let controladorDestino = segue.destination as! DetalleViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                controladorDestino.imagenPeli = peticiones[indexPath.row]["claveImagen"]!
                controladorDestino.idRecibida = peticiones[indexPath.row]["claveId"]!
            }
        }
    }
    */
    
}
