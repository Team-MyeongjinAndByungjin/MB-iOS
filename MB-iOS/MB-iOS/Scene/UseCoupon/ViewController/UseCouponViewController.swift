import UIKit
import SnapKit
import Then
import Kingfisher

class UseCouponViewController: UIViewController {
    private let couponImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchSelfView))
        self.view.addGestureRecognizer(gesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(couponImageView)
        couponImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview().inset(30)
        }
    }

    init(imageURL: String) {
        super.init(nibName: nil, bundle: nil)
        couponImageView.kf.setImage(with: URL(string: imageURL))
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func touchSelfView() {
        self.dismiss(animated: false)
    }
}
