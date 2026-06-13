import UIKit

class ResultViewController: UIViewController {

    // MARK: - Data
    private let liarRoles: [PlayerRole]
    private let keyword: String
    private let outcome: GameOutcome

    // MARK: - UI Components
    private let outcomeLabel = UILabel()    // 승패 결과
    private let announceTitleLabel = UILabel()
    private let liarNumberLabel = UILabel()
    private let keywordTitleLabel = UILabel()
    private let keywordLabel = UILabel()
    private let restartButton = UIButton(type: .system)

    // MARK: - Init
    init(liarRoles: [PlayerRole], keyword: String, outcome: GameOutcome) {
        self.liarRoles = liarRoles
        self.keyword = keyword
        self.outcome = outcome
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupUI()
        animateReveal()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "최종 결과"
        navigationItem.hidesBackButton = true

        // 승패 배너
        switch outcome {
        case .citizensWin:
            outcomeLabel.text = "🏆 시민 승리!\n라이어를 잡고 제시어도 지켰어요!"
            outcomeLabel.textColor = .systemGreen
        case .liarWinsGuess:
            outcomeLabel.text = "🤥 라이어 승리!\n라이어가 제시어를 맞췄어요!"
            outcomeLabel.textColor = .systemRed
        case .liarWinsVote:
            outcomeLabel.text = "🤥 라이어 승리!\n라이어를 찾지 못했어요!"
            outcomeLabel.textColor = .systemRed
        }
        outcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
        outcomeLabel.textAlignment = .center
        outcomeLabel.numberOfLines = 0
        outcomeLabel.backgroundColor = outcomeLabel.textColor.withAlphaComponent(0.08)
        outcomeLabel.layer.cornerRadius = 14
        outcomeLabel.clipsToBounds = true

        // "라이어는 바로..."
        announceTitleLabel.text = "🎭 라이어는 바로..."
        announceTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        announceTitleLabel.textAlignment = .center

        // 라이어 번호
        let liarNumbers = liarRoles.map { "플레이어 \($0.playerNumber)번" }.joined(separator: ", ")
        liarNumberLabel.text = liarNumbers
        liarNumberLabel.font = UIFont.boldSystemFont(ofSize: 48)
        liarNumberLabel.textColor = .systemRed
        liarNumberLabel.textAlignment = .center
        liarNumberLabel.adjustsFontSizeToFitWidth = true
        liarNumberLabel.minimumScaleFactor = 0.5
        liarNumberLabel.alpha = 0

        // 정답 제시어
        keywordTitleLabel.text = "정답 제시어"
        keywordTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        keywordTitleLabel.textColor = .secondaryLabel
        keywordTitleLabel.textAlignment = .center

        keywordLabel.text = keyword
        keywordLabel.font = UIFont.boldSystemFont(ofSize: 40)
        keywordLabel.textColor = .systemIndigo
        keywordLabel.textAlignment = .center
        keywordLabel.alpha = 0

        // 구분선
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // 다시 하기 버튼
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
            outcomeLabel,
            announceTitleLabel,
            liarNumberLabel,
            separator,
            keywordTitleLabel,
            keywordLabel,
            restartButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(8, after: outcomeLabel)

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
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.liarNumberLabel.alpha = 1
            self.liarNumberLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.liarNumberLabel.transform = .identity
            }
        }
        UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveEaseOut) {
            self.keywordLabel.alpha = 1
        }
    }

    // MARK: - Actions
    @objc private func restart() {
        navigationController?.popToRootViewController(animated: true)
    }
}

