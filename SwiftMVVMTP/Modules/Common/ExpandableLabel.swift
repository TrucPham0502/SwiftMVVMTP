//
//  ExpandableLabel.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 05/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class ExpandableLabel: UILabel {
    var maxWords = 60
    var lineHieght : CGFloat = 23
    private var originalText: String?
    private var expanded = false {
        didSet {
            updateText()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGesture()
    }

    private func setupGesture() {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(gesture)
    }

    override var text: String? {
        didSet {
            originalText = text
            updateText()
           
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLineHeight(lineHieght)
    }

    private func updateText() {
        if expanded {
            super.text = originalText
        } else {
            guard let text = originalText else {
                super.text = nil
                return
            }

            let truncatedText = text.truncated(limit: maxWords)
            let attributedString = NSMutableAttributedString(string: truncatedText)

            if text.count > maxWords {
                attributedString.append(NSAttributedString(string: "... "))
                attributedString.append(createSeeMoreButton())
            }

            super.attributedText = attributedString
        }
    }

    private func createSeeMoreButton() -> NSAttributedString {
        let seeMoreText = "See More"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.regular(ofSize: 14),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: seeMoreText, attributes: attributes)
        return attributedString
    }

    @objc private func handleGesture(_ sender: UITapGestureRecognizer) {
        expanded = !expanded
        
    }
}

extension String {
    func truncated(limit: Int) -> String {
        let words = self.components(separatedBy: .whitespacesAndNewlines)
        if words.count > limit {
            return words[0..<limit].joined(separator: " ")
        } else {
            return self
        }
    }
}
