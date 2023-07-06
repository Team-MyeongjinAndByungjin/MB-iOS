import UIKit
import SnapKit
import Then
import Moya

class MainCouponViewController: UIViewController {

    var couponList: [CouponModel] = [] {
        didSet {
            [
                addCouponImageView,
                emptyCouponTextField
            ].forEach({ $0.isHidden = !couponList.isEmpty })
            couponTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    private let refreshControl = UIRefreshControl()

    private let addCouponImageView = UIImageView().then {
        $0.image = UIImage(named: "add_coupon")
        $0.isHidden = true
    }
    private let emptyCouponTextField = UILabel().then {
        $0.text = "쿠폰을 등록해주세요."
        $0.textColor = UIColor(named: "gray-2")
        $0.font = UIFont(name: "Roboto-Bold", size: 15)
        $0.isHidden = true
    }
    private let mainTitleLabel = UILabel().then {
        $0.text = "내 쿠폰"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 24)
    }
    private let couponTableView = UITableView().then {
        $0.backgroundColor = UIColor(named: "gray-1")
    }

    private let addCouponButton = UIButton(type: .system).then {
        $0.tintColor = UIColor(named: "blue-1")
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "plus_mark"), for: .normal)
        $0.layer.cornerRadius = 30
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "gray-1")
        navigationItem.hidesBackButton = true
        settingTableView()
        addCouponButton.addTarget(self, action: #selector(clickAddCoupon), for: .touchUpInside)
        couponTableView.refreshControl = refreshControl
        couponTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        addSubviews()
        makeConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        getCoupons()
    }

    private func addSubviews() {
        [
            mainTitleLabel,
            couponTableView,
            addCouponButton,
            addCouponImageView,
            emptyCouponTextField
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        addCouponImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.height.equalTo(100)
        }
        emptyCouponTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(addCouponImageView.snp.bottom).offset(28)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalToSuperview().inset(36)
        }
        couponTableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(5)
        }
        addCouponButton.snp.makeConstraints {
            $0.height.width.equalTo(60)
            $0.right.bottom.equalToSuperview().inset(30)
        }
    }

    private func settingTableView() {
        couponTableView.delegate = self
        couponTableView.dataSource = self
        couponTableView.separatorStyle = .none
        couponTableView.register(CouponTableViewCell.self, forCellReuseIdentifier: "couponCell")
    }

    private func getCoupons() {
        let provider = MoyaProvider<CouponAPI>(plugins: [MoyaLoggerPlugin()])

        provider.request(.getCoupons) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200:
                    if let data = try? JSONDecoder().decode(CouponsResponse.self, from: result.data) {
                        DispatchQueue.main.async {
                            self.couponList = data.map {
                                .init(
                                    id: $0.id,
                                    name: $0.name,
                                    from: $0.from,
                                    imageURL: $0.imageURL,
                                    expiredAt: $0.expiredAt,
                                    createdAt: $0.createdAt
                                )
                            }
                        }
                    } else {
                        print("get coupons json decode fail")
                    }
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }

    @objc func clickAddCoupon() {
        self.navigationController?.pushViewController(CouponRegisterViewController(), animated: true)
    }

    @objc func pullToRefresh() {
        getCoupons()
    }
}

extension MainCouponViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell") as? CouponTableViewCell else { return UITableViewCell() }
        cell.cellSetter(
            id: couponList[indexPath.row].id,
            from: couponList[indexPath.row].from,
            couponName: couponList[indexPath.row].name,
            couponDate: "\(couponList[indexPath.row].createdAt) ~ \(couponList[indexPath.row].expiredAt)",
            imageURL: couponList[indexPath.row].imageURL
        )
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailModal = CouponInteractionViewController(
            name: couponList[indexPath.row].name,
            date: "\(couponList[indexPath.row].createdAt) ~ \(couponList[indexPath.row].expiredAt)",
            imageURL: couponList[indexPath.row].imageURL,
            useAction: {
                let couponUseView = UseCouponViewController(imageURL: self.couponList[indexPath.row].imageURL)
                self.present(couponUseView, animated: false)
            },
            giftAction: {
                let giftModal = GiftCouponViewController(id: self.couponList[indexPath.row].id, completion: {
                    self.couponList.remove(at: indexPath.row)
                    self.couponTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let sendModal = BaseModalViewController(
                            title: "선물을 보냈습니다!",
                            content: "친구에게 알림이 발송됩니다."
                        )
                        self.present(sendModal, animated: false)
                    }
                })
                self.present(giftModal, animated: false)
            },
            deleteAction: {
                let deleteModal = DeleteCouponViewController(id: self.couponList[indexPath.row].id, completion: {
                    self.couponList.remove(at: indexPath.row)
                    self.couponTableView.reloadData()
                })
                self.present(deleteModal, animated: false)
            }
        )
        self.present(detailModal, animated: true)
    }
}
