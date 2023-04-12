//
//  NotificationService.swift
//  NotificationService
//
//  Created by TrucPham on 12/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            if let urlString = request.content.userInfo["image"] as? String, !urlString.isEmpty, let fileUrl = URL(string: urlString) {
                bestAttemptContent.attachments = []
                if let imageData = NSData(contentsOf: fileUrl) {
                    if let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "\(UUID().uuidString).jpg", data: imageData, options: nil) {
                        bestAttemptContent.attachments.append(attachment)
                    }
                }
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
extension UNNotificationAttachment {
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
    static func createImageDefault(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
            let fileManager = FileManager.default
            let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
            let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
            do {
                try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
                let imageFileIdentifier = identifier+".png"
                let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
                let imageData = UIImage.pngData(image)
                try imageData()?.write(to: fileURL)
                let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
                return imageAttachment
            } catch {
                print("error " + error.localizedDescription)
            }
            return nil
        }
}
