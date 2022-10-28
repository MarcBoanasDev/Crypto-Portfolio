//
//  CoinImageViewModel.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 13/10/2022.
//

import SwiftUI

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel!
    private let networkingManager: NetworkingManagerImp!
    private let folderName = "coin_images"
    private let fileManager = LocalFileManager.instance
    
    init(coin: CoinModel, networkingManager: NetworkingManagerImp = NetworkingManager.shared) {
        self.coin = coin
        self.networkingManager = networkingManager
    }
    
    @MainActor
    func getImage() async {
        
        if let savedImage = fileManager.getImage(name: coin.name, folderName: folderName) {
            image = savedImage
        } else {
            await downloadImage()
        }
    }
    
    @MainActor
    func downloadImage() async {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let (imageData, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: coin.image)!) )
            
            if let image = UIImage(data: imageData) {
                self.image = image
                // Save image to local storage (cached images speed up image rendering)
                fileManager.saveImage(image: image, imageName: coin.name, folderName: folderName)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
