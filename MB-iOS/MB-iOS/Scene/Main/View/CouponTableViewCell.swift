import UIKit
import SnapKit
import Then

class CouponTableViewCell: UITableViewCell {
    private let couponFrontView = UIView().then {
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    private let couponBackView = UIView().then {
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        $0.backgroundColor = UIColor(named: "blue-1")
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
    }

    private let couponImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 33
        $0.backgroundColor = .blue
    }

    private let couponIconImageView = UIImageView().then {
        $0.image = UIImage(named: "coupon")
        $0.contentMode = .scaleAspectFill
    }

    private let couponNameTitleLabel = UILabel().then {
        $0.text = "무언가"
        $0.font = UIFont(name: "Roboto-Bold", size: 16)
        $0.textColor = .black
    }

    private let couponDateLabel = UILabel().then {
        $0.text = "2023-07-04\n~2024-07-04"
        $0.font = UIFont(name: "Roboto-Medium", size: 10)
        $0.textColor = .white
        $0.numberOfLines = 2
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        makeConstraints()
        self.backgroundColor = .clear
    }

    private func addSubviews() {
        [
            couponFrontView,
            couponBackView,
            couponImageView,
            couponIconImageView,
            couponNameTitleLabel,
            couponDateLabel
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        couponFrontView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(35)
            $0.width.equalTo(260)
            $0.height.equalTo(120)
            $0.centerY.equalToSuperview()
        }
        couponBackView.snp.makeConstraints {
            $0.left.equalTo(couponFrontView.snp.right)
            $0.width.equalTo(75)
            $0.height.equalTo(120)
            $0.centerY.equalToSuperview()
        }
        couponImageView.snp.makeConstraints {
            $0.width.height.equalTo(66)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(couponFrontView).inset(10)
        }
        couponNameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(couponFrontView).inset(20)
            $0.left.equalTo(couponImageView.snp.right).offset(12)
        }
        couponIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(couponBackView)
            $0.top.equalTo(couponBackView).inset(30)
        }
        couponDateLabel.snp.makeConstraints {
            $0.left.right.equalTo(couponBackView).inset(10)
            $0.bottom.equalTo(couponBackView).inset(10)
        }
    }

}
