//
//  LocalFileManager.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 18/10/2022.
//

import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolder(folderName) // Create a folder if one doesn't exist
        
        // Get path for image
        guard let data = image.pngData(), let url = getURLForImage(name: imageName, folderName: folderName) else { return }
        
        // Save image to path
        do {
            try data.write(to: url)
        } catch {
            print("⚠️ Error saving image to local storage named \(imageName): \(error.localizedDescription)")
        }
    }
    
    func getImage(name: String, folderName: String) -> UIImage? {
        
        guard let url = getURLForImage(name: name, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    func createFolder(_ name: String) {
        
        guard let folderURL = getURLForFolder(name) else { return }
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("Error creat=ing directory \(name): \(error.localizedDescription)")
            }
        }
    }
    
    func getURLForFolder(_ name: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(name)
    }
    
    func getURLForImage(name: String, folderName: String) -> URL? {
        
        guard let folderURL = getURLForFolder(folderName) else {
            return nil
        }
        
        return folderURL.appendingPathComponent(name + ".png")
    }
}
