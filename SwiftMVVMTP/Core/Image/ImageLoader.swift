//
//  ImageLoader.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import Kingfisher
import UIKit
class ImageLoader {
    static func load(url : String, imageView : UIImageView, imageDefault : UIImage? = nil, completionHandler: ((UIImage) -> Void)? = nil){
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: imageDefault,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                completionHandler?(value.image)
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    static func load(url : String, completionHandler: ((UIImage) -> Void)? = nil) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
                completionHandler?(value.image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
