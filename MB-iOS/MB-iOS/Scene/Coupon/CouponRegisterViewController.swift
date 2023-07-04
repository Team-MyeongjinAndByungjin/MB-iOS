import UIKit
import SnapKit
import Then
import Moya

class CouponRegisterViewController: UIViewController {
    private var selectImageURL: String = ""

    private let mainTitle = UILabel().then {
        $0.text = "쿠폰 등록"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 20)
    }
    private let imageTitle = UILabel().then {
        $0.text = "이미지"
        $0.textColor = .black
        $0.font = UIFont(name: "Roboto-Bold", size: 12)
    }
    private let couponNameTextField = DefaultTextField(title: "이름", placeholder: "티켓 이름을 입력해주세요.")
    private let priceTextField = DefaultTextField(title: "가격", placeholder: "티켓 가격을 입력해주세요.")
    private let expirationDateTextField = DefaultTextField(title: "유효기간", placeholder: "ex)2023-07-04")
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "gray-2")
        $0.layer.cornerRadius = 12
    }
    private let registerButton = UIButton(type: .system).then {
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        $0.backgroundColor = UIColor(named: "blue-1")?.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 12
        $0.isEnabled = true
    }
    private let imageView = UIImageView().then {
        $0.backgroundColor = UIColor(named: "gray-1")
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    private let secondImageView = UIImageView().then {
        $0.image = UIImage(named: "imageIcon")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerCoupon), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
        selectImage()
    }
    private func selectImage() {
        imageView.isUserInteractionEnabled = true
        let didTap = UITapGestureRecognizer(target: self, action: #selector(clickPhotoAdd))
        imageView.addGestureRecognizer(didTap)
    }
    private func addSubViews() {
        [
            mainTitle,
            imageTitle,
            imageView,
            couponNameTextField,
            priceTextField,
            expirationDateTextField,
            cancelButton,
            registerButton,
            secondImageView
        ].forEach({view.addSubview($0)})
    }
    private func makeConstraints() {
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70)
            $0.left.equalToSuperview().inset(36)
        }
        imageTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(36)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(imageTitle.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(36)
            $0.width.height.equalTo(150)
        }
        couponNameTextField.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(36)
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(couponNameTextField.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(36)
        }
        expirationDateTextField.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(36)
        }
        cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(registerButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview().inset(36)
            $0.height.equalTo(40)
        }
        registerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(36)
            $0.height.equalTo(40)
        }
        secondImageView.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
    }

    private func getImageURL(source image: UIImage) -> Void {
        let provider = MoyaProvider<ImageAPI>(plugins: [MoyaLoggerPlugin()])
        
        provider.request(.getImageURL(data: image.jpegData(compressionQuality: 0.1) ?? Data())) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 201:
                    if let data = try? JSONDecoder().decode(CouponImageResponse.self, from: result.data) {
                        DispatchQueue.main.async {
                            self.selectImageURL = data.imageURL
                            self.enabledRegisterButton(status: true)
                        }
                    } else {
                        print("image to url decode fail")
                    }
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }

    private func enabledRegisterButton(status: Bool) {
        self.registerButton.backgroundColor = status ? UIColor(named: "blue-1") : UIColor(named: "blue-1")?.withAlphaComponent(0.2)
        self.registerButton.isEnabled = status
    }

    @objc func clickCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func registerCoupon() {
        guard let price = Int(self.priceTextField.text ?? ""),
        let name = self.couponNameTextField.text,
        let expiredAt = self.expirationDateTextField.text else {
            return
        }
                  
        let provider = MoyaProvider<CouponAPI>(plugins: [MoyaLoggerPlugin()])

        provider.request(.saveCoupon(imageURL: self.selectImageURL, price: price, name: name, expiredAt: expiredAt)) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 201:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    print(result.statusCode)
                }
            case .failure(let err):
                print("\(err.localizedDescription)")
            }
        }
    }
}

extension CouponRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func clickPhotoAdd(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = pickedImage
        secondImageView.isHidden = true
        dismiss(animated: true, completion: {
            self.enabledRegisterButton(status: false)
            self.getImageURL(source: pickedImage)
        })
    }
}
