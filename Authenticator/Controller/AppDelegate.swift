//
//  AppDelegate.swift
//  Authenticator
//
//  Created by Kel Reid on 06/29/23
//

import UIKit
import Sentry
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SentrySDK.start { options in
            options.dsn = "https://196034a60eb9c41750057225f5032566@o4506628563927040.ingest.sentry.io/4506633247326208"
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true 

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }

                // Override point for customization after application launch.
            return true
        }

        // MARK: UISceneSession Lifecycle
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
                // Called when a new scene session is being created.
                // Use this method to select a configuration to create the new scene with.
                return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }

        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
                // Called when the user discards a scene session.
                // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
                // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        }

        // MARK: - Core Data stack
        lazy var persistentContainer: NSPersistentCloudKitContainer = {
                /*
                 The persistent container for the application. This implementation
                 creates and returns a container, having loaded the store for the
                 application to it. This property is optional since there are legitimate
                 error conditions that could cause the creation of the store to fail.
                 */
                let container = NSPersistentCloudKitContainer(name: "Authenticator")
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                        if let error = error as NSError? {
                                /*
                                 Typical reasons for an error here include:
                                 * The parent directory does not exist, cannot be created, or disallows writing.
                                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                                 * The device is out of space.
                                 * The store could not be migrated to the current model version.
                                 Check the error message to determine what the actual problem was.
                                 */
                                logger.debug("Unresolved error \(error), \(error.userInfo)")
                        }
                })
                return container
        }()

        // MARK: - Core Data Saving support
        func saveContext () {
                let context = persistentContainer.viewContext
                if context.hasChanges {
                        do {
                                try context.save()
                        } catch {
                                let nserror = error as NSError
                                logger.debug("Unresolved error \(nserror), \(nserror.userInfo)")
                        }
                }
        }

}
