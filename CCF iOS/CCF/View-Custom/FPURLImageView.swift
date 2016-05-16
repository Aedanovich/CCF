//
//  FPURLImageView.swift
//  Directist
//
//  Created by Alex on 5/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

var DEFAULT_IMAGE : String = "banner_default.png"
var UNIVERSAL_TIME_OUT : CGFloat = 60.0
var QUEUE_COUNT : NSInteger = 2
var SCALED_DOWN_IMAGE_FILENAME : String = "-640p.jpg"
var SCALED_DOWN_IMAGE_WIDTH : CGFloat = 150.0
var TOP_BUFFER : CGFloat = 0.0

enum LoadingViewColor : UInt {
    case Black
    case White
}

extension UIImage {
    func scaleToWidth(i_width : CGFloat) -> UIImage {
        let oldWidth : CGFloat = self.size.width
        let scaleFactor : CGFloat = i_width / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

private let _ImageManagerSharedInstance = ImageManager()

class ImageManager : NSObject {
    var currentDownloadStack : NSMutableArray! = NSMutableArray(capacity: 0)
    var targets : NSMutableDictionary! = NSMutableDictionary(capacity: 0)
    var targetsQueue : NSMutableDictionary! = NSMutableDictionary(capacity: 0)
    
    //    self.currentDownloadStack = NSMutableArray.alloc()
    //    self.targetsQueue = NSMutableDictionary.alloc()
    //    self.targets = NSMutableDictionary.alloc()
    
    class var Instance : ImageManager {
    return _ImageManagerSharedInstance;
    }
    
    func IsImageSaved(url : String) -> Bool {
        let filename = NSURL(string: url)?.lastPathComponent
        let pathArr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = pathArr.first! as String
        let imgFolderPath = documentsDirectory + "/images/"
        let path = imgFolderPath + filename!
        
        // If File exists in documents
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func IsDownloading () -> Bool{
        return false
    }
    
    func ImageFolderPath () -> String {
        let pathArr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = pathArr.first! as String
        let imgFolderPath = documentsDirectory + "/images/"
        return imgFolderPath
    }
    
    func DeleteAllFilesWithCompletion(completion : (()->Void)!) {
        let fileMgr : NSFileManager = NSFileManager()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let pathArr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory = pathArr.first! as String
            let imgFolderPath : String = ImageManager.Instance.ImageFolderPath()
            
            do {
                let contents : NSArray! = try fileMgr.contentsOfDirectoryAtPath(imgFolderPath)
                
                let files : NSMutableArray = NSMutableArray(array: contents)
                
                while (files.count > 0) {
                    let path : String = files.objectAtIndex(0) as! String
                    
                    var isJpeg = false
                    var isBarcode = false
                    var isQRcode = false
                    
                    if #available(iOS 9.0, *) {
                        isJpeg = path.localizedStandardContainsString(".jpg")
                        isBarcode = path.localizedStandardContainsString("_BARCODE")
                        isQRcode = path.localizedStandardContainsString("_QRCODE")
                    } else {
                        isJpeg = path.rangeOfString(".jpg") != nil
                        isBarcode = path.rangeOfString("_BARCODE") != nil
                        isQRcode = path.rangeOfString("_QRCODE") != nil
                    }
                    
                    if (isJpeg || isBarcode || isQRcode) {
                        let fullPath = documentsDirectory + path
                        do {
                            try fileMgr.removeItemAtPath(fullPath)
                        }
                    }
                    
                    files.removeObject(path)
                }
            }
            catch {
                
            }
            
            // Update UI in main queue
            dispatch_async(dispatch_get_main_queue(), {
                if ((completion) != nil) {
                    completion();
                }
            });
        });
    }
    
    func ClearQueue () {
//        let manager = ImageManager.Instance
        
        //        for key in manager.targets {
        //            var key = target as FPURLImageView
        //            if manager.currentDownloadStack.containsObject(key) {
        //                manager.targets.removeObjectForKey(key)
        //                manager.targetsQueue.removeObjectForKey(key)
        //            }
        //        }
    }
    
