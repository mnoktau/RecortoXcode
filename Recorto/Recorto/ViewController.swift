import UIKit
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailGiris: UITextField!
    @IBOutlet weak var girisBtn: UIButton!
    @IBOutlet weak var passwordGiris: UITextField!
    @IBOutlet weak var facebookBtn: UIButton!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIImagePickerController'ı yapılandır
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    @IBAction func signupButtonTapped(_ sender: UIButton) {
        showPopup()
    }

    func navigateToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainViewController = storyboard.instantiateViewController(withIdentifier: "Patients") as? UITabBarController {
            navigationController?.pushViewController(mainViewController, animated: true)
        }
    }

    func showPopup() {
        let alertController = UIAlertController(title: "Resim Yükle", message: "Görüntü seçmek için galeriyi açın", preferredStyle: .alert)
        
        // Görüntü seçme butonunu oluşturun ve üzerine tıklandığında UIImagePickerController'ı gösterin
        let selectImageAction = UIAlertAction(title: "Galeriyi Aç", style: .default) { (_) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: "Tamam", style: .default) { (_) in
            self.navigateToMainScreen()
        }
        
        alertController.addAction(selectImageAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate metotları
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Kullanıcı bir fotoğraf seçtiğinde
        dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            // Seçilen fotoğrafı Firebase Storage'a yükle
            uploadImageToFirebase(image: image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Kullanıcı seçim yapmadan UIImagePickerController'ı kapattığında
        dismiss(animated: true, completion: nil)
    }

    func uploadImageToFirebase(image: UIImage) {
        // Firebase Storage referansını al
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        // Fotoğrafı JPEG formatına dönüştür ve Data tipine çevir
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Fotoğrafı Firebase Storage'a yükle
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    // Yükleme hatası
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    // Yükleme başarılı, metadata içinden dosya URL'sini al
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            // URL alma hatası
                            print("Error getting download URL: \(error.localizedDescription)")
                        } else if let url = url {
                            // URL başarılı bir şekilde alındı, işlemleri burada gerçekleştirin
                            print("Download URL: \(url)")
                        }
                    }
                }
            }
        }
    }
}
