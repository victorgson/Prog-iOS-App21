//
//  VehicleMakeTableViewController.swift
//  WestCoast-Cars
//
//  Created by Michael Gustavsson on 2022-01-11.
//

import UIKit

class VehicleMakeTableViewController: UITableViewController {
    
    
    // Steg 2. Skapa en variable/egenskap för att hantera vår datakälla...
    // Använd lazy nyckelordet för att vänta in att funktionen setUpDataSource är initierad...
    lazy var dataSource = setupDataSource()
        
    var manufacturors: [Manufacturor] = [
        Manufacturor(manufacturorName: "Ford", image: "ford"),
        Manufacturor(manufacturorName: "Volvo", image: "volvo", numberOfVehiclesInStock: 4)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Steg 3. Initiera vår tableViews dataSource att använda vår datakälla
        // Steg 3.1
        tableView.dataSource = dataSource //Anslutit vår datakälla till tableView

        // Steg 3.2 Skapa ett snapshot av datat
        var snapshot = NSDiffableDataSourceSnapshot<Section, Manufacturor>()
        
        // Steg 3.3 Lägg till antal eller vilka sektioner som skall ingå i vårt snapshot
        snapshot.appendSections([.all])
        // Vilket data skall användas och till vilken sektion/grupp skall vi addera det till...
        snapshot.appendItems(manufacturors, toSection: .all)
        
        // Steg 3.4 Lägg till vårt snapshot till vår datakälla...
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // Steg 1. Konfigurera datakällan till att använda ManufacturorDiffableDataSource...
    func setupDataSource() -> ManufacturorDiffableDataSource{
        //let cellIdentifier = "makeBaseCell"
        //let cellIdentifier = "makeFancyCell"
        let cellIdentifier = "makeNiceCell"
        // Skapa en instans av UITableViewDiffableDatasource...
        let dataSource = ManufacturorDiffableDataSource(tableView: tableView,
                                                                        cellProvider: {
            //Closure
            tableView,
            indexPath,
            manufacturor in let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MakeTableViewCell
            
            cell.makeNameLabel.text = manufacturor.name
            cell.availabilityLabel.text = "\(manufacturor.availableVehicles)"
            cell.thumbnailImage.image = UIImage(named: manufacturor.logoImage)
            
            return cell
        })
        // Returnera den nyligen skapade datakällan ovan...
        return dataSource
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Kontrollera vilken segue som vi skall navigera via...
        if segue.identifier == "AvailableVehiclesForMake" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! VehicleMakeDetailsViewController
                
                //destinationController.makeName = vehicles[indexPath.row]
                destinationController.manufacturor = manufacturors[indexPath.row]
            }
        }
    }

    //Göm topp menyn
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
