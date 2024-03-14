import UIKit
import FirebaseStorage
import Firebase

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos: [UIImage] = []
    var storageRef: StorageReference!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirestore()
        setupStorage()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupFirestore() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func setupStorage() {
        storageRef = Storage.storage().reference()
    }
    
    func fetchPhotos() {
        // Firebase Firestore'dan fotoğrafları getirme
        // Verileri 'photos' dizisine ekleme
    }
    
    func uploadPhoto(image: UIImage) {
        // Fotoğrafı Firebase Storage'a yükleme
        // Yükleme tamamlandıktan sonra download URL'sini alarak Firestore'da kaydetme
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        // Kullanıcıya fotoğraf seçme işlemi
        // Seçilen fotoğrafı yüklemek için 'uploadPhoto' fonksiyonunu çağırma
    }
}

extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        cell.imageView?.image = photos[indexPath.row]
        return cell
    }
}
