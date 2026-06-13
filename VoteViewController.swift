import UIKit

class VoteViewController: UIViewController {

    // MARK: - Data
    private let totalPlayers: Int
    private let liarRoles: [PlayerRole]
    private let keyword: String
    private var selectedPlayer: Int? = nil

    // MARK: - UI
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var playerButtons: [UIButton] = []
    private let confirmButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    // MARK: - Init
    init(totalPlayers: Int, liarRoles: [PlayerRole], keyword: String) {
        self.totalPlayers = totalPlayers
        self.liarRoles = liarRoles
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        title = "라이어 지목"
        navigationItem.hidesBackButton = true
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Title
        titleLabel.text = "🕵️ 라이어를 지목하세요!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.textAlignment = .center

        subtitleLabel.text = "가장 의심되는 플레이어를 선택하세요"
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        // Player Buttons
        stackView.axis = .vertical
        stackView.spacing = 12

        for i in 1...totalPlayers {
            let btn = UIButton(type: .system)
            btn.setTitle("플레이어 \(i)번", for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            btn.setTitleColor(.label, for: .normal)
            btn.backgroundColor = UIColor.systemGray6
            btn.layer.cornerRadius = 14
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor.clear.cgColor
            btn.heightAnchor.constraint(equalToConstant: 56).isActive = true
            btn.tag = i
            btn.addTarget(self, action: #selector(playerTapped(_:)), for: .touchUpInside)
            playerButtons.append(btn)
            stackView.addArrangedSubview(btn)
        }

        // Confirm Button
        confirmButton.setTitle("결과 확인 →", for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        confirmButton.backgroundColor = UIColor.systemGray3
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 16
        confirmButton.isEnabled = false
        confirmButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        confirmButton.addTarget(self, action: #selector(confirmVote), for: .touchUpInside)

        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        // Header
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerStack)
        view.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            scrollView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            scrollView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Actions
    @objc private func playerTapped(_ sender: UIButton) {
        selectedPlayer = sender.tag

        // 모든 버튼 초기화
        playerButtons.forEach {
            $0.backgroundColor = UIColor.systemGray6
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.setTitleColor(.label, for: .normal)
        }

        // 선택된 버튼 강조
        sender.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.12)
        sender.layer.borderColor = UIColor.systemIndigo.cgColor
        sender.setTitleColor(.systemIndigo, for: .normal)

        // 확인 버튼 활성화
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = .systemIndigo
        confirmButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        confirmButton.layer.shadowOpacity = 0.3
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        confirmButton.layer.shadowRadius = 8
    }

    @objc private func confirmVote() {
        guard let selected = selectedPlayer else { return }
        let resultVC = ResultViewController(
            liarRoles: liarRoles,
            keyword: keyword,
            votedPlayerNumber: selected
        )
        navigationController?.pushViewController(resultVC, animated: true)
    }
}
