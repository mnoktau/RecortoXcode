import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Kayıt bilgileri eksik
            return
        }

        // Firebase'e kayıt ol
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                // Kayıt başarısız oldu, hata mesajını kullanıcıya göster
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            } else {
                // Kayıt başarılı, e-posta doğrulaması gönder
                authResult?.user.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        // E-posta doğrulama gönderme hatası
                        print("Error sending verification email: \(error.localizedDescription)")
                    } else {
                        // E-posta doğrulama başarıyla gönderildi
                        print("Verification email sent")
                    }
                })
                // Kullanıcıyı giriş sayfasına yönlendir
                strongSelf.performSegue(withIdentifier: "SignUpToLogin", sender: nil)
            }
        }
    }
}
