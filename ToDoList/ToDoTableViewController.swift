import UIKit

class ToDoTableViewController: UITableViewController {
    
    var toDos = [ToDo]()

    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Try to load items from disk
        if let savedToDos = ToDo.loadToDo() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDo()
        }
        
        // Instantiate Edit button "intelligently"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .systemGreen
        
    }
    
    
    
    // MARK: - Unwind and Segue
     
    // Return to the To Do List method
 
@IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! DetailsTableViewController
        
        if let toDo = sourceViewController.toDo {
            if let indexOfExistingToDo = toDos.firstIndex(of: toDo) {
                toDos[indexOfExistingToDo] = toDo
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

    // Edit To Do Segue Action***
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> DetailsTableViewController? {
        let detailController = DetailsTableViewController(coder: coder)
                
        guard let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
        // If Add button is selected, return empty controller
        return detailController
    }
                    
        tableView.deselectRow(at: indexPath, animated: true)
                    
        detailController?.toDo = toDos[indexPath.row]
        
        return detailController
    }
    
    
    
    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    // Cell configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Downcast as! ToDoCell subclass to customize
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as! ToDoCell
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let toDo = toDos[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = toDo.title
        cell.contentConfiguration = content
        
        // tableView.reloadData()

        return cell
    }
    
    // Swipe-To-Delete BOOL - allCells == true
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Configure Swipe-To-Delete et alia
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}
