import UIKit
import SnapKit
import Then
import Moya

class MainCouponViewController: UIViewController {
    private let mainTitleLabel = UILabel().then {
        $0.text = "내 쿠폰"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 24)
    }
    private let couponTableView = UITableView().then {
        $0.backgroundColor = .white
    }

    private let addCouponButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.setImage(UIImage(named: "plus_mark"), for: .normal)
        $0.layer.cornerRadius = 30
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        
    }

    private func addSubviews() {
        [
            mainTitleLabel,
            couponTableView,
            addCouponButton,
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
    }
}
