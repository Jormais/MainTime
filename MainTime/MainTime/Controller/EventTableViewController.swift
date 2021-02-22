//
//  EventTableViewController.swift
//  MainTime
//
//  Created by Jonay Brito Hernández on 26/02/2020.
//  Copyright © 2020 Jonay Brito Hernández. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class EventTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet var eventTable : UITableView!
    var events : [String] = ["1","12","123","qwerty","3"]
    var filteredEvents : [String] = [] //array de filtrado para el buscador
    var event : [Event] = []
    var isSearchBarEmpty: Bool { //se comprueba si la barra de busqueda esta vacia
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool { //se comprueba si se ha filtrado
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBAction func createCell() {
//        aqui deberemos implementar la instancia del objeto a llamar en este caso sera la celda
//        aqui no modificaremos los parametros simplemente crearemos aqui segun lo que introduxca el usuario
        let alertController = UIAlertController(title: "Add New Cell", message: "", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                
                self.save(textField: firstTextField.text!)
//                self.events.append(firstTextField.text!)
                self.fetch()
                self.eventTable.reloadData()
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in
                
            })
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Name"
            }

            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
    }
    
    let searchController = UISearchController(searchResultsController: nil) //controlador para barra de busqueda
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { //comprobamos si se ha filtrado para coger el array correcto
            return filteredEvents.count
        }
        return event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        debajo definimos nuestra celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellEvent
//        debajo controlamos que celda se mostrara y que texto tendra
        if isFiltering{ //antes comprobando si se ha filtrado para escoger el array correcto
            cell.textLabel?.text = filteredEvents[indexPath.row]
        } else {
            cell.textLabel?.text = event[indexPath.row].value(forKey: "name") as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [ makeDeleteContextualAction(forRowAt: indexPath)])
        //makeArchiveContextualAction(forRowAt: indexPath)
        //aquihacemos el return sin la palabla reservada siguiendo el patron de swift 5 probando
    }
    
//    func makeArchiveContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .normal, title: "New", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
//            self.events.append("Nueva Celda")
//            self.eventTable.insertRows(at: [indexPath], with: .automatic)
//       })
//        action.backgroundColor = .green
//       return action
//    }
    
    func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
       UIContextualAction(style: .destructive,
           title: "Delete") { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
           //           borrar delda
           self.events.remove(at: indexPath.row)
           if self.events.count > 0 {
               self.eventTable.deleteRows(at: [indexPath], with: .automatic)
           }else {
               self.eventTable.reloadRows(at: [indexPath], with: .automatic)
           }
           completionHandler(true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
           let searchBar = searchController.searchBar
           filterForSearchText(searchBar.text!)
       }
    
    func filterForSearchText(_ searchText: String) { //creamos el filtro que tomara la barra
      filteredEvents = events.filter { (event) -> Bool in
        return event.lowercased().contains(searchText.lowercased()) //cogeremos tanto mayus como minus
      }
      
      eventTable.reloadData() //recargamos la tabla para que se vean los cambios
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "timeView", //le damos el segue al que va destinado
            let indexPath = eventTable.indexPathForSelectedRow, //cogemos el indexPath
            let detailViewController = segue.destination as? TimeViewController //guardamos la direccion a la siguiente vista
              else {
                return
            }
        var event : String = "" //creamos el evento que pasaremos a la pantalla de detalle
        
        event = isFiltering == true ? filteredEvents[indexPath.row] : events[indexPath.row] // condicionamos si esta filtrado
    
        detailViewController.titleL = event //le pasamos al controlador el texto declarandoselo a una variable del mismo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTable.delegate = self
        self.eventTable.dataSource = self
        // 1 Le indicamos que va informarse sobre si mismo de los cambios(EventTableViewController)
        searchController.searchResultsUpdater = self
        // 2 Le decimos que no oscurezca la pantalla
        searchController.obscuresBackgroundDuringPresentation = false
        // 3 ponemos un texto visible antes de escribir
        searchController.searchBar.placeholder = "Search Events"
        // 4 le damos el controlador
        navigationItem.searchController = searchController
        // 5 nos aseguramos de que la barra de busqueda no aparezca en siguientes pantallas
        definesPresentationContext = true
        fetch()
    }
    
    
    func fetch() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fechRequest = NSFetchRequest<Event>(entityName: "Event")
        
        do{
            self.event = try managedContext.fetch(fechRequest)
            print("fech: \(self.event[0].name!)")
        } catch{
            debugPrint("error: \(error.localizedDescription)")
        }
    }
    
    func save(textField: String){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let ev = Event(context: managedContext)
        ev.name = textField
        
        do {
            try managedContext.save()
            print("guardado")
        } catch {
            debugPrint("El error es: \(error.localizedDescription)")
        }
    }
}
