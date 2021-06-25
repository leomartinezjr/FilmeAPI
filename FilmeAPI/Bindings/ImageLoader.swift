//
//  ImageLoader.swift
//  FilmeAPI
//
//  Created by Leonardo Paez on 10/06/21.
//

import SwiftUI
import UIKit

private let _imageCache = NSCache<AnyObject,AnyObject>()

class ImageLoader: ObservableObject{
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    
    var imageCache = _imageCache
    
    func loadImage (with url: URL){
        let urlString = url.absoluteURL // pesquisar
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject)as? UIImage{
            self.image = imageFromCache
            return
    
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in // weak and strng
            guard let self = self else {return}
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                    
                }
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    self.image = image
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

