//
//  TranslationViewController+Translate.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/22.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

extension TranslationViewController {
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
                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get text annotations
                let textAnnotations: JSON = responses["textAnnotations"]
                if let annotations = textAnnotations.array, annotations.count > 0 {
                    self.locale = textAnnotations[0]["locale"].string
                    self.sourceText = textAnnotations[0]["description"].string
                    
                    self.translate()
                }
            }
        }
    }
    
    
    func analyzeError(_ error: Error) {
        print("translate error:", error.localizedDescription)
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}

private let googleAPIKey = "YOUR API KEY"
private var googleURL: URL {
    return URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(googleAPIKey)")!
}
extension TranslationViewController {
    // MARK: - Networking
    func translate() {
        self.spinner.startAnimating()
        // Create our request URL
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "q": self.sourceText,
            "target": Locale.userDefaultLocale().languageCode
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
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                let data = json["data"]
                let translations = data["translations"]
                if let results = translations.array, results.count > 0 {
                    self.translationTextView.textView.text = results[0]["translatedText"].string
                    if self.data == nil {
                        // cache the data
                        json["sourceText"] = JSON(self.sourceText!)
                        self.cache(json, root: DashboardViewController.historyURL())
                    }
                }
            }
        }
    }
}
