//
//  MasterViewController.swift
//  CustomAddressBook


import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredContacts = [Person]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        filteredContacts = appDelegate.contactsArray.filter { p in
            var containsString = false
            
            if p.firstName!.lowercased().contains(searchText.lowercased()) {
                containsString = true
            }
            
            if let lastName = p.lastName {
                if lastName.lowercased().contains(searchText.lowercased()) {
                    containsString = true
                }
            }
            return containsString
        }
        
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.performSegue(withIdentifier: "addSegue", sender: self)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                //let object = objects[indexPath.row] as! NSDate
                //let object = appDelegate.contactsArray[indexPath.row]
                let object: Person
                if searchController.isActive && searchController.searchBar.text != "" {
                    object = filteredContacts[indexPath.row]
                } else {
                    object = appDelegate.contactsArray[indexPath.row]
                }
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredContacts.count
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.contactsArray.count
        
        //return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomContactCell

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //let object = appDelegate.contactsArray[indexPath.row]
        let object: Person
        if searchController.isActive && searchController.searchBar.text != "" {
            object = filteredContacts[indexPath.row]
        } else {
            object = appDelegate.contactsArray[indexPath.row]
        }
        
        //cell.textLabel!.text = object.firstName
        cell.firstNameLabel.text = object.firstName
        cell.lastNameLabel.text = object.lastName
        
        cell.initialsLabel.layer.cornerRadius = 10
        cell.initialsLabel.clipsToBounds = true
        
        if let firstInitial = object.firstName?.characters.first {
            if let lastInitial = object.lastName?.characters.first {
                cell.initialsLabel.text = "\(firstInitial)\(lastInitial)"
            } else {
                cell.initialsLabel.text = "\(firstInitial)"
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.contactsArray.remove(at: indexPath.row)
            appDelegate.storeContactsArray()
            
            //objects.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

