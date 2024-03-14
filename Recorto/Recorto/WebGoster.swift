import UIKit
import WebKit

class WebGoster: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        if let url = URL(string: "https://www.instagram.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // Diğer kodlar...
}
