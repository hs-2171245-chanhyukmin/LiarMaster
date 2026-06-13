import UIKit

class ResultViewController: UIViewController {

    // MARK: - Data
    private let liarRoles: [PlayerRole]
    private let keyword: String

    // MARK: - UI Components
    private let announceTitleLabel = UILabel()
    private let liarNumberLabel = UILabel()
    private let keywordTitleLabel = UILabel()
    private let keywordLabel = UILabel()
    private let restartButton = UIButton(type: .system)

    // MARK: - Init
    init(liarRoles: [PlayerRole], keyword: String) {
        self.liarRoles = liarRoles
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateReveal()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "결과 공개"
        navigationItem.hidesBackButton = true

        // "라이어는 바로..."
        announceTitleLabel.text = "🎭 라이어는 바로..."
        announceTitleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        announceTitleLabel.textAlignment = .center

        // 라이어 번호
        let liarNumbers = liarRoles.map { "플레이어 \($0.playerNumber)번" }.joined(separator: ", ")
        liarNumberLabel.text = liarNumbers
        liarNumberLabel.font = UIFont.boldSystemFont(ofSize: 52)
        liarNumberLabel.textColor = .systemRed
        liarNumberLabel.textAlignment = .center
        liarNumberLabel.adjustsFontSizeToFitWidth = true
        liarNumberLabel.minimumScaleFactor = 0.5
        liarNumberLabel.alpha = 0  // 애니메이션 시작 전 숨김

        // 정답 제시어 제목
        keywordTitleLabel.text = "정답 제시어"
        keywordTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        keywordTitleLabel.textColor = .secondaryLabel
        keywordTitleLabel.textAlignment = .center

        // 정답 단어
        keywordLabel.text = keyword
        keywordLabel.font = UIFont.boldSystemFont(ofSize: 40)
        keywordLabel.textColor = .systemBlue
        keywordLabel.textAlignment = .center
        keywordLabel.alpha = 0  // 애니메이션 시작 전 숨김

        // 구분선
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Restart Button
        restartButton.setTitle("🔄  다시 하기", for: .normal)
        restartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        restartButton.backgroundColor = .systemIndigo
        restartButton.setTitleColor(.white, for: .normal)
        restartButton.layer.cornerRadius = 16
        restartButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        restartButton.layer.shadowOpacity = 0.3
        restartButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        restartButton.layer.shadowRadius = 8
        restartButton.addTarget(self, action: #selector(restart), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            announceTitleLabel,
            liarNumberLabel,
            separator,
            keywordTitleLabel,
            keywordLabel,
            restartButton
        ])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false

        restartButton.heightAnchor.constraint(equalToConstant: 58).isActive = true

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Animation
    private func animateReveal() {
        // 라이어 번호 0.4초 후 등장
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.liarNumberLabel.alpha = 1
            self.liarNumberLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.liarNumberLabel.transform = .identity
            }
        }
        // 정답 1.2초 후 등장
        UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveEaseOut) {
            self.keywordLabel.alpha = 1
        }
    }

    // MARK: - Actions
    @objc private func restart() {
        navigationController?.popToRootViewController(animated: true)
    }
}
