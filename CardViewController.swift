import UIKit

class CardViewController: UIViewController {

    // MARK: - Data
    private let roles: [PlayerRole]
    private var currentIndex = 0

    // MARK: - UI Components
    private let playerLabel = UILabel()
    private let cardView = UIView()
    private let questionMarkLabel = UILabel()
    private let revealLabel = UILabel()
    private let holdButton = UIButton(type: .system)
    private let hintLabel = UILabel()
    private let nextButton = UIButton(type: .system)

    // MARK: - Init
    init(roles: [PlayerRole]) {
        self.roles = roles
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateForCurrentPlayer()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "역할 확인"
        navigationItem.hidesBackButton = true

        // Player Label
        playerLabel.font = UIFont.boldSystemFont(ofSize: 26)
        playerLabel.textAlignment = .center

        // Card View (보안 카드)
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 2.5
        cardView.layer.borderColor = UIColor.systemBlue.cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8

        // Question mark (숨김 상태)
        questionMarkLabel.text = "???"
        questionMarkLabel.font = UIFont.boldSystemFont(ofSize: 44)
        questionMarkLabel.textAlignment = .center
        questionMarkLabel.textColor = .systemGray2

        // Reveal Label (공개 시)
        revealLabel.font = UIFont.boldSystemFont(ofSize: 36)
        revealLabel.textAlignment = .center
        revealLabel.numberOfLines = 0
        revealLabel.alpha = 0

        // 카드 내부 레이아웃
        [questionMarkLabel, revealLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            questionMarkLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            questionMarkLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            revealLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            revealLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            revealLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            revealLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])

        // Hold Button (꾹 누르기)
        holdButton.setTitle("꾹 눌러서 확인 👆", for: .normal)
        holdButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        holdButton.backgroundColor = .systemBlue
        holdButton.setTitleColor(.white, for: .normal)
        holdButton.layer.cornerRadius = 16
        holdButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
        holdButton.addTarget(self, action: #selector(holdUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        // Hint Label
        hintLabel.text = "* 주변에 보이지 않게 혼자만 확인하세요!"
        hintLabel.font = UIFont.systemFont(ofSize: 13)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0

        // Next Button
        nextButton.setTitle("다음 플레이어 →", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextButton.backgroundColor = .systemGreen
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 16
        nextButton.addTarget(self, action: #selector(nextPlayer), for: .touchUpInside)

        // Layout
        [playerLabel, cardView, holdButton, hintLabel, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            playerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            playerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            playerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            cardView.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 28),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            cardView.heightAnchor.constraint(equalToConstant: 210),

            holdButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 28),
            holdButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            holdButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            holdButton.heightAnchor.constraint(equalToConstant: 58),

            hintLabel.topAnchor.constraint(equalTo: holdButton.bottomAnchor, constant: 12),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nextButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    // MARK: - State Update
    private func updateForCurrentPlayer() {
        let role = roles[currentIndex]
        playerLabel.text = "👤 플레이어 \(role.playerNumber)번 차례"
        revealLabel.text = role.keyword
        revealLabel.textColor = role.isLiar ? .systemRed : .systemBlue

        // 마지막 플레이어인 경우 버튼 변경
        let isLast = currentIndex == roles.count - 1
        let buttonTitle = isLast ? "🎮 게임 시작!" : "다음 플레이어 →"
        nextButton.setTitle(buttonTitle, for: .normal)
        nextButton.backgroundColor = isLast ? .systemOrange : .systemGreen

        // 카드 초기화
        questionMarkLabel.alpha = 1
        revealLabel.alpha = 0
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.borderColor = UIColor.systemBlue.cgColor
    }

    // MARK: - Actions
    @objc private func holdDown() {
        // touchDown: 손가락을 대고 있는 동안만 제시어 공개
        UIView.animate(withDuration: 0.15) {
            self.questionMarkLabel.alpha = 0
            self.revealLabel.alpha = 1
            let isLiar = self.roles[self.currentIndex].isLiar
            self.cardView.backgroundColor = isLiar
                ? UIColor.systemRed.withAlphaComponent(0.12)
                : UIColor.systemBlue.withAlphaComponent(0.12)
            self.cardView.layer.borderColor = isLiar
                ? UIColor.systemRed.cgColor
                : UIColor.systemBlue.cgColor
        }
    }

    @objc private func holdUp() {
        // touchUpInside / touchUpOutside / touchCancel: 손을 떼면 즉시 숨김
        UIView.animate(withDuration: 0.15) {
            self.questionMarkLabel.alpha = 1
            self.revealLabel.alpha = 0
            self.cardView.backgroundColor = .secondarySystemBackground
            self.cardView.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }

    @objc private func nextPlayer() {
        if currentIndex < roles.count - 1 {
            currentIndex += 1
            updateForCurrentPlayer()
        } else {
            // 모든 인원 확인 완료 → TimerVC로 이동
            let liarRoles = roles.filter { $0.isLiar }
            let keyword = roles.first(where: { !$0.isLiar })?.keyword ?? ""
            let timerVC = TimerViewController(liarRoles: liarRoles, keyword: keyword)
            navigationController?.pushViewController(timerVC, animated: true)
        }
    }
}
