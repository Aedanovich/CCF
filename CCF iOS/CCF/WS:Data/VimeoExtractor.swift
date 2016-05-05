//
//  VimeoExtractor.swift
//  CCF
//
//  Created by Alex on 18/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

let YTVimeoPlayerConfigURLPrefix: String = "http://player.vimeo.com/video/"
let YTVimeoPlayerConfigURLSuffix: String = "/config"
let YTVimeoExtractorErrorDomain: String = "YTVimeoExtractorErrorDomain"

enum YTVimeoExtractorError {
    case CodeNotInitialized
    case InvalidIdentifier
    case UnsupportedCodec
    case UnavailableQuality
}

enum YTVimeoVideoQuality : NSInteger {
    case Low
    case Medium
    case High
}

typealias CompletionHandler =  (videoURL: [String : String]?) -> Void


class VimeoExtractor: NSObject, NSURLConnectionDelegate {
    var completionHandler: CompletionHandler!
    var running: Bool = false
    var quality: YTVimeoVideoQuality = .Medium
    var referer: String?
    var vimeoURL: NSURL!

    var connection: NSURLConnection!
    var buffer: NSMutableData!

    class func fetchVideoURLFromURL(videoURL: String, quality:YTVimeoVideoQuality, referer:String?, completionHandler: CompletionHandler) {
        let extractor: VimeoExtractor = VimeoExtractor().initWithURL(videoURL,
            qualityValue: quality,
            refererValue: referer)
        extractor.completionHandler = completionHandler
        extractor.start()
    }
    
    class func fetchVideoURLFromID(videoID: String, quality: YTVimeoVideoQuality, referer: String?, completionHandler: CompletionHandler) {
        let extractor: VimeoExtractor = VimeoExtractor().initWithID(videoID,
            qualityValue: quality,
            refererValue: referer)
        extractor.completionHandler = completionHandler
        extractor.start()
    }
    
    class func fetchVideoURLFromURL(videoURL: String, quality: YTVimeoVideoQuality, completionHandler: CompletionHandler) {
        return VimeoExtractor.fetchVideoURLFromURL(videoURL,
            quality: quality,
            referer: nil,
            completionHandler: completionHandler)
    }
    
    class func fetchVideoURLFromID(videoID: String, quality: YTVimeoVideoQuality, completionHandler: CompletionHandler) {
        return VimeoExtractor.fetchVideoURLFromID(videoID,
            quality: quality,
            referer: nil,
            completionHandler: completionHandler)
    }
    
    func initWithID(videoID: String, qualityValue: YTVimeoVideoQuality, refererValue: String?) -> VimeoExtractor {
        let urlString = "\(YTVimeoPlayerConfigURLPrefix)\(videoID)\(YTVimeoPlayerConfigURLSuffix)"
        vimeoURL = NSURL(string: urlString)
        quality = qualityValue
        referer = refererValue
        running = false
        return self
    }
    
    func initWithURL(videoURL: String, qualityValue: YTVimeoVideoQuality, refererValue: String?) -> VimeoExtractor {
        let videoID = videoURL.componentsSeparatedByString("/").last
        return initWithID(videoID!, qualityValue: quality, refererValue: referer)
    }
    
    func initWithID(videoID: String, quality: YTVimeoVideoQuality) -> VimeoExtractor {
        return initWithID(videoID, qualityValue: quality, refererValue: nil)
    }
    
    func initWithURL(videoURL: String, qualityValue: YTVimeoVideoQuality) -> VimeoExtractor {
        return initWithURL(videoURL, qualityValue: qualityValue, refererValue: nil)
    }
    
    func start() {
        if completionHandler == nil || vimeoURL == nil {
            return
        }
        
        let url = vimeoURL
        let queue: NSOperationQueue = NSOperationQueue()
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request,
            queue: queue,
            completionHandler: { response, data, error in
                if data != nil {
                    var jsonErrorOptional: NSError?
                    let jsonOptional: JSON!
                    do {
                        jsonOptional = try NSJSONSerialization.JSONObjectWithData(data!,
                                                options: NSJSONReadingOptions(rawValue: 0))
                    } catch let error as NSError {
                        jsonErrorOptional = error
                        jsonOptional = nil
                    } catch {
                        fatalError()
                    }
                    
                    if let _ = jsonErrorOptional {
                        
                    }
                    else {
                        guard let jsonDictionary = jsonOptional as? JSONDictionary else {
                            self.completionHandler(videoURL: nil)
                            return
                        }

                        guard let requestInfo = jsonDictionary["request"] as? JSONDictionary else  {
                            self.completionHandler(videoURL: nil)
                            return
                        }

                        guard let filesInfo = requestInfo["files"] as? JSONDictionary else  {
                            self.completionHandler(videoURL: nil)
                            return
                        }

                        guard let progressive = filesInfo["progressive"] as? JSONArray else  {
                            self.completionHandler(videoURL: nil)
                            return
                        }
                        
                        var videoURLDict: [String:String] = [:]
                        for dict in progressive {
                            if let progressiveInfo = dict as? JSONDictionary {
                                if let qualityInfo = progressiveInfo["quality"] as? String {
                                    if let videoURLInfo = progressiveInfo["url"] as? String {
                                        videoURLDict[qualityInfo] = videoURLInfo
                                    }
                                }
                            }
                        }
                        
                        self.completionHandler(videoURL: videoURLDict)
                    }
                }
        })
    }
}