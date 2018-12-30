//
//  TranslationViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/16.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController, VisionAPI {
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var image: UIImage?
    var features: Array<[String : Any]> = [
        [
            "type": "TEXT_DETECTION",
            "maxResults": 10
        ]
    ]
    var session: URLSession = URLSession.shared
    weak var dataTask: URLSessionDataTask?
    
    private weak var imageView: UIImageView!
    private weak var arrowView: UIImageView!
    
    weak var translatingButton: UIBarButtonItem!
    weak var sourceTextView: TranslationTextView!
    weak var translationTextView: TranslationTextView!
    var locale: String?
    var sourceText: String? {
        didSet {
            if let sourceTextView = self.sourceTextView {
                sourceTextView.textView.text = sourceText
            }
        }
    }
    var data: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = backgroundLightColor
        self.title = "translation_navigation_title".localized()
        let translatingBarButtonItem = UIBarButtonItem(title: "translate_navigation_title".localized(), style: .plain, target: self, action: #selector(handleTranslate))
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popToRoot)), translatingBarButtonItem]
        self.translatingButton = translatingBarButtonItem
        
        self.imageView = self.view.imageView(frame: CGRect.zero)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = self.image
        self.imageView.backgroundColor = UIColor.black
        self.arrowView = self.view.imageView(frame: CGRect.zero)
        self.arrowView.image = UIImage(named: "image_translating_arrow")
        
        let sourceTextView = TranslationTextView()
        sourceTextView.translatesAutoresizingMaskIntoConstraints = false
        sourceTextView.textView.text = self.sourceText
        self.view.addSubview(sourceTextView)
        self.sourceTextView = sourceTextView
        
        let translationTextView = TranslationTextView()
        translationTextView.textView.isEditable = false
        translationTextView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(translationTextView)
        self.translationTextView = translationTextView
        
        setupConstraints()
        
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        if let dataToParse = self.data {
            self.translateResults(dataToParse)
        } else {
            self.analyze()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let task = self.dataTask {
            task.cancel()
        }
    }
    
    @objc func handleTranslate() {
        self.sourceTextView.textView.endEditing(true)
        let text: String? = self.sourceTextView.textView.text
        guard let sourceText = self.sourceText else {
            if let text = text {
                self.sourceText = text
                self.translate()
            }
            return
        }
        if sourceText != text {
            self.sourceText = text
            self.translate()
        }
    }
    
    private func setupConstraints() {
        var margins = self.view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            margins = self.view.safeAreaLayoutGuide
        }
        self.imageView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 9 / 16.0).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.imageView.topAnchor.constraint(greaterThanOrEqualTo: margins.topAnchor).isActive = true
        
        self.translationTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: marginDefault).isActive = true
        self.translationTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -marginDefault).isActive = true
        self.translationTextView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor, constant: -marginDefault).isActive = true
        self.translationTextView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1 / 3.0).isActive = true
        
        self.arrowView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.arrowView.bottomAnchor.constraint(equalTo: self.translationTextView.topAnchor, constant: -marginInner).isActive = true
        self.arrowView.widthAnchor.constraint(equalToConstant: 26).isActive = true
        self.arrowView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        self.sourceTextView.leadingAnchor.constraint(equalTo: self.translationTextView.leadingAnchor).isActive = true
//        self.sourceTextView.topAnchor.constraint(greaterThanOrEqualTo: margins.topAnchor, constant: marginDefault).isActive = true
        self.sourceTextView.trailingAnchor.constraint(equalTo: self.translationTextView.trailingAnchor).isActive = true
        self.sourceTextView.bottomAnchor.constraint(equalTo: self.arrowView.topAnchor, constant: -marginInner).isActive = true
        self.sourceTextView.heightAnchor.constraint(equalTo: self.translationTextView.heightAnchor).isActive = true
    }
}
