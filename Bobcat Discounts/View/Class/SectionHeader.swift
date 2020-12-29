//
//  SectionHeader.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/29/20.
//

import Foundation
import UIKit

public class SectionHeader: UICollectionReusableView {
    public var sectionLabel = UILabel()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSectionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSectionLabel() {
        sectionLabel.textColor = UIColor.black
        sectionLabel.textAlignment = .left
        sectionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        sectionLabel.sizeToFit()
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing)
        }
    }
}
