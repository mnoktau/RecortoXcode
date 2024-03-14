//
//  DoctorsTabBar.swift
//  Recorto
//
//  Created by Andersons on 23.11.2023.
//

//
//  PatientsTabBar.swift
//  Recorto
//
//  Created by Andersons on 23.11.2023.
//

import UIKit

class DoctorsTabBar: UITabBarController {

    static func configureTabBarController(_ tabBarController: UITabBarController) {
            // Storyboard ID'leri kullanarak view controller'ları alın
            if let agendaViewController = viewControllerWithStoryboardID("AgendaViewDoctors"),
               let commentsViewController = viewControllerWithStoryboardID("CommentsViewDoctors"),
               let patientsViewController = viewControllerWithStoryboardID("PatientsViewDoctors"),
               let profileViewController = viewControllerWithStoryboardID("ProfileViewDoctors")
        {

                // View controller'ları tab bar controller'a ekleyin
                tabBarController.viewControllers = [agendaViewController, commentsViewController, patientsViewController, profileViewController]
            }
        }

        private static func viewControllerWithStoryboardID(_ storyboardID: String) -> UIViewController? {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: storyboardID)
        }
}