    //    required override init() {
    //        super.init()
    //        self.currentDownloadStack = NSMutableArray.alloc()
    //        self.targetsQueue = NSMutableDictionary.alloc()
    //        self.targets = NSMutableDictionary.alloc()
    //    }
    
    
    func ImageFromFileWithURL(url : String) -> UIImage! {
        // Get filename
        let filename : String = (NSURL(fileURLWithPath: url).URLByDeletingPathExtension?.lastPathComponent)! + SCALED_DOWN_IMAGE_FILENAME
        let pathArr : NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let imgFolderPath = "\(pathArr.objectAtIndex(0))/images/"
        let path = "\(imgFolderPath)\(filename)"
        
        // If File exists in documents
        if NSFileManager.defaultManager().fileExistsAtPath(path as String) {
            let image : UIImage = UIImage(contentsOfFile: path as String)!
            return image
        }
        return nil
    }
    
    func imageWithURL (url : String?, thumbnail : Bool, newTargets : NSArray, completion: (((image : UIImage, fromFile : Bool) -> Void)!)) {
        // URL
        if url == nil || url?.characters.count == 0 {
            return
        }
        
        // Remove target from other URL receivers
        for target in newTargets {
            removeTarget(target)
        }
        
        // If File exists in documents
        // Get filename
        let urlObject = NSURL(fileURLWithPath: url!)
        let filename  : String = !thumbnail ? urlObject.lastPathComponent! : (urlObject.URLByDeletingPathExtension?.lastPathComponent)! + SCALED_DOWN_IMAGE_FILENAME
        let pathArr : Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let imgFolderPath = "\(pathArr[0])/images/"
        let path = "\(imgFolderPath)\(filename)"
        
        if  NSFileManager.defaultManager().fileExistsAtPath(path) {
            let image : UIImage! = UIImage(contentsOfFile:path)
            
            if (completion != nil) {
                completion(image: image, fromFile: true);
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if image != nil {
                    for target in newTargets {
                        if target.respondsToSelector(#selector(FPURLImageView.update(_:))) {
                            dispatch_async(dispatch_get_main_queue(), {
                                let urlImageView = target as! FPURLImageView
                                urlImageView.update(image)
                            })
                        }
                    }
                }
            })
            
        }
            // If File does NOT exist in documents, download
        else {
            dispatch_async(dispatch_get_main_queue(), {
                // Add to Download in Main Queue
                if self.currentDownloadStack.count >= QUEUE_COUNT {
                    // Add target to dictionary
                    if var targets = self.targetsQueue.objectForKey(url!) as? NSMutableArray {
                        targets = NSMutableArray(capacity:0)
                        if url != nil {
                            self.targetsQueue.setObject(targets, forKey: url!)
                        }
                        
                        targets.addObjectsFromArray(newTargets as [AnyObject])
                    }
                }
                else {
                    // Add target to dictionary
                    var targets = self.targets.objectForKey(url!) as? NSMutableArray
                    if targets == nil {
                        targets = NSMutableArray(capacity:0)
                        if url != nil {
                            self.targets.setValue(targets, forKey: url! as String)
                        }
                        
                        targets?.addObjectsFromArray(newTargets as [AnyObject])
                    }
                    
                    // Don't download if duplicate request is in queue, just add as a target
                    if self.currentDownloadStack.containsObject(url!) {
                        return
                    }
                    
                    // Add URL to current download list
                    if url != nil {
                        self.currentDownloadStack.addObject(url!)
                    }
                    
                    // Download
                    let urlObject: NSURL = NSURL(string: url! as String)!
                    let request: NSURLRequest = NSURLRequest(URL: urlObject)
                    let queue:NSOperationQueue = NSOperationQueue()
                    
                    NSURLConnection.sendAsynchronousRequest(request,
                        queue: queue,
                        completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                            if data != nil {
                                // Save Image in separate queue
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                                    // Save Actual Size
                                    let image = UIImage(data: data!)!
                                    
                                    var isDir : ObjCBool = true
                                    let fileManager = NSFileManager.defaultManager()
                                    if !fileManager.fileExistsAtPath(imgFolderPath, isDirectory:&isDir)  {
                                        var error : NSError?
                                        do {
                                            try fileManager.createDirectoryAtPath(imgFolderPath, withIntermediateDirectories: true, attributes: nil)
                                        } catch let error1 as NSError {
                                            error = error1
                                        } catch {
                                            fatalError()
                                        }
                                    }
                                    
                                    if (!thumbnail) {
                                        // Save Image to Documents
                                        let filename = NSURL(string: url!)!.lastPathComponent
                                        
                                        let pathArr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                                        let documentsDirectory = pathArr.first! as String
                                        let imgFolderPath = documentsDirectory + "/images/"
                                        let path = imgFolderPath + filename!
                                        let imageData : NSData = UIImageJPEGRepresentation(image, 0.8)!
                                        imageData.writeToFile(path, atomically: true)
                                    }
                                    
                                    var scaledDownImage : UIImage!
                                    if (thumbnail) {
                                        if (thumbnail) {
                                            scaledDownImage = image.scaleToWidth(SCALED_DOWN_IMAGE_WIDTH)
                                        }
                                        else {
                                            scaledDownImage = image.scaleToWidth(640.0)
                                        }
                                        
                                        let urlObject = NSURL(fileURLWithPath: url!)
                                        let scaledDownImageFileName : String = (urlObject.URLByDeletingPathExtension?.lastPathComponent)! + SCALED_DOWN_IMAGE_FILENAME
                                        let scaledDownImagePath : String = "\(imgFolderPath)\(scaledDownImageFileName)"
                                        let scaledDownImageData = UIImageJPEGRepresentation(scaledDownImage, 0.8)
                                        scaledDownImageData!.writeToFile(scaledDownImagePath, atomically: true)
                                    }
                                    
                                    // Update UI in main queue
                                    dispatch_async(dispatch_get_main_queue(), {
                                        var currentURL: String? = url
                                        if currentURL?.characters.count == 0 {
                                            if self.currentDownloadStack.count > 0 {
                                                currentURL = self.currentDownloadStack[0] as? String
                                            }
                                        }
                                        
                                        if let targets = self.targets.objectForKey(currentURL!) as? NSMutableArray {
                                            for target in targets {
                                                if target.respondsToSelector(#selector(FPURLImageView.update(_:))) {
                                                    let urlImageView = target as! FPURLImageView
                                                    urlImageView.update(thumbnail ? scaledDownImage : image)
                                                }
                                            }
                                            
                                            // Remove Targets
                                            self.targets.removeObjectForKey(currentURL!)
                                            self.currentDownloadStack.removeObject(currentURL!)
                                        }
                                        
                                        // Process Next
                                        if self.targetsQueue.count > 0 {
                                            let nextURL: String = self.targetsQueue.allKeys[0] as! String
                                            let nextTargets = self.targetsQueue.objectForKey(nextURL) as! NSArray
                                            
                                            self.targetsQueue.removeObjectForKey(nextURL)
                                            self.imageWithURL(nextURL,
                                                thumbnail: thumbnail,
                                                newTargets: nextTargets)
                                        }
                                        
                                        if completion != nil {
                                            completion(image: image, fromFile: false)
                                        }
                                    })
                                })
                            }
                    })
                }
            })
        }
    }
    
    func imageWithURL(url : String, thumbnail : Bool, newTargets : NSArray) {
        self.imageWithURL(url, thumbnail: thumbnail, newTargets: newTargets, completion: nil)
    }
    
    func removeTarget(target : AnyObject) {
        // Remove from current download list
        let keysToRemove : NSMutableArray = NSMutableArray(capacity: 0)
        
        if self.targets != nil && self.targets.count > 0 {
            targets.enumerateKeysAndObjectsUsingBlock { (key : AnyObject!, obj : AnyObject!, stop : UnsafeMutablePointer) -> Void in
                let targets : NSMutableArray = obj as! NSMutableArray
                if targets.containsObject(target) {
                    targets.removeObject(target)
                }
                if targets.count == 0 {
                    keysToRemove.addObject(key)
                }
            }
            self.targets.removeObjectsForKeys(keysToRemove as [AnyObject])
        }
        
        if self.targetsQueue != nil && self.targetsQueue.count > 0 {
            self.targetsQueue.enumerateKeysAndObjectsUsingBlock { (key : AnyObject!, obj : AnyObject!, stop : UnsafeMutablePointer) -> Void in
                let targets : NSMutableArray = obj as! NSMutableArray
                if targets.containsObject(target) {
                    targets.removeObject(target)
                }
            }
        }
    }
}



