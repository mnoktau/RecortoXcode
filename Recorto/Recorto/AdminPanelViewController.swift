import UIKit
import Firebase

class AdminPanelViewController: UIViewController {
    
    @IBOutlet weak var notificationTextView: UITextView!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirestore()
    }
    
    func setupFirestore() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    @IBAction func sendNotificationButtonTapped(_ sender: UIButton) {
        guard let message = notificationTextView.text, !message.isEmpty else {
            // Eğer bildirim metni boşsa, kullanıcıyı uyar ve işlemi sonlandır.
            return
        }
        
        sendNotification(message: message)
    }
    
    func sendNotification(message: String) {
        // Tüm kullanıcılara bildirim göndermek için FCM'i kullanın
        // İlk önce tüm doktor veya hastaların token'larını Firestore'dan alın
        db.collection("users").whereField("userType", isEqualTo: "doctor").getDocuments { [weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching doctors: \(error)")
                return
            }
            for document in snapshot.documents {
                let data = document.data()
                if let token = data["fcmToken"] as? String {
                    self?.sendFCMNotification(to: token, message: message)
                }
            }
        }
    }
    
    func sendFCMNotification(to token: String, message: String) {
        // FCM API'sini kullanarak bildirim gönderme işlemi
        // Bu kısımda Firebase Cloud Messaging API'sini kullanarak bildirimi gönderebilirsiniz
    }
}
