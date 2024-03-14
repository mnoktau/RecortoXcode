import UIKit
import Firebase
import UserNotifications

class DoctorViewController: UIViewController {
    
    @IBOutlet weak var approvalSwitch: UISwitch!
    @IBOutlet weak var notificationDatePicker: UIDatePicker!
    
    var db: Firestore!
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirestore()
        setupNotificationDatePicker()
        fetchDoctorData()
    }
    
    func setupFirestore() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func setupNotificationDatePicker() {
        // Date picker'ı bugünden sonraki tarihleri seçebilecek şekilde ayarla
        notificationDatePicker.minimumDate = Date()
    }
    
    func fetchDoctorData() {
        let doctorRef = db.collection("doctors").document("doctorID")
        doctorRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let isApproved = data?["isApproved"] as? Bool ?? false
                self?.approvalSwitch.isOn = isApproved
                
                if let timestamp = data?["notificationDate"] as? Timestamp {
                    let date = timestamp.dateValue()
                    self?.notificationDatePicker.date = date
                }
            } else {
                print("Doctor document does not exist")
            }
        }
    }
    
    @IBAction func approvalSwitchValueChanged(_ sender: UISwitch) {
        let doctorRef = db.collection("doctors").document("doctorID")
        doctorRef.updateData(["isApproved": sender.isOn]) { error in
            if let error = error {
                print("Error updating approval status: \(error)")
            } else {
                print("Approval status updated successfully")
            }
        }
    }
    
    @IBAction func notificationDateChanged(_ sender: UIDatePicker) {
        let doctorRef = db.collection("doctors").document("doctorID")
        doctorRef.updateData(["notificationDate": sender.date]) { error in
            if let error = error {
                print("Error updating notification date: \(error)")
            } else {
                print("Notification date updated successfully")
                // Bildirimleri yeniden planla
                self.scheduleNotifications()
            }
        }
    }
    
    func scheduleNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        
        guard approvalSwitch.isOn else {
            return
        }
        
        let notificationDate = notificationDatePicker.date
        
        scheduleNotification(at: notificationDate, message: "12 saat kaldı")
        scheduleNotification(at: notificationDate.addingTimeInterval(-21600), message: "6 saat kaldı")
        scheduleNotification(at: notificationDate.addingTimeInterval(-3600), message: "1 saat kaldı")
    }
    
    func scheduleNotification(at date: Date, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Randevu Hatırlatma"
        content.body = message
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
