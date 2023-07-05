import UIKit
import SnapKit
import Then
import Moya

class BaseModalViewController: UIViewController {

    private let mainBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }

    private let titleLable = UILabel().then {
        $0.font = UIFont(name: "Roboto-Bold", size: 20)
        $0.textColor = .black
    }

    private let subTitleLable = UILabel().then {
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.textColor = UIColor(named: "gray-2")
        $0.numberOfLines = 0
    }

    private let okButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.layer.cornerRadius = 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }

    init(
        title: String,
        content: String
    ) {
        super.init(nibName: nil, bundle: nil)
        self.titleLable.text = title
        self.subTitleLable.text = content
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addsubViews()
        makeConstraints()
        self.okButton.addTarget(self, action: #selector(clickOKButton), for: .touchUpInside)
    }

    private func addsubViews() {
        view.addSubview(mainBackgroundView)
        [
            titleLable,
            subTitleLable,
            okButton,
        ].forEach({ mainBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        mainBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(150)
        }
        titleLable.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(25)
        }
        subTitleLable.snp.makeConstraints {
            $0.left.equalTo(titleLable)
            $0.right.equalToSuperview().inset(25)
            $0.top.equalTo(titleLable.snp.bottom).offset(4)
        }
        okButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(13)
            $0.height.equalTo(36)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    @objc func clickOKButton(sender: UIButton) {
        self.dismiss(animated: false)
    }
}
