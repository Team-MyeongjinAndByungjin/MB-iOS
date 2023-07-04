import UIKit
import SnapKit
import Then
import Moya

class MainCouponViewController: UIViewController {

    var couponList: [CouponModel] = []

    private let mainTitleLabel = UILabel().then {
        $0.text = "내 쿠폰"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 24)
    }
    private let couponTableView = UITableView().then {
        $0.backgroundColor = UIColor(named: "gray-1")
    }

    private let addCouponButton = UIButton(type: .system).then {
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
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
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
                                    price: $0.price,
                                    imageURL: $0.imageURL,
                                    expiredAt: $0.expiredAt
                                )
                            }
                            self.couponTableView.reloadData()
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
}

extension MainCouponViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell") as? CouponTableViewCell else { return UITableViewCell() }
        cell.cellSetter(
            id: couponList[indexPath.row].id,
            price: couponList[indexPath.row].price,
            couponName: couponList[indexPath.row].name,
            couponDate: couponList[indexPath.row].expiredAt,
            imageURL: couponList[indexPath.row].imageURL
        )
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
