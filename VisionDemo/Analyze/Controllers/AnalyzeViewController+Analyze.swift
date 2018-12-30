//
//  AnalyzeViewController+Analyze.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/18.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

/// Image processing

extension AnalyzeViewController {
    func setDataTask(_ task: URLSessionDataTask) {
        self.dataTask = task
    }

    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            
            let json = JSON(dataToParse)
            
            let errorObj: JSON = json["error"]
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                var responses: JSON = json["responses"][0]
                print("responses", responses)
                if self.data == nil {
                    responses = self.uniqueDetections(json: responses)
                }
                self.annotations.removeAll()
                // Get landmark annotations
                let landmarkAnnotations: JSON = responses["landmarkAnnotations"]
                self.parseAnnotations(landmarkAnnotations)
                
                // Get web annotations
                let webAnnotations: JSON = responses["webDetection"]["webEntities"]
                self.parseAnnotations(webAnnotations, detection: .web)
                
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                self.parseAnnotations(labelAnnotations)
               
                if self.data == nil {
                    self.uniqueDetections = responses
                    self.translate()
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func analyzeError(_ error: Error) {
        print("analyze error:", error.localizedDescription)
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            let alertController = UIAlertController(title: "Error".localized(), message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "analyze_navigation_title".localized(), style: .default, handler: { (_) in
                self.analyze()
            }))
            alertController.addAction(UIAlertAction(title: "Back".localized(), style: .cancel, handler: { (_) in
                if let nc = self.navigationController {
                    nc.popViewController(animated: true)
                }
            }))
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func uniqueDetections(json: JSON) -> JSON {
        var uniqueDescriptions = Set<String>()
        var uniqueLandmarks = [JSON]()
        let landmarks: JSON = json["landmarkAnnotations"]
        for (_, subJson):(String, JSON) in landmarks {
            if let description = subJson["description"].string?.lowercased(), !uniqueDescriptions.contains(description) {
                uniqueDescriptions.insert(description)
                uniqueLandmarks.append(subJson)
            }
        }
        
        var uniqueWebEntities = [JSON]()
        let webEntities = json["webDetection"]["webEntities"]
        for (_, subJson):(String, JSON) in webEntities {
            if let description = subJson["description"].string?.lowercased(), !uniqueDescriptions.contains(description) {
                uniqueDescriptions.insert(description)
                uniqueWebEntities.append(subJson)
            }
        }
        
        var uniqueLabels = [JSON]()
        let labels = json["labelAnnotations"]
        for (_, subJson):(String, JSON) in labels {
            if let description = subJson["description"].string?.lowercased(), !uniqueDescriptions.contains(description) {
                uniqueDescriptions.insert(description)
                uniqueLabels.append(subJson)
            }
        }
        
        return JSON(
            [
                "landmarkAnnotations": uniqueLandmarks,
                "webDetection": [
                    "webEntities": uniqueWebEntities
                ],
                "labelAnnotations": uniqueLabels
            ]
        )
    }
    
    private func parseAnnotations(_ annotations: JSON, detection: Annotation.Detection? = nil) {
        for (index, subJson):(String, JSON) in annotations {
            if let label = subJson.dictionaryObject, var annotation = Annotation(json: label) {
                if let detection = detection {
                    annotation.detection = detection
                }
                annotation.index = Int(index)
                self.annotations.append(annotation)
            }
        }
    }
}

private let googleAPIKey = "YOUR API KEY"
private var googleURL: URL {
    return URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(googleAPIKey)")!
}
extension AnalyzeViewController {
    // MARK: - Networking
    func translate() {
        self.spinner.startAnimating()
        // Create our request URL
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        var sourceTexts: Array<String> = []
        self.annotations.forEach { (annotation) in
            sourceTexts.append(annotation.description)
        }
        let jsonRequest = [
            "q": sourceTexts,
            "target": Locale.userDefaultLocale().languageCode as Any
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global(qos: .background).async { self.runTranslateRequestOnBackgroundThread(request) }
    }
    
    func runTranslateRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error: ", error?.localizedDescription ?? "")
                self.analyzeError(error!)
                return
            }
            self.translateResults(data)
        }
        task.resume()
        self.setDataTask(task)
    }
    
    func translateResults(_ dataToParse: Data) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            var json = JSON(dataToParse)
            let errorObj: JSON = json["error"]
            print(json)
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                let data = json["data"]
                let translations = data["translations"]
                for (index, subJson):(String, JSON) in translations {
                    if let index = Int(index), let translatedText = subJson["translatedText"].string {
                        var annotation = self.annotations[index]
                        annotation.localized = translatedText
                        self.annotations[index] = annotation
                        
                        // update the json
                        if let index = annotation.index {
                            switch annotation.detection {
                            case .label:
                                self.uniqueDetections?["labelAnnotations"][index]["localized"] = JSON(translatedText)
                                break
                            case .web:
                                self.uniqueDetections?["webDetection"]["webEntities"][index]["localized"] = JSON(translatedText)
                                break
                            case .landmark:
                                self.uniqueDetections?["landmarkAnnotations"][index]["localized"] = JSON(translatedText)
                                break
                            }
                        }
                    }
                }
                if let json = self.uniqueDetections {
                    self.cache(JSON(["responses":[json]]), root: DashboardViewController.historyURL())
                }
                self.tableView.reloadData()
            }
        }
    }
}
