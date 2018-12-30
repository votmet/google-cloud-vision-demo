//
//  PhotoPreviewerController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/9.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

let AnalyzingCostPerTime = 1

private let kFreePoints = 3
private let kAnchorHeight: CGFloat = 44

// TODO: refactor the anchors code

class PhotoPreviewerController: UIViewController, DraggableViewDelegate {

    weak var backgroundImageView: UIImageView!
    weak var imageView: UIImageView!
    var currentWidthConstant: CGFloat!
    var currentRotation: CGFloat!
    
    private weak var imageHolderView: UIView!
    private weak var mask: UIView?
    
    private weak var topAnchor: DraggableView!
    private weak var rightAnchor: DraggableView!
    private weak var bottomAnchor: DraggableView!
    private weak var leftAnchor: DraggableView!
    private weak var topLeftAnchor: DraggableView!
    private weak var topRightAnchor: DraggableView!
    private weak var bottomLeftAnchor: DraggableView!
    private weak var bottomRightAnchor: DraggableView!
    private weak var centerAnchor: DraggableView!
    
    private var top: CGFloat! {
        didSet {
            self.updateMaskView()
        }
    }
    
    private var right: CGFloat! {
        didSet {
            self.updateMaskView()
        }
    }
    
    private var bottom: CGFloat! {
        didSet {
            self.updateMaskView()
        }
    }
    
    private var left: CGFloat! {
        didSet {
            self.updateMaskView()
        }
    }
    
