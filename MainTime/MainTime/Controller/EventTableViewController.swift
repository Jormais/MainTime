//
//  EventTableViewController.swift
//  MainTime
//
//  Created by Jonay Brito Hernández on 26/02/2020.
//  Copyright © 2020 Jonay Brito Hernández. All rights reserved.
//

import UIKit

class EventTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet var eventTable : UITableView!
    var events = ["Proyecto 1","Proyecto 2","Proyecto 3","Proyecto 4","Proyecto 5","Proyecto 6","Proyecto 7"]
    var filteredEvents : [String] = [] //array de filtrado para el buscador
    var isSearchBarEmpty: Bool { //se comprueba si la barra de busqueda esta vacia
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool { //se comprueba si se ha filtrado
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil) //controlador para barra de busqueda
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { //comprobamos si se ha filtrado para coger el array correcto
            return filteredEvents.count
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        debajo definimos nuestra celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellEvent
//        debajo controlamos que celda se mostrara y que texto tendra
        if isFiltering{ //antes comprobando si se ha filtrado para escoger el array correcto
            cell.textLabel?.text = filteredEvents[indexPath.row]
        } else {
            cell.textLabel?.text = events[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [makeArchiveContextualAction(forRowAt: indexPath), makeDeleteContextualAction(forRowAt: indexPath)]) //aquihacemos el return sin la palabla reservada siguiendo el patron de swift 5 probando
    }
    
    func makeArchiveContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "New", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            self.events.append("Nueva Celda")
            self.eventTable.insertRows(at: [indexPath], with: .automatic)
       })
        action.backgroundColor = .green
       return action
    }
    
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
       
    }
}
