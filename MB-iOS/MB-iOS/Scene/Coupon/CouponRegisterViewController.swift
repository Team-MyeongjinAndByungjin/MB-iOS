//
//  CouponRegister.swift
//  MB-iOS
//
//  Created by 조영준 on 2023/07/04.
//

import UIKit
import SnapKit
import Then

class CouponRegisterViewController: UIViewController {
    
    private let mainTitle = UILabel().then {
        $0.text = "쿠폰 등록"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 20)
    }
    private let imageTitle = UILabel().then {
        $0.text = "이미지"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
    }
    private let couponNameTextField = DefaultTextField(title: "이름", placeholder: "티켓 이름을 입력해주세요.")
    private let priceTextField = DefaultTextField(title: "가격", placeholder: "티켓 가격을 입력해주세요.")
    private let expirationDate = DefaultTextField(title: "유효기간", placeholder: "ex)2023-07-04")
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "gray-2")
        $0.layer.cornerRadius = 12
    }
    private let registerButton = UIButton(type: .system).then {
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.layer.cornerRadius = 12
    }
    private let imageView = UIImageView().then {
        $0.backgroundColor = UIColor(named: "gray-1")
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    private let secondImageView = UIImageView().then {
        $0.image = UIImage(named: "imageIcon")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
        selectImage()
    }
    private func selectImage() {
        imageView.isUserInteractionEnabled = true
        let didTap = UITapGestureRecognizer(target: self, action: #selector(clickPhotoAdd))
        imageView.addGestureRecognizer(didTap)
    }
    private func addSubViews() {
        [
            mainTitle,
            imageTitle,
            imageView,
            couponNameTextField,
            priceTextField,
            expirationDate,
            cancelButton,
            registerButton,
            secondImageView
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70)
            $0.left.equalToSuperview().inset(36)
        }
        imageTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(36)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(imageTitle.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(36)
            $0.width.height.equalTo(150)
        }
        couponNameTextField.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(36)
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(couponNameTextField.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(36)
        }
        expirationDate.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(36)
        }
        cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(registerButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview().inset(36)
            $0.height.equalTo(40)
        }
        registerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(36)
            $0.height.equalTo(40)
        }
        secondImageView.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
    }
    
    @objc func clickCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CouponRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func clickPhotoAdd(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            secondImageView.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
}
