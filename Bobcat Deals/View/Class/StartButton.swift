//
//  NextButton.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/9/20.
//

import UIKit

public class StartButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    private func configureButton() {
        titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func set(title: String, backgroundColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
}
