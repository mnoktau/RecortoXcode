import UIKit

class EventCreationViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = .dateAndTime
    }

    @IBAction func saveEventButtonTapped(_ sender: UIButton) {
        saveEvent()
    }

    func saveEvent() {
        let selectedDate = datePicker.date

        // Firebase'e event'i kaydetme işlemleri burada gerçekleştirilecek
        // Örneğin, Realtime Database'e kayıt eklemek için kullanılabilir
        // FirebaseDataManager.saveEvent(date: selectedDate, otherEventData: ...)
    }
}
