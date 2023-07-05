import UIKit
import SnapKit
import Then
import Moya

class DeleteCouponViewController: UIViewController {

    private var completion: () -> Void = {}
    private var id: Int = 0

    private let mainBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }

    private let trashCanImageView = UIImageView().then {
        $0.image = UIImage(named: "trash_can")
    }

    private let titleLable = UILabel().then {
        $0.text = "쿠폰을 삭제하시겠습니까?"
        $0.font = UIFont(name: "Roboto-Bold", size: 20)
        $0.textColor = .black
    }

    private let subTitleLable = UILabel().then {
        $0.text = "이 작업은 되돌릴 수 없습니다."
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.textColor = UIColor(named: "gray-2")
    }

    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-2"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "gray-1")
        $0.layer.cornerRadius = 8
    }

    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "red-1")
        $0.layer.cornerRadius = 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
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
        self.deleteButton.addTarget(self, action: #selector(clickDeleteButton), for: .touchUpInside)
    }

    private func addsubViews() {
        view.addSubview(mainBackgroundView)
        [
            trashCanImageView,
            titleLable,
            subTitleLable,
            cancelButton,
            deleteButton
        ].forEach({ mainBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        mainBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(250)
        }
        trashCanImageView.snp.makeConstraints {
            $0.width.equalTo(37)
            $0.height.equalTo(47)
            $0.top.left.equalToSuperview().inset(35)
        }
        titleLable.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(33)
            $0.top.equalTo(trashCanImageView.snp.bottom).offset(27)
        }
        subTitleLable.snp.makeConstraints {
            $0.left.equalTo(titleLable)
            $0.top.equalTo(titleLable.snp.bottom).offset(4)
        }
        cancelButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(122)
        }
        deleteButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(122)
        }
    }

    @objc func clickCancelButton(sender: UIButton) {
        self.dismiss(animated: false)
    }

    @objc func clickDeleteButton(sender: UIButton) {
        self.dismiss(animated: false)
        let provider = MoyaProvider<CouponAPI>(plugins: [MoyaLoggerPlugin()])

        provider.request(.deleteCoupon(couponID: self.id)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 204:
                    self.completion()
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}