typealias CompletionBlock = (imageView: FPURLImageView, fromFile: Bool) -> Void

class FPURLImageView: UIImageView {
//    var activityIndicator : UIActivityIndicatorView!
    var currentURL : String?
    
    var imageIsFromFile : Bool = false
//    var activityIndicatorContainer : UIView!
    var completionBlock : CompletionBlock!
    var loadingViewColor : LoadingViewColor = LoadingViewColor.White
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup () {
//        if activityIndicatorContainer == nil {
//            activityIndicatorContainer = UIView(frame:CGRectMake(0.0, 0.0, 60.0, 60.0))
//            activityIndicatorContainer.backgroundColor = UIColor.clearColor()
//            activityIndicatorContainer.center = CGPointMake(frame.size.width / 2.0,
//                (frame.size.height / 2.0) - TOP_BUFFER);
//            activityIndicatorContainer.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin
//            addSubview(activityIndicatorContainer)
//            
//            activityIndicator =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//            activityIndicator.hidesWhenStopped = true;
//            activityIndicator.center = CGPointMake(activityIndicatorContainer.frame.size.width / 2.0, activityIndicatorContainer.frame.size.height / 2.0)
//            activityIndicatorContainer.addSubview(activityIndicator)
//        }
    }
    
    func clear () {
        ImageManager.Instance.removeTarget(self)
        
        self.currentURL = nil
        self.image = UIImage(named: DEFAULT_IMAGE as String)
    }
    
