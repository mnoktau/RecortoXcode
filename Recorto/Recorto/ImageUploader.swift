import UIKit
import FirebaseStorage

class ImageUploader {

    static let shared = ImageUploader()

    private init() {}

    func uploadImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        // Fotoğrafı JPEG formatına dönüştür ve Data tipine çevir
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Firebase Storage referansını al
            let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
            // Fotoğrafı Firebase Storage'a yükle
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    // Yükleme hatası
                    completion(.failure(error))
                } else {
                    // Yükleme başarılı, metadata içinden dosya URL'sini al
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            // URL alma hatası
                            completion(.failure(error))
                        } else if let url = url {
                            // URL başarılı bir şekilde alındı
                            completion(.success(url))
                        }
                    }
                }
            }
        }
    }
}
