//
//  LoginViewController.swift
//  MB-iOS
//
//  Created by 조병진 on 2023/07/04.
//

import UIKit
import SnapKit
import Then
import Moya
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    private let mainTitle = UILabel().then {
        $0.text = "로그인"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 24)
    }
    private let signUpMarkLabel = UILabel().then {
        $0.text = "아직 회원이 아니신가요?"
        $0.textColor = UIColor(named: "gray-2")
        $0.font = UIFont(name: "Roboto-Regular", size: 12)
    }

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_small")
    }

    private let idTextField = DefaultTextField(title: "아이디", placeholder: "아이디를 입력해주세요.")
    private let passwordTextField = DefaultTextField(title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", isSecure: true)
    private let loginButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitle("로그인", for: .normal)
        $0.layer.cornerRadius = 12
    }
    private let signInButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        $0.setTitleColor(UIColor(named: "blue-1"), for: .normal)
        $0.setTitle("회원가입", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(clickLoginButton), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(clickSingUpButton), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
    }

    override func viewDidLayoutSubviews() {
        addsubViews()
        makeConstraints()
    }

    private func addsubViews() {
        [
            mainTitle,
            logoImageView,
            idTextField,
            passwordTextField,
            signUpMarkLabel,
            loginButton,
            signInButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        mainTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(36)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(23)
            $0.left.equalTo(mainTitle.snp.right).offset(3)
            $0.centerY.equalTo(mainTitle)
        }
        idTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(36)
            $0.top.equalTo(mainTitle.snp.bottom).offset(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(36)
            $0.top.equalTo(idTextField.snp.bottom).offset(40)
        }
        signUpMarkLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-30)
            $0.bottom.equalTo(loginButton.snp.top).offset(-20)
        }
        signInButton.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(22)
            $0.centerY.equalTo(signUpMarkLabel)
            $0.left.equalTo(signUpMarkLabel.snp.right).offset(5)
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

extension LoginViewController {
    @objc func clickSingUpButton(sender: UIButton) {
        let signUpView = SignUpViewController()
        self.navigationController?.pushViewController(signUpView, animated: true)
    }

    @objc func clickLoginButton(sender: UIButton) {
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        guard let idText = self.idTextField.text,
              let passwordText = self.passwordTextField.text,
              let myFcmToken = KeychainWrapper.standard.string(forKey: "firbase_fcmToken")
        else { return }
        

        provider.request(.login(id: idText, password: passwordText, fcmToken: myFcmToken)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 201:
                    if let data = try? JSONDecoder().decode(AuthResponse.self, from: result.data) {
                        DispatchQueue.main.async {
                            Token.accessToken = data.token
                            let mainView = MainCouponViewController()
                            self.navigationController?.pushViewController(mainView, animated: true)
                        }
                    } else {
                        print("auth json decode fail")
                    }
                default:
                    let errorModal = BaseModalViewController(
                        title: "오류",
                        content: "code: \(result.statusCode)"
                    )
                    self.present(errorModal, animated: false)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}
