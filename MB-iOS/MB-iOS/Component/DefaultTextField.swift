//
//  DefaultTextField.swift
//  MB-iOS
//
//  Created by 조병진 on 2023/07/04.
//

import UIKit
import SnapKit
import Then

class DefaultTextField: UITextField {

    private var placeholderText: String = ""

    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.textColor = .black
    }

    init(
        title: String,
        placeholder: String,
        isSecure: Bool = false
    ) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.placeholderText = placeholder
        self.isSecureTextEntry = isSecure
        self.font = UIFont(name: "Roboto-Regular", size: 15)
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.backgroundColor = UIColor(named: "gray-1")
        self.layer.cornerRadius = 12
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.leftView = spacerView
        self.rightView = spacerView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(titleLabel)
        makeConstraints()
        fieldSetting()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(4)
            $0.bottom.equalTo(self.snp.top).offset(-4)
        }
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }

    private func fieldSetting() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "gray-2")!,
                NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12) as Any
            ]
        )
    }
}
