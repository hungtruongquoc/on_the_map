//
//  AppDelegate.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var loginInfo: LoginResponse?
    private var studentList: StudentList?
    private var newStudentInfo: StudentInformation?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

    func initializeNewStudentInfo() {
        // Initialize newStudentInfo with a new instance of StudentInformation
        newStudentInfo = StudentInformation(createdAt: "", firstName: "", lastName: "", latitude: 0.0, longitude: 0.0, mapString: "", mediaURL: "", objectId: "", uniqueKey: "", updatedAt: "")
        print("Initialized new student information")
    }
    
    // MARK: - Accessor Methods for LoginInfo
    func getLoginInfo() -> LoginResponse? {
        return loginInfo
    }
    
    func setLoginInfo(_ info: LoginResponse?) {
        loginInfo = info
    }

    // MARK: - Accessor Methods for StudentList
    
    func getStudentList() -> StudentList? {
        return studentList
    }
    
    func setStudentList(_ list: StudentList?) {
        studentList = list
    }

    // MARK: - Accessor Methods for NewStudentInfo
    
    func getNewStudentInfo() -> StudentInformation? {
        return newStudentInfo
    }
    
    func setNewStudentInfo(_ info: StudentInformation?) {
        newStudentInfo = info
    }
}

