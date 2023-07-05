import UIKit
import SnapKit
import Then
import Kingfisher

class CouponInteractionViewController: UIViewController {
    
    private var useAction: () -> Void = {}
    private var giftAction: () -> Void = {}
    private var deleteAction: () -> Void = {}

    private let modalBackgroundView = UIView().then {
        $0.roundCorners(cornerRadius: 15, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        $0.backgroundColor = .white
    }

    private let nameTitleLable = UILabel().then {
        $0.font = UIFont(name: "Roboto-Bold", size: 20)
        $0.textColor = .black
    }

    private let dateLable = UILabel().then {
        $0.font = UIFont(name: "Roboto-Medium", size: 12)
        $0.textColor = UIColor(named: "gray-2")
    }

    private let imageBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 5
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.cornerRadius = 50
    }

    private let couponImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 45
        $0.clipsToBounds = true
    }

    private let useButton = UIButton(type: .system).then {
        $0.setTitle("사용하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.layer.cornerRadius = 12
    }

    private let giftButton = UIButton(type: .system).then {
        $0.setTitle("선물하기", for: .normal)
        $0.setTitleColor(UIColor(named: "blue-1"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "blue-1")?.cgColor
        $0.layer.cornerRadius = 12
    }

    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제하기", for: .normal)
        $0.setTitleColor(UIColor(named: "red-1"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "red-1")?.cgColor
        $0.layer.cornerRadius = 12
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchSelfView))
        self.view.addGestureRecognizer(gesture)
    }

    override func viewDidLayoutSubviews() {
        addsubViews()
        makeConstraints()
    }

    init(
        name: String,
        date: String,
        imageURL: String,
        useAction: @escaping () -> Void,
        giftAction: @escaping () -> Void,
        deleteAction: @escaping () -> Void
    ) {
        super.init(nibName: nil, bundle: nil)
        self.nameTitleLable.text = name
        self.dateLable.text = date
        self.couponImageView.kf.setImage(with: URL(string: imageURL))
        self.modalPresentationStyle = .overFullScreen
        self.useAction = useAction
        self.giftAction = giftAction
        self.deleteAction = deleteAction
        useButton.addTarget(self, action: #selector(useButtonClick), for: .touchUpInside)
        giftButton.addTarget(self, action: #selector(giftButtonClick), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addsubViews() {
        view.addSubview(modalBackgroundView)
        imageBackgroundView.addSubview(couponImageView)
        [
            nameTitleLable,
            dateLable,
            imageBackgroundView,
            useButton,
            giftButton,
            deleteButton,
        ].forEach({ modalBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        modalBackgroundView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        nameTitleLable.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(23)
            $0.right.equalTo(imageBackgroundView.snp.right).offset(-5)
        }
        dateLable.snp.makeConstraints {
            $0.top.equalTo(nameTitleLable.snp.bottom).offset(5)
            $0.left.equalTo(nameTitleLable)
        }
        imageBackgroundView.snp.makeConstraints {
            $0.centerY.equalTo(modalBackgroundView.snp.top)
            $0.right.equalToSuperview().inset(23)
            $0.width.height.equalTo(100)
        }
        couponImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
        useButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(36)
            $0.bottom.equalTo(giftButton.snp.top).offset(-14)
        }
        giftButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(36)
            $0.bottom.equalTo(deleteButton.snp.top).offset(-14)
        }
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(36)
            $0.bottom.equalToSuperview().inset(52)
        }
    }
    
    @objc func touchSelfView() {
        self.dismiss(animated: true)
    }

    @objc func useButtonClick() {
        self.dismiss(animated: false, completion: { self.useAction() })
    }

    @objc func giftButtonClick() {
        self.dismiss(animated: false, completion: { self.giftAction() })
    }

    @objc func deleteButtonClick() {
        self.dismiss(animated: false, completion: { self.deleteAction() })
    }
}
