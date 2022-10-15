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
    static func loadToDo() -> [ToDo] {
        return nil
    }
    
}
