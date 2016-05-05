//
//  WebServices.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

var CCFDetailsURL: String = "http://www.ccfsingapore.org/wp-content/uploads/CCFDetails.txt"
var EventsURL: String = "http://www.ccfsingapore.org/wp-content/uploads/Events.txt"
var MinistriesURL: String = "http://www.ccfsingapore.org/wp-content/uploads/Ministry.txt"
var DGroupsURL: String = "http://www.ccfsingapore.org/wp-content/uploads/DGroup.txt"
var ResourcesURL: String = "http://www.ccfsingapore.org/wp-content/uploads/Resources.txt"

var VimeoURL: String = "http://vimeo.com/api/v2/user7006079/"
var VimeoEndpoint: String = "videos.json"

private let _WebServicesSharedInstance = WebServices()

class WebServices: NSObject {
    
    class var sharedInstance : WebServices {
        return _WebServicesSharedInstance
    }
    
    func ccfdetails (completion : ((CCFDetail!) -> Void)!) {
        let url: NSURL! = NSURL(string: CCFDetailsURL as String)
        let request: NSURLRequest = NSURLRequest(URL:url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: queue,
                                                completionHandler:{ response, data, error in
                                                    var detail: CCFDetail!
                                                    
                                                    if data != nil {
                                                        let json: JSON?
                                                        do {
                                                            json = try NSJSONSerialization.JSONObjectWithData(data!,
                                                                options: [.AllowFragments, .MutableContainers])
                                                        } catch let _ as NSError {
                                                            json = nil
                                                        } catch {
                                                            fatalError()
                                                        }
                                                        
                                                        if let jsonDictionary = json as? JSONDictionary {
                                                            detail = CCFDetail()
                                                            detail.setData(jsonDictionary)
                                                        }
                                                    }
                                                    
                                                    if detail != nil {
                                                        completion(detail)
                                                    }
                                                    else {
                                                        completion(nil)
                                                    }
        })
    }
    
