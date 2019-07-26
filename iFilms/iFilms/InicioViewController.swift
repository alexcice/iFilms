//
//  ViewController.swift
//  iFilms
//
//  Created by Alejandro on 11/07/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController {

    @IBOutlet weak var buscador: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func busqueda(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func miLista(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarResultados"{
            let controladorDestino = segue.destination as! ResultadosTableViewController
            let busqueda = buscador.text?.replacingOccurrences(of: " ", with: "%20")
            buscador.text?.replacingOccurrences(of: "'", with: "%27")
            controladorDestino.peliRecibida = busqueda!
            
        }
    }

}

