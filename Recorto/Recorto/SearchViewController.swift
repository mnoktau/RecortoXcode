import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var users: [User] = []
    var filteredUsers: [User] = []
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupFirestore()
    }
    
    func setupFirestore() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text, !searchText.isEmpty else {
            filteredUsers = users
            updateSearchResults()
            return
        }
        
        filteredUsers = users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        updateSearchResults()
    }
    
    func updateSearchResults() {
        searchResultsTableView.reloadData()
    }
    
    func fetchUsers() {
        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching users: \(error)")
                return
            }
            self?.users = snapshot.documents.compactMap { document in
                let data = document.data()
                let name = data["name"] as? String ?? ""
                let userType = data["userType"] as? String ?? ""
                return User(name: name, userType: userType)
            }
            self?.filteredUsers = self?.users ?? []
            self?.updateSearchResults()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let user = filteredUsers[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.userType
        return cell
    }
}

struct User {
    let name: String
    let userType: String
}
