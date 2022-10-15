import UIKit

struct ToDo: Equatable {
    var id = UUID()
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var image: UIImage?
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Retrieve [ToDo] from memory
    static func loadToDo() -> [ToDo]? {
        return nil
    }
    
    // Method to generate element of [ToDo]
    static func loadSampleToDo() -> [ToDo] {
        let toDo1 = ToDo(title: "To-Do One", isComplete: false, dueDate: Date(), notes: "Note One")
        let toDo2 = ToDo(title: "To-Do Two", isComplete: false, dueDate: Date(), notes: "Note Two")
        let toDo3 = ToDo(title: "To-Do Three", isComplete: false, dueDate: Date(), notes: "Note Three")
        
        return [toDo1, toDo2, toDo3]
    }
    
}
