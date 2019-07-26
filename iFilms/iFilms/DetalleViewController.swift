//
//  DetalleViewController.swift
//  iFilms
//
//  Created by Alejandro on 13/07/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class DetalleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    var imagenPeli=""
    var peticiones = [[String : String]]()
    var idRecibida = ""
    var image = UIImage()
    
    var anoPeli = ""
    var repartoPeli = ""
    var sinopsisPeli = ""
    var directorPeli = ""
    var valoracionPeli = ""
    
    var peliculas = [NSManagedObject]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tituloPeli: UILabel!
    @IBOutlet weak var fotoFondo: UIImageView!    
    @IBOutlet weak var fotoPoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "like1"), style: .plain, target: self, action: #selector(favoritos))
        print(imagenPeli)
        
        
        tableView.tableFooterView = UIView()
        
        descargarImagen()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let urlString = "https://api.themoviedb.org/3/movie/\(idRecibida)?api_key=e34d8725c6bc59b9d690f1c8df2c7ab7&language=es-ES"
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                let json = try? JSON(data: data)
                parsearJson(json: json!)
                print(json!)
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetalleTableViewCell
            cell.textoLabel.text = anoPeli
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetalleTableViewCell
            cell.textoLabel.text = valoracionPeli
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetalleTableViewCell
            cell.textoLabel.text = sinopsisPeli
            
            return cell
        default:
            fatalError("Algo ha salido muy mal")
        }
    }
    
    
    
    //IMAGEN POR DEFECTO
    func descargarImagen(){
        let url = "https://image.tmdb.org/t/p/w185/\(imagenPeli)"
        let fotoURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: fotoURL) { (data, response, error) in
            if let e = error {
                print("Error descargando la imagen: \(e)")
                

            } else {
                if let res = response as? HTTPURLResponse {
                    if let imageData = data {
                        self.image = UIImage(data: imageData)!
                        DispatchQueue.main.async {
                            self.fotoPoster.image = self.image
                            self.fotoFondo.image = self.image
                        }
                    } else {
                        print("No se pudo coger la imagen, es nil")
                    }
                } else {
                    print("No se pudo coger el response code")
                }
            }
        }
        if imagenPeli == ""{
            self.fotoPoster.image = UIImage(named: "interrogante")
            self.fotoFondo.image = UIImage(named: "interrogante")
        }else{
           downloadPicTask.resume()
        }
        
    }
    
    
    func guardarFavorito(nombrePelicula: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Pelicula", in: managedContext)
        let pelicula = NSManagedObject(entity: entity!, insertInto: managedContext)
        pelicula.setValue(nombrePelicula, forKey: "nombre")
        do {
            try managedContext.save()
            peliculas.append(pelicula)
            let alertaGuardada = UIAlertController(title: "Guardar", message: "Pelicula añadida a tu lista correctamente", preferredStyle: .alert)
            alertaGuardada.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertaGuardada, animated: true, completion: nil)
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }
    
    
    @objc func favoritos() {
        print("añadido a favoritos")
        guardarFavorito(nombrePelicula: tituloPeli.text!)
        
    }
    
    func parsearJson(json: JSON) {
        tituloPeli.text = json["title"].stringValue
        anoPeli = "LANZAMIENTO: " + json["release_date"].stringValue
        sinopsisPeli = "SINOPSIS: \n" + json["overview"].stringValue        
        valoracionPeli = "PUNTUACION (imDB): \(json["vote_average"].floatValue)"
        
    }
    
    
    
}