    var image: UIImage?
    var dateKey: String!
    
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        
        self.dateKey = Date().stringUsedAsKey()
        self.refreshDate()
    }
    
    func refreshDate() {
        let dateApiTask = URLSession.shared.dataTask(with: URL(string: "https://www.google.com")!) { (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse, let dateString = response.allHeaderFields["Date"] as? String else {
                print("connect to world clock api failed")
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            if let key = dateFormatter.date(from: dateString)?.stringUsedAsKey() {
                self.dateKey = key
            }
        }
        dateApiTask.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "previewer_navigation_title".localized()
        self.view.backgroundColor = UIColor.black
        self.view.clipsToBounds = true
        
        self.currentRotation = 0
        self.backgroundImageView = self.view.imageView(frame: CGRect.zero)
        self.backgroundImageView.alpha = 0.5
        self.backgroundImageView.contentMode = .scaleAspectFit
        self.backgroundImageView.image = self.image
        self.currentWidthConstant = self.view.bounds.width
        var margins = self.view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            margins = self.view.safeAreaLayoutGuide
        }
        self.backgroundImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.backgroundImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -buttonHeightDefault / 2).isActive = true
        self.backgroundImageView.widthAnchor.constraint(equalToConstant: self.currentWidthConstant).isActive = true
        if let image = self.image {
            let multiplier = min(16 / 9.0, image.size.height / image.size.width)
            self.backgroundImageView.heightAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier:multiplier).isActive = true
        } else {
            self.backgroundImageView.heightAnchor.constraint(equalTo: margins.heightAnchor, constant: -buttonHeightDefault).isActive = true
        }
        
        let holderView = UIView()
        self.view.addSubview(holderView)
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        holderView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        holderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        holderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.imageHolderView = holderView
        
        self.imageView = holderView.imageView(frame: CGRect.zero)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = self.image
        self.imageView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.backgroundImageView.centerYAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.backgroundImageView.heightAnchor).isActive = true
        
        let translateButton = self.view.button(title: "previewer_translate_button".localized())
        translateButton.addTarget(self, action: #selector(translate), for: .touchUpInside)
        translateButton.backgroundColor = primaryColor
        translateButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5, constant: -1).isActive = true
        translateButton.heightAnchor.constraint(equalToConstant: buttonHeightDefault).isActive = true
        translateButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        translateButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        let analyzeButton = self.view.button(title: "previewer_analyze_button".localized())
        analyzeButton.addTarget(self, action: #selector(analyze), for: .touchUpInside)
        analyzeButton.backgroundColor = primaryColor
        analyzeButton.widthAnchor.constraint(equalTo: translateButton.widthAnchor).isActive = true
        analyzeButton.heightAnchor.constraint(equalToConstant: buttonHeightDefault).isActive = true
        analyzeButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        analyzeButton.bottomAnchor.constraint(equalTo: translateButton.bottomAnchor).isActive = true
        
        self.setupGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard self.mask == nil else {
            return
        }
        
        var maskWidth: CGFloat = 320
        var maskHeight: CGFloat = 320
        if let image = self.backgroundImageView.image {
            maskWidth = self.view.bounds.size.width
            maskHeight = image.size.height / image.size.width * maskWidth
        }
        maskHeight = min(maskHeight, self.view.bounds.maxY - self.view.layoutMargins.bottom - self.view.layoutMargins.top - buttonHeightDefault - kAnchorHeight)
        let center = self.backgroundImageView.center
        top = center.y - maskHeight / 2
        right = center.x + maskWidth / 2
        bottom = top + maskHeight
        left = right - maskWidth
        
        let topLeftPoint = CGPoint(x: left, y: top)
        let topRightPoint = CGPoint(x: right , y: top)
        let bottomLeftPoint = CGPoint(x: left , y: bottom)
        let bottomRightPoint = CGPoint(x: right , y: bottom)
        let topPoint = CGPoint(x: (right + left) / 2, y: top)
        let rightPoint = CGPoint(x: right, y: (bottom + top) / 2)
        let bottomPoint = CGPoint(x: topPoint.x, y: bottom)
        let leftPoint = CGPoint(x: left, y: rightPoint.y)
        
        self.topLeftAnchor = draggableView(center: topLeftPoint, width: kAnchorHeight, height: kAnchorHeight)
        
        self.topRightAnchor = draggableView(center: topRightPoint, width: kAnchorHeight, height: kAnchorHeight)
        
        self.bottomLeftAnchor = draggableView(center: bottomLeftPoint, width: kAnchorHeight, height: kAnchorHeight)
        
        self.bottomRightAnchor = draggableView(center: bottomRightPoint, width: kAnchorHeight, height: kAnchorHeight)
        
        self.topAnchor = draggableView(center: topPoint, width: maskWidth - kAnchorHeight, height: kAnchorHeight)
        self.topAnchor.xDraggable = false
        
        self.rightAnchor = draggableView(center: rightPoint, width: kAnchorHeight, height: maskHeight - kAnchorHeight)
        self.rightAnchor.yDraggable = false
        
        self.bottomAnchor = draggableView(center: bottomPoint, width: maskWidth - kAnchorHeight, height: kAnchorHeight)
        self.bottomAnchor.xDraggable = false
        
        self.leftAnchor = draggableView(center: leftPoint, width: kAnchorHeight, height: maskHeight - kAnchorHeight)
        self.leftAnchor.yDraggable = false
        
        self.centerAnchor = draggableView(center: center, width: right - left - kAnchorHeight, height: bottom - top - kAnchorHeight)
        self.centerAnchor.anchor.isHidden = true
        
        
        let mask = UIView(frame: CGRect(x: left, y: top, width: maskWidth, height: maskHeight))
        mask.backgroundColor = UIColor.white
        self.imageHolderView.mask = mask
        self.mask = mask
    }
    
    func draggableView(center: CGPoint, width: CGFloat, height: CGFloat) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        draggableView.center = center
        draggableView.delegate = self
        self.view.addSubview(draggableView)
        return draggableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc private func translate() {
        guard payPoints() else {
            return
        }
        let translationViewController = TranslationViewController()
        translationViewController.image = self.croppedImage() ?? self.image
        self.navigationController?.pushViewController(translationViewController, animated: true)
    }
    
    @objc private func analyze() {
        guard payPoints() else {
            return
        }
        let analyzeViewController = AnalyzeViewController()
        analyzeViewController.image = self.croppedImage() ?? self.image
        self.navigationController?.pushViewController(analyzeViewController, animated: true)
    }
    
    private func payPoints() -> Bool {
        if checkFreePoints() {
            return true
        }
        
        let userDefaults = UserDefaults.standard
        let balance = userDefaults.integer(forKey: UserDefaultsBalanceKey)
        if balance > AnalyzingCostPerTime {
            let finalBalance = balance - AnalyzingCostPerTime
            userDefaults.set(finalBalance, forKey: UserDefaultsBalanceKey)
//            UserKit.default.update(balance: finalBalance)
            return userDefaults.synchronize()
        }
        self.alertNoEnoughBalance()
        return false
    }
    
    private let kUserDefaultFreePointsKey = "VisionDemo_free_points"
    private func checkFreePoints() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let freePointsData = userDefaults.dictionary(forKey: kUserDefaultFreePointsKey) else {
            print("no data")
            // no data
            self.resetFreePoints()
            return true
        }
        
        // FIX: detect if current date is latter than stored date
        guard let date = freePointsData["date"] as? String, date == self.dateKey else {
            // not today
            print("not today")
            self.resetFreePoints()
            return true
        }
        
        if let count = freePointsData["count"] as? Int, count < kFreePoints {
            // has enough points
            print("today \(date) has enough points, used: \(count)")
            self.resetFreePoints(count: count + 1)
            return true
        }
        print("today \(date) has not enough points")
        return false
    }
    private func resetFreePoints(count: Int? = 0) {
        UserDefaults.standard.set(
            [
                "date": self.dateKey,
                "count": count!
            ],
            forKey: kUserDefaultFreePointsKey
        )
    }
    
    private func alertNoEnoughBalance() {
        let alertController = UIAlertController(title: "sorry".localized(), message: "no_enough_balance".localized(), preferredStyle: .actionSheet)
        alertController.addAction(
            UIAlertAction(
                title: "deposit".localized(),
                style: .default,
                handler: { (_) in
                    self.navigationController?.pushViewController(ProfileViewController(), animated: true)
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "cancel".localized(),
                style: .cancel,
                handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
            )
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func croppedImage() -> UIImage? {
        guard let mask = self.mask else {
            return self.image
        }
        self.view.bringSubviewToFront(self.backgroundImageView)
        self.backgroundImageView.alpha = 1
        let image = self.view.captureImage()
        self.backgroundImageView.alpha = 0.5
        self.view.sendSubviewToBack(self.backgroundImageView)
        let frame = mask.frame.applying(
            CGAffineTransform(
                scaleX: image.scale,
                y: image.scale
            )
        )
        guard
            let fromImageRef = image.cgImage,
            let imageRef = fromImageRef.cropping(to: frame)
            else
        {
            return self.image
        }
        return UIImage(cgImage: imageRef)
    }
    
    func draggableViewIsDragging(_ draggableView: DraggableView) {
        let point = draggableView.center
        switch draggableView {
        case self.topLeftAnchor:
            self.top = point.y
            self.left = point.x
        case self.topRightAnchor:
            self.top = point.y
            self.right = point.x
        case self.bottomLeftAnchor:
            self.bottom = point.y
            self.left = point.x
        case self.bottomRightAnchor:
            self.bottom = point.y
            self.right = point.x
        case self.topAnchor:
            self.top = point.y
        case self.rightAnchor:
            self.right = point.x
        case self.bottomAnchor:
            self.bottom = point.y
        case self.leftAnchor:
            self.left = point.x
        case self.centerAnchor:
            let halfWidth = (self.right - self.left) / 2
            let halfHeight = (self.bottom - self.top) / 2
            self.top = point.y - halfHeight
            self.bottom = point.y + halfHeight
            self.left = point.x - halfWidth
            self.right = point.x + halfWidth
        default:
            return
        }
    }
    
    func draggalbeView(_ draggableView: DraggableView, shouldDragTo point: CGPoint) -> Bool {
        var targetTop = top!
        var targetRight = right!
        var targetBottom = bottom!
        var targetLeft = left!
        
        switch draggableView {
        case self.topLeftAnchor:
            targetTop = point.y
            targetLeft = point.x
        case self.topRightAnchor:
            targetTop = point.y
            targetRight = point.x
        case self.bottomLeftAnchor:
            targetBottom = point.y
            targetLeft = point.x
        case self.bottomRightAnchor:
            targetBottom = point.y
            targetRight = point.x
        case self.topAnchor:
            targetTop = point.y
        case self.rightAnchor:
            targetRight = point.x
        case self.bottomAnchor:
            targetBottom = point.y
        case self.leftAnchor:
            targetLeft = point.x
        default:
            return true
        }
        
        guard (right - targetLeft) > kAnchorHeight, (targetRight - left) > kAnchorHeight, (targetBottom - top) > kAnchorHeight, (bottom - targetTop) > kAnchorHeight else {
            return false
        }
        return true
    }
    
    func updateMaskView() {
        guard let mask = self.mask else {
            return
        }
        topLeftAnchor.center = CGPoint(x: left, y: top)
        topRightAnchor.center = CGPoint(x: right, y: top)
        bottomLeftAnchor.center = CGPoint(x: left, y: bottom)
        bottomRightAnchor.center = CGPoint(x: right, y: bottom)
        let offset = kAnchorHeight / 2
        let innerLeft = left + offset
        let innerTop = top + offset
        let innerWidth = right - left - kAnchorHeight
        let innerHeight = bottom - top - kAnchorHeight
        centerAnchor.frame = CGRect(x: innerLeft, y: innerTop, width: innerWidth, height: innerHeight)
        topAnchor.frame = CGRect(x: innerLeft, y: topLeftAnchor.frame.minY, width: innerWidth, height: kAnchorHeight)
        rightAnchor.frame = CGRect(x: topRightAnchor.frame.minX, y: innerTop, width: kAnchorHeight, height: innerHeight)
        bottomAnchor.frame = CGRect(x: innerLeft, y: bottomLeftAnchor.frame.minY, width: innerWidth, height: kAnchorHeight)
        leftAnchor.frame = CGRect(x: topLeftAnchor.frame.minX, y: innerTop, width: kAnchorHeight, height: innerHeight)
        mask.frame = CGRect(x: left, y: top, width: right - left, height: bottom - top)
    }


}
