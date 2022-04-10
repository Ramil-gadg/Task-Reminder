//
//  NotificationManager.swift
//
//

import Foundation
import UserNotifications


class NotificationManager: NSObject {
    
    var notificationCenter = UNUserNotificationCenter.current()
    
    static let shared = NotificationManager()
    override private init () {}
    
    func requestNotificationAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] response, error in
            print("answer is \(response)")
            
            if response {
                self?.getNotificationSettings()
            }
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("user allowed: \(settings)")
        }
    }
    
    func sendLocaleNotification(with title: String, body: String, id: String, interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        let userAction = "user action"
        
        content.sound = .default
        content.title = title
        content.body = body
        content.badge = 1
        content.categoryIdentifier = userAction
        
        guard let path = Bundle.main.path(forResource: "done_image", ofType: "jpeg")  else  { return }
        let url = URL(fileURLWithPath: path)
        do {
            let atachment = try UNNotificationAttachment(identifier: "done_image", url: url)
            content.attachments = [atachment]
        } catch {
            print("error when try get UNNotificationAttachment")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let identifire = id
        
        let notificationRequest = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(notificationRequest) { error in
            if let error = error {
                print("ошибка при создании уведомления: \(error.localizedDescription)")
            }
        }
        let remindAfterTenMinAction = UNNotificationAction(identifier: PushActions.remindAfterTenMin.rawValue, title: "remind_after_10_min".localized, options: [])
        let remindAfterHourAction = UNNotificationAction(identifier: PushActions.remindAfterHour.rawValue, title: "remind_after_hour".localized, options: [])
        let deleteAction = UNNotificationAction(identifier: PushActions.closeAction.rawValue, title: "notif_close".localized, options: [.destructive])
        
        
        let category = UNNotificationCategory(identifier: userAction, actions: [remindAfterTenMinAction, remindAfterHourAction, deleteAction], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .banner])
        } else {
            completionHandler([.sound, .alert])
            
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let request = response.notification.request
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("default")
        case UNNotificationDismissActionIdentifier:
            print("dismiss")
        case PushActions.remindAfterTenMin.rawValue:
            sendLocaleNotification(with: request.content.title, body: request.content.body, id: request.identifier, interval: 600)
        case PushActions.remindAfterHour.rawValue:
            sendLocaleNotification(with: request.content.title, body: request.content.body, id: request.identifier, interval: 3600)
        case PushActions.closeAction.rawValue:
            print("close")
        default:
            print("unknown Action")
        }
        completionHandler()
    }
}

enum PushActions: String {
    case remindAfterHour
    case remindAfterTenMin
    case closeAction
}
