//
//  PatientsTabBar.swift
//  Recorto
//
//  Created by Andersons on 23.11.2023.
//

import UIKit
import Firebase

class PatientsTabBar: UITabBarController {
    
        static let databaseRef = Database.database().reference()

       static func saveEvent(date: Date, otherEventData: String) {
           let eventRef = databaseRef.child("Events").childByAutoId()
           let event = ["date": date.timeIntervalSince1970,
                        "otherData": otherEventData] as [String : Any]

           eventRef.setValue(event)
       }

    static func configureTabBarController(_ tabBarController: UITabBarController) {
            // Storyboard ID'leri kullanarak view controller'ları alın
            if let searchViewController = viewControllerWithStoryboardID("SearchView"),
               let agendaViewController = viewControllerWithStoryboardID("AgendaView"),
               let faqViewController = viewControllerWithStoryboardID("FAQView"),
               let profileViewController = viewControllerWithStoryboardID("ProfileView")
        {

                // View controller'ları tab bar controller'a ekleyin
                tabBarController.viewControllers = [searchViewController, agendaViewController, faqViewController, profileViewController]
            }
        }

        private static func viewControllerWithStoryboardID(_ storyboardID: String) -> UIViewController? {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: storyboardID)
        }
}
