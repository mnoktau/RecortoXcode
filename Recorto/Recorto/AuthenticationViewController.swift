import UIKit
import LocalAuthentication
import Firebase

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateWithBiometrics()
    }
    
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Parolanızı doğrulamak için parmak izinizi kullanın."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        // Parmak izi ile giriş başarılı
                        self?.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
                    } else {
                        // Parmak izi ile giriş başarısız veya kullanıcı izin vermedi
                        print("Authentication failed")
                    }
                }
            }
        } else {
            // Cihaz parmak izi veya yüz tanıma desteklemiyor veya kullanıcı tanımayı etkinleştirmemiş
            print("Biometric authentication unavailable")
        }
    }
}
