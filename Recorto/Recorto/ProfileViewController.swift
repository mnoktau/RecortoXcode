import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Profil Düzenle", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Adınız"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Soyadınız"
        }
        
        let saveAction = UIAlertAction(title: "Kaydet", style: .default) { [weak self] (_) in
            guard let firstNameTextField = alertController.textFields?[0],
                  let lastNameTextField = alertController.textFields?[1],
                  let firstName = firstNameTextField.text,
                  let lastName = lastNameTextField.text else {
                return
            }
            
            self?.saveProfile(firstName: firstName, lastName: lastName)
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveProfile(firstName: String, lastName: String) {
        // Firebase'e profil verilerini kaydetme
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        userRef.updateData([
            "firstName": firstName,
            "lastName": lastName
        ]) { err in
            if let err = err {
                print("Error updating profile: \(err)")
            } else {
                print("Profile updated successfully")
            }
        }
    }
}
