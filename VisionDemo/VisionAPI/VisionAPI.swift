//
//  VisionAPI.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/22.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

private let googleAPIKey = "YOUR API KEY"
private var googleURL: URL {
    return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
}

protocol VisionAPI {
    var spinner: UIActivityIndicatorView { get set }
    var image: UIImage? { get set }
    var features: Array <[String: Any]> { get }
    var session: URLSession { get }
    func analyze()
    func analyzeResults(_ dataToParse: Data)
    func cache(_ json: JSON, root url:URL)
    func analyzeError(_ error: Error)
    func setDataTask(_ task: URLSessionDataTask)
}

extension VisionAPI {
    func analyze() {
        self.spinner.startAnimating()
        if let image = self.image {
            let binaryImageData = image.base64Encoded()
            createRequest(with: binaryImageData)
        }
    }
    
    func cache(_ json: JSON, root url:URL) {
        print(url, "cache", json)
        if let raw = json.rawString() {
            let uuid = UUID().uuidString
            do {
                try raw.write(to: url.appendingPathComponent("\(uuid).plist"), atomically: true, encoding: .utf8)
            } catch {
                
            }
            
            do {
                var size = CGSize(width: 400, height: 300)
                if let image = self.image {
                    size.height = image.size.height / image.size.width * 400
                }
                try self.image?.resizedImageData(with: size).write(to: url.appendingPathComponent("images/\(uuid).jpeg"))
            } catch {
                
            }
        }
    }

    // MARK: - Networking
    func createRequest(with imageBase64: String) {
        // Create our request URL
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": self.features
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global(qos: .background).async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                self.analyzeError(error!)
                return
            }
            self.analyzeResults(data)
        }
        task.resume()
        self.setDataTask(task)
    }
}

extension UIImage {
    func resizedImageData(with size: CGSize) -> Data {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.jpegData(compressionQuality: 1)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64Encoded() -> String {
        var imagedata = self.jpegData(compressionQuality: 1)
        
        // Resize the image if it exceeds the 2MB API limit
        if let data = imagedata, data.count > 2097152 {
            let oldSize: CGSize = self.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = self.resizedImageData(with: newSize)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}
