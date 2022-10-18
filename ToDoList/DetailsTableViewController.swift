import UIKit

class DetailsTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var toDo: ToDo?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    // To hide cells
    // Date Picker
    let dueDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let timeStampLabelIndexPath = IndexPath(row: 0, section: 1)
    var isDueDatePickerHidden: Bool = true
    // Notes
    let notesIndexPath = IndexPath(row: 0, section: 2)
    // Image
    let imageViewIndexPath = IndexPath(row: 1, section: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        updateSaveButtonState()
        updateTimeStampLabel(date: dueDatePicker.date)
        updateDueDatePicker()
    }
    
    
    // Update Save Button State every time the value changes in the text field
    @IBAction func titleEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    // Dismiss the keyboard on return Text Field
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // Config CheckMark Button
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    
    // Config Date Label
    func updateTimeStampLabel(date: Date) {
        timeStampLabel.text = date.formatted(.dateTime.month(.abbreviated).day().year(.twoDigits).hour().minute())
    }
    @IBAction func dueDatePickerChanged(_ sender: UIDatePicker) {
        updateTimeStampLabel(date: sender.date)
    }
    
    // Config Date Picker
    func updateDueDatePicker() {
        dueDatePicker.minimumDate = Date().addingTimeInterval(60)
        dueDatePicker.date = Date().addingTimeInterval(24*60*60)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    // PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePicker.date
        // let notes = notesTextView.text
        // let image = imageView.image
        
        toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate)
    }
    
    // Update Save button logic
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    // **IMAGE PICKER LOGIC**
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Alert Controller declaration and header
        let alertController = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
      
        // Present Photo Library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // Did select Row at
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Date Picker - toggle
        if indexPath == timeStampLabelIndexPath {
            isDueDatePickerHidden.toggle()
            updateTimeStampLabel(date: dueDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    // Height for row at
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dueDatePickerIndexPath where isDueDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    // Estimated height for row at
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dueDatePickerIndexPath:
            return 216
        case notesIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
}