    func setImageWithURL (url: String, thumbnail: Bool, completion:((imageView: FPURLImageView, fromFile: Bool)->Void)!) {
        // If same URL, don't download
        if self.currentURL != nil && self.currentURL == url && self.image == nil {
            return
        }
        
        self.completionBlock = completion
        
        // Set current URL
        self.currentURL = url
        
        // Show Download Indicator
//        self.activityIndicator.startAnimating()
//        self.activityIndicatorContainer.hidden = false
//        
//        
//        if url.isEqualToString("") {
//            self.activityIndicator.stopAnimating()
//            self.activityIndicatorContainer.hidden = true
//        }
        
        // Download or get from documents
        ImageManager.Instance.imageWithURL(url,
            thumbnail: thumbnail,
            newTargets: [self]) { (image, fromFile) -> Void in
                self.imageIsFromFile = fromFile
        }
    }
    
    func setImageWithURL (url: String, completion:((imageView: FPURLImageView!, fromFile: Bool)->Void)!) {
        self.setImageWithURL(url,
            thumbnail: false,
            completion: completion)
    }
    
    func update (image: UIImage!) {
        var imageToSet: UIImage! = image

        if imageToSet == nil {
            imageToSet = UIImage(named: DEFAULT_IMAGE as String)
        }
        
//        self.activityIndicator.stopAnimating()
//        self.activityIndicatorContainer.hidden = true
        
        self.image = imageToSet
        
        if self.completionBlock != nil {
            self.completionBlock(imageView: self, fromFile:self.imageIsFromFile)
            self.completionBlock = nil
        }
    }
    
    func setLoadingViewColor (loadingViewColorValue: LoadingViewColor) {
        loadingViewColor = loadingViewColorValue
        
//        if self.loadingViewColor == LoadingViewColor.Black {
//            self.activityIndicatorContainer.backgroundColor = UIColor(white: 0.0, alpha:0.6)
//            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
//        }
//        else if self.loadingViewColor == LoadingViewColor.White {
//            self.activityIndicatorContainer.backgroundColor = UIColor(white: 1.0, alpha:0.2)
//            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
//        }
    }
}
