//
//  GiftCouponViewController.swift
//  MB-iOS
//
//  Created by 조병진 on 2023/07/05.
//

import UIKit
import SnapKit
import Then
import Moya

class GiftCouponViewController: UIViewController {

    private var completion: () -> Void = {}
    private var id: Int = 0

    private let mainBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }

    private let titleLable = UILabel().then {
        $0.text = "다른 유저에게 선물을 주세요."
        $0.font = UIFont(name: "Roboto-Bold", size: 20)
        $0.textColor = .black
    }

    private let subTitleLable = UILabel().then {
        $0.text = "나의 쿠폰은 삭제됩니다."
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.textColor = UIColor(named: "gray-2")
    }

    private let giftUserIdTextField = DefaultTextField(title: "", placeholder: "선물할 유저의 아이디를 입력해주세요.")

    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-2"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "gray-1")
        $0.layer.cornerRadius = 8
    }

    private let sendButton = UIButton(type: .system).then {
        $0.setTitle("보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.layer.cornerRadius = 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        hideKeyboardWhenTappedAround()
    }

    init(id: Int, completion: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
        self.completion = completion
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addsubViews()
        makeConstraints()
        self.cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        self.sendButton.addTarget(self, action: #selector(clicksendButton), for: .touchUpInside)
    }

    private func addsubViews() {
        view.addSubview(mainBackgroundView)
        [
            titleLable,
            subTitleLable,
            giftUserIdTextField,
            cancelButton,
            sendButton
        ].forEach({ mainBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        mainBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(240)
        }
        titleLable.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(33)
            $0.top.equalToSuperview().inset(35)
        }
        subTitleLable.snp.makeConstraints {
            $0.left.equalTo(titleLable)
            $0.top.equalTo(titleLable.snp.bottom).offset(4)
        }
        giftUserIdTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.left.right.equalToSuperview().inset(33)
            $0.top.equalTo(subTitleLable.snp.bottom).offset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(122)
        }
        sendButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(122)
        }
    }

    @objc func clickCancelButton(sender: UIButton) {
        self.dismiss(animated: false)
    }

    @objc func clicksendButton(sender: UIButton) {
        guard let userID = self.giftUserIdTextField.text else { return }
        let provider = MoyaProvider<CouponAPI>(plugins: [MoyaLoggerPlugin()])

        provider.request(.giveCouponToUser(couponID: self.id, receiveUserID: userID)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 204:
                    self.completion()
                    self.dismiss(animated: false)
                case 404:
                    let notFoundModal = BaseModalViewController(
                        title: "친구를 찾을 수 없습니다!",
                        content: "아이디를 다시한번 확인해주세요."
                    )
                    self.present(notFoundModal, animated: false)
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }

}
