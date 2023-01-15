//
//  AppDelegate.swift
//  UsingSQLLite
//
//  Created by Cristina Richter on 08.01.2023.
//

import UIKit
import SQLite3

var dbQueue: OpaquePointer!

// Variable to store the location of the SQLite Database
var dbURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dbQueue = createAndOpenDatabase() //create and open database + set the pointer
        
        if (createTables() == false)
        {
            print("Error in creating tables")
        }
        else
        {
            print("Tables created.")
        }
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

     func createAndOpenDatabase() -> OpaquePointer? //swift type for C Pointers
    {
        var db: OpaquePointer?
        
        let url = NSURL(fileURLWithPath: dbURL) //Sets up the URL to the database
        
        //name you database here
        if let pathComponent = url.appendingPathComponent("TEST.sqlite")
        {
            let filePath = pathComponent.path
            
            if sqlite3_open(filePath, &db) == SQLITE_OK
            {
                print("Successfully opened the database at \(filePath)")
                
                return db
            }
            else
            {
                print ("Could not open the database")
            }
        }
        else
        {
            print("File Path is not available.")
        }
        
        return db
    }
    
    func createTables() -> Bool {
        var bretVal : Bool = false
        let createTable = sqlite3_exec(dbQueue, "CREATE TABLE IF NOT EXISTS TEMP (TEMPCOLUMN1 TEXT NULL, TEMPCOLUMN2 TEXT NULL)", nil, nil, nil)
        
        if (createTable != SQLITE_OK){
            print("not able to create table")
            bretVal = false
        }
        else {
            bretVal = true
        }
        return bretVal
    }
}

