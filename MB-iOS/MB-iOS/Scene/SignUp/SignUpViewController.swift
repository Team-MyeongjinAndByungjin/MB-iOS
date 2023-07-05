//
//  SignUpViewController.swift
//  MB-iOS
//
//  Created by 조병진 on 2023/07/04.
//

import UIKit
import SnapKit
import Then
import Moya

class SignUpViewController: UIViewController {

    private let mainTitle = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 24)
    }

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_small")
    }

    private let idTextField = DefaultTextField(title: "아이디", placeholder: "아이디를 입력해주세요.")
    private let passwordTextField = DefaultTextField(title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", isSecure: true)
    private let signUpButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitle("회원가입", for: .normal)
        $0.layer.cornerRadius = 12
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        signUpButton.addTarget(self, action: #selector(clickSignUpButton), for: .touchUpInside)
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
            signUpButton
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
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

extension SignUpViewController {
    @objc func clickSignUpButton(sender: UIButton) {
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        guard let idText = self.idTextField.text,
              let passwordText = self.passwordTextField.text
        else { return }

        provider.request(.signUp(id: idText, password: passwordText)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 201:
                    if let data = try? JSONDecoder().decode(AuthResponse.self, from: result.data) {
                        Token.accessToken = data.token
                        let succedModal = BaseModalViewController(
                            title: "회원가입이 완료되었습니다!",
                            content: "같은 계정으로 로그인을 시도해주세요."
                        )
                        self.present(succedModal, animated: false)
                    } else {
                        print("signUp auth json decode fail")
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
