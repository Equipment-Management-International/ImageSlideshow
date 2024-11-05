//
//  InputSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
//
//

import UIKit

/// A protocol that can be adapted by different Input Source providers
@objc public protocol InputSource {
    /**
     Load image from the source to image view.
     - parameter imageView: Image view to load the image into.
     - parameter callback: Callback called after image was set to the image view.
     - parameter image: Image that was set to the image view.
     */
    func load(to imageView: UIImageView, with callback: @escaping (_ image: UIImage?) -> Void)
    
    /**
     Cancel image load on the image view
     - parameter imageView: Image view that is loading the image
    */
    @objc optional func cancelLoad(on imageView: UIImageView)
}

/// Input Source to load plain UIImage
@objcMembers
open class ImageSource: NSObject, InputSource {
    var image: UIImage
    var imageTitle: String!

    /// Initializes a new Image Source with UIImage
    public init(image: UIImage, imageTitle : String) {
        self.image = image
        self.imageTitle = imageTitle
    }

    /// Initializes a new Image Source with an image name from the main bundle
    /// - parameter imageString: name of the file in the application's main bundle
    @available(*, deprecated, message: "Use `BundleImageSource` instead")
    public init?(imageString: String) {
        if let image = UIImage(named: imageString) {
            self.image = image
            super.init()
        } else {
            return nil
        }
    }

    /*public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        imageView.image = image
        callback(image)
    }*/
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {

        imageView.image = image
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .yellow
        label.text = imageTitle
        
        label.font = UIFont(name:"Roboto-Bold", size: 14.0)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(label)
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        
        if #available(iOS 9.0, *) {
            label.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
            label.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 5).isActive = true
            label.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5).isActive = true
        } else {
            // Fallback on earlier versions
        }

        callback(image)

    }
}

/// Input Source to load an image from the main bundle
@objcMembers
open class BundleImageSource: NSObject, InputSource {
    var imageString: String
    
    /// Initializes a new Image Source with an image name from the main bundle
    /// - parameter imageString: name of the file in the application's main bundle
    public init(imageString: String) {
        self.imageString = imageString
        super.init()
    }
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        let image = UIImage(named: imageString)
        imageView.image = image
        callback(image)
    }
}

/// Input Source to load an image from a local file path
@objcMembers
open class FileImageSource: NSObject, InputSource {
    var path: String
    
    /// Initializes a new Image Source with an image name from the main bundle
    /// - parameter imageString: name of the file in the application's main bundle
    public init(path: String) {
        self.path = path
        super.init()
    }
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        let image = UIImage(contentsOfFile: path)
        imageView.image = image
        callback(image)
    }
}