    func eventsList (completion : ((Section!, NSArray!) -> Void)!) {
        let url: NSURL! = NSURL(string: EventsURL as String)
        let request: NSURLRequest = NSURLRequest(URL:url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: queue,
                                                completionHandler:{ response, data, error in
                                                    let section = Section()
                                                    let array = NSMutableArray(capacity:0)
                                                    
                                                    if data != nil {
                                                        var jsonErrorOptional: NSError?
                                                        let json: JSON?
                                                        do {
                                                            json = try NSJSONSerialization.JSONObjectWithData(data!,
                                                                options: [.AllowFragments, .MutableContainers])
                                                        } catch let error as NSError {
                                                            jsonErrorOptional = error
                                                            json = nil
                                                        } catch {
                                                            fatalError()
                                                        }
                                                        
                                                        if let jsonDictionary = json as? JSONDictionary {
                                                            section.setData(jsonDictionary)
                                                            
                                                            if let jsonArray = jsonDictionary["data"] as? JSONArray {
                                                                for json in jsonArray {
                                                                    if let itemDictionary = json as? JSONDictionary {
                                                                        let obj = Event()
                                                                        obj.setData(itemDictionary)
                                                                        array.addObject(obj)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if array.count > 0 {
                                                        completion(section, array)
                                                    }
                                                    else {
                                                        completion(nil, nil)
                                                    }
        })
    }
    
    func ministryList (completion : ((Section!, NSArray!) -> Void)!) {
        let url: NSURL! = NSURL(string: MinistriesURL as String)
        let request: NSURLRequest = NSURLRequest(URL:url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: queue,
                                                completionHandler:{ response, data, error in
                                                    let section = Section()
                                                    let array = NSMutableArray(capacity:0)
                                                    
                                                    if data != nil {
                                                        var jsonErrorOptional: NSError?
                                                        let json: JSON?
                                                        do {
                                                            json = try NSJSONSerialization.JSONObjectWithData(data!,
                                                                options: [.AllowFragments, .MutableContainers])
                                                        } catch let error as NSError {
                                                            jsonErrorOptional = error
                                                            json = nil
                                                        } catch {
                                                            fatalError()
                                                        }
                                                        
                                                        if let jsonDictionary = json as? JSONDictionary {
                                                            section.setData(jsonDictionary)
                                                            
                                                            if let jsonArray = jsonDictionary["data"] as? JSONArray {
                                                                for json in jsonArray {
                                                                    if let itemDictionary = json as? JSONDictionary {
                                                                        let obj = Ministry()
                                                                        obj.setData(itemDictionary)
                                                                        array.addObject(obj)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if array.count > 0 {
                                                        completion(section, array)
                                                    }
                                                    else {
                                                        completion(nil, nil)
                                                    }
        })
    }
    
    func resourcesList (completion : ((Section!, NSArray!) -> Void)!) {
        let url: NSURL! = NSURL(string: ResourcesURL as String)
        let request: NSURLRequest = NSURLRequest(URL:url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: queue,
                                                completionHandler:{ response, data, error in
                                                    let section = Section()
                                                    let array = NSMutableArray(capacity:0)
                                                    
                                                    if data != nil {
                                                        let json: JSON?
                                                        do {
                                                            json = try NSJSONSerialization.JSONObjectWithData(data!,
                                                                options: [.AllowFragments, .MutableContainers])
                                                        } catch let error as NSError {
                                                            json = nil
                                                        } catch {
                                                            fatalError()
                                                        }
                                                        
                                                        if let jsonDictionary = json as? JSONDictionary {
                                                            section.setData(jsonDictionary)
                                                            
                                                            if let jsonArray = jsonDictionary["data"] as? JSONArray {
                                                                for json in jsonArray {
                                                                    if let itemDictionary = json as? JSONDictionary {
                                                                        let obj = Resource()
                                                                        obj.setData(itemDictionary)
                                                                        array.addObject(obj)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if array.count > 0 {
                                                        completion(section, array)
                                                    }
                                                    else {
                                                        completion(nil, nil)
                                                    }
        })
    }
    
    func dgrouplist (completion : ((Section!, NSArray!) -> Void)!) {
        let url: NSURL! = NSURL(string: DGroupsURL as String)
        let request: NSURLRequest = NSURLRequest(URL:url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: queue,
                                                completionHandler:{ response, data, error in
                                                    let section = Section()
                                                    let array = NSMutableArray(capacity:0)
                                                    
                                                    if data != nil {
                                                        var jsonErrorOptional: NSError?
                                                        let json: JSON?
                                                        do {
                                                            json = try NSJSONSerialization.JSONObjectWithData(data!,
                                                                options: [.AllowFragments, .MutableContainers])
                                                        } catch var error as NSError {
                                                            jsonErrorOptional = error
                                                            json = nil
                                                        } catch {
                                                            fatalError()
                                                        }
                                                        
                                                        if let jsonDictionary = json as? JSONDictionary {
                                                            section.setData(jsonDictionary)
                                                            
                                                            if let jsonArray = jsonDictionary["data"] as? JSONArray {
                                                                for json in jsonArray {
                                                                    if let obj = json as? JSONDictionary {
                                                                        let dggroup = DGGroup()
                                                                        dggroup.setData(obj as NSDictionary)
                                                                        array.addObject(dggroup)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if array.count > 0 {
                                                        completion(section, array)
                                                    }
                                                    else {
                                                        completion(nil, nil)
                                                    }
        })
    }
    
    func videoArchives (completion : ((NSArray?) -> Void)?) {
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: VimeoURL))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        
        manager.GET(VimeoEndpoint,
                    parameters: [],
                    success: { op, data in
                        do {
                            let jsonOptional = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions(rawValue: 0))
                            
                            let array = NSMutableArray(capacity:0)
                            if let jsonArray = jsonOptional as? JSONArray {
                                for json in jsonArray {
                                    let jsonDictionary: JSONDictionary! = json as! JSONDictionary
                                    let video = VimeoVideo()
                                    video.setData(jsonDictionary)
                                    array.addObject(video)
                                }
                            }
                            
                            if array.count > 0 {
                                completion?(array)
                            }
                            else {
                                completion?(nil)
                            }
                        }
                        catch {
                            completion?(nil)
                        }
            },
                    failure: { op, error in
                        completion?(nil)
        })
    }
}
