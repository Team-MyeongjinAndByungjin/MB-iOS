import UIKit
import SnapKit
import Then
import Kingfisher

class CouponTableViewCell: UITableViewCell {
    private var id: Int = 0

    private let couponFrontView = UIView().then {
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
    private let couponMarkLabel = UILabel().then {
        $0.text = "COUPON"
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.textColor = .white
    }

    private let couponImageView = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "blue-1")?.cgColor
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 33
        $0.clipsToBounds = true
    }

    private let couponIconImageView = UIImageView().then {
        $0.image = UIImage(named: "coupon")
        $0.contentMode = .scaleAspectFill
    }

    private let couponNameTitleLabel = UILabel().then {
        $0.font = UIFont(name: "Roboto-Bold", size: 16)
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.textAlignment = .right
    }

    private let couponFromLabel = UILabel().then {
        $0.font = UIFont(name: "Roboto-Light", size: 12)
        $0.textColor = .black
    }

    private let couponDateLabel = UILabel().then {
        $0.font = UIFont(name: "Roboto-Light", size: 12)
        $0.textColor = .black
    }

    public func cellSetter(
        id: Int,
        from: String,
        couponName: String,
        couponDate: String,
        imageURL: String
    ) {
        self.id = id
        self.couponFromLabel.text = "From : \(from)"
        self.couponImageView.kf.setImage(with: URL(string: imageURL))
        self.couponNameTitleLabel.text = couponName
        self.couponDateLabel.text = couponDate
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
            couponMarkLabel,
            couponIconImageView,
            couponNameTitleLabel,
            couponDateLabel,
            couponFromLabel
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        couponFrontView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(35)
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(120)
            $0.centerY.equalToSuperview()
        }
        couponBackView.snp.makeConstraints {
            $0.right.equalTo(couponFrontView)
            $0.width.equalTo(75)
            $0.height.equalTo(120)
            $0.centerY.equalToSuperview()
        }
        couponImageView.snp.makeConstraints {
            $0.width.height.equalTo(66)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(couponFrontView).inset(16)
        }
        couponMarkLabel.snp.makeConstraints {
            $0.centerX.equalTo(couponBackView)
            $0.bottom.equalTo(couponBackView).inset(25)
        }
        couponNameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(couponFrontView).inset(25)
            $0.left.equalTo(couponImageView.snp.right).offset(27)
            $0.right.equalTo(couponBackView.snp.left).offset(-27)
        }
        couponIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(couponBackView)
            $0.top.equalTo(couponBackView).inset(30)
        }
        couponFromLabel.snp.makeConstraints {
            $0.right.equalTo(couponDateLabel)
            $0.bottom.equalTo(couponDateLabel.snp.top).offset(-5)
        }
        couponDateLabel.snp.makeConstraints {
            $0.right.equalTo(couponBackView.snp.left).offset(-25)
            $0.bottom.equalTo(couponFrontView).inset(15)
        }
    }

}
