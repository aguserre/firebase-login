//
//  ImageDownloader.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import Foundation
import Kingfisher


final class ImageDownloader {
    
    typealias ImageDidFinishLoading = (UIImage?) -> Void
    
    func downloadImage(url: String, completion: @escaping ImageDidFinishLoading) {
        DispatchQueue.main.async {
            guard let url = URL(string: url) else {
                completion(nil)
                return
            }
            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url),
                                                   options: nil,
                                                   progressBlock: nil) { result in
                switch result {
                case .failure(_):
                    completion(nil)
                case .success(let value):
                    completion(value.image)
                }
            }
        }
    }
}
