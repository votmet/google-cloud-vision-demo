//
//  HistoryTableViewCell.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/7.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

struct HistoryItem {
    let imageURL: URL
    let data: Data
    let dataURL: URL
//    let keywords: Array<String>
}

class HistoryTableViewCell: UITableViewCell {

    weak var photoView: UIImageView!
    weak var selectedKeywordLabel: UILabel!
    private weak var keywordStackView: UIStackView!
    private weak var keywordLabel1: UILabel!
    private weak var keywordLabel2: UILabel!
    private weak var keywordLabel3: UILabel!
    private weak var datetimeLabel: UILabel!
    private var keywordLabels = [UILabel]()
    var isTranslation: Bool {
        return !JSON(item!.data)["data"].isEmpty
    }
    
    // FIXME: cache the data
    var item: HistoryItem? {
        didSet {
            do {
                let image = try UIImage(data: Data(contentsOf: item!.imageURL))
                self.photoView.image = image
            } catch {
                
            }
            self.selectedKeywordLabel.text = nil
            self.keywordLabel1.text = nil
            self.keywordLabel2.text = nil
            self.keywordLabel3.text = nil
            let json = JSON(item!.data)
            let data = json["data"]
            let responses = json["responses"][0]
            if !responses.isEmpty {
                // analyzing
                let landmark: JSON = responses["landmarkAnnotations"][0]
                self.selectedKeywordLabel.text = landmark["localized"].string ?? landmark["description"].string
                let labels = responses["labelAnnotations"]
                var labelStartIndex = 0
                if self.selectedKeywordLabel.text == nil {
                    labelStartIndex = 1
                    let label = labels[0]
                    self.selectedKeywordLabel.text = label["localized"].string ?? label["description"].string
                }
                for index in labelStartIndex...labelStartIndex + 2 {
                    let label = labels[index]
                    self.keywordLabels[index - labelStartIndex].text = label["localized"].string ?? label["description"].string
                }
            }
            if !data.isEmpty {
                // translation
                self.selectedKeywordLabel.text = json["sourceText"].string
                self.keywordLabel1.text = json["data"]["translations"][0]["translatedText"].string
            }
            do {
                let creationDateValue = try item!.dataURL.resourceValues(forKeys: [.creationDateKey])
                let formatter = DateFormatter()
                formatter.locale = Locale.userDefaultLocale()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
                self.datetimeLabel.text = formatter.string(from: creationDateValue.creationDate!)
            } catch {

            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = backgroundLightColor
        
        var margins = self.contentView.layoutMargins
        margins.top = marginDefault
        margins.bottom = marginDefault
        self.contentView.layoutMargins = margins
        
        self.photoView = self.imageViewInCell()
        self.photoView.clipsToBounds = true
        self.photoView.contentMode = .scaleAspectFill
        self.selectedKeywordLabel = self.labelInCell(font: UIFont.preferredFont(forTextStyle: .headline))
        self.selectedKeywordLabel.numberOfLines = 1
        self.datetimeLabel = self.labelInCell(font: UIFont.preferredFont(forTextStyle: .footnote), textColor: secondaryColor)
        
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.lightGray
        stackView.axis = .vertical
        stackView.spacing = marginInner
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        self.keywordStackView = stackView
        
        self.keywordLabel1 = self.labelInStackView(stackView, font: UIFont.preferredFont(forTextStyle: .subheadline))
        self.keywordLabels.append(self.keywordLabel1)
        self.keywordLabel2 = self.labelInStackView(stackView, font: UIFont.preferredFont(forTextStyle: .subheadline))
        self.keywordLabels.append(self.keywordLabel2)
        self.keywordLabel3 = self.labelInStackView(stackView, font: UIFont.preferredFont(forTextStyle: .subheadline))
        self.keywordLabels.append(self.keywordLabel3)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.photoView.backgroundColor = UIColor.white
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.photoView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.photoView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.photoView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5, constant: -marginDefault / 2).isActive = true
        self.photoView.heightAnchor.constraint(equalTo: self.photoView.widthAnchor, multiplier: 0.75).isActive = true
        let photoViewBottomConstraint = self.photoView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        photoViewBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        photoViewBottomConstraint.isActive = true
        
        self.selectedKeywordLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.selectedKeywordLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.selectedKeywordLabel.leadingAnchor.constraint(equalTo: self.photoView.trailingAnchor, constant: marginInner).isActive = true
        self.selectedKeywordLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.keywordStackView.topAnchor.constraint(equalTo: self.selectedKeywordLabel.bottomAnchor, constant: marginInner).isActive = true
        self.keywordStackView.trailingAnchor.constraint(equalTo: self.selectedKeywordLabel.trailingAnchor).isActive = true
        self.keywordStackView.leadingAnchor.constraint(equalTo: self.selectedKeywordLabel.leadingAnchor).isActive = true
        
        self.datetimeLabel.topAnchor.constraint(greaterThanOrEqualTo: self.keywordStackView.bottomAnchor, constant: marginInner).isActive = true
        self.datetimeLabel.trailingAnchor.constraint(equalTo: self.selectedKeywordLabel.trailingAnchor).isActive = true
        self.datetimeLabel.leadingAnchor.constraint(equalTo: self.selectedKeywordLabel.leadingAnchor).isActive = true
        self.datetimeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        // align bottom with photo view
        self.datetimeLabel.bottomAnchor.constraint(equalTo: self.photoView.bottomAnchor).isActive = true
    }
    
}

extension HistoryTableViewCell {
    private func imageViewInCell() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        return imageView
    }
    
    private func labelInStackView(_ stackView: UIStackView, font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font
        stackView.addArrangedSubview(label)
        return label
    }
}
