import UIKit

class HomeViewController: UIViewController {

    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let totalPlayersTitleLabel = UILabel()
    private let totalPlayersLabel = UILabel()
    private let totalPlayersStepper = UIStepper()
    private let liarCountTitleLabel = UILabel()
    private let liarCountLabel = UILabel()
    private let liarCountStepper = UIStepper()
    private let categoryTitleLabel = UILabel()
    private let categorySegmentedControl = UISegmentedControl(items: ["음식", "영화", "동물"])
    private let startButton = UIButton(type: .system)

    // MARK: - Data
    private var settings = GameSettings()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.04)

        // Title
        titleLabel.text = "🎭 LIAR MASTER"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemIndigo

        // Total Players Section
        totalPlayersTitleLabel.text = "총 인원 설정"
        totalPlayersTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        totalPlayersLabel.text = "\(settings.totalPlayers)명"
        totalPlayersLabel.font = UIFont.boldSystemFont(ofSize: 26)
        totalPlayersLabel.textAlignment = .center
        totalPlayersLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true

        totalPlayersStepper.minimumValue = 3
        totalPlayersStepper.maximumValue = 10
        totalPlayersStepper.value = Double(settings.totalPlayers)
        totalPlayersStepper.addTarget(self, action: #selector(totalPlayersChanged), for: .valueChanged)

        // Liar Count Section
        liarCountTitleLabel.text = "라이어 인원"
        liarCountTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        liarCountLabel.text = "\(settings.liarCount)명"
        liarCountLabel.font = UIFont.boldSystemFont(ofSize: 26)
        liarCountLabel.textAlignment = .center
        liarCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true

        liarCountStepper.minimumValue = 1
        liarCountStepper.maximumValue = Double(settings.totalPlayers - 1)
        liarCountStepper.value = Double(settings.liarCount)
        liarCountStepper.addTarget(self, action: #selector(liarCountChanged), for: .valueChanged)

        // Category Section
        categoryTitleLabel.text = "카테고리 선택"
        categoryTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)

        // Start Button
        startButton.setTitle("🎮  게임 시작", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.backgroundColor = .systemIndigo
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 16
        startButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        startButton.layer.shadowRadius = 8
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)

        // Build StackView hierarchy
        let totalPlayersRow = makeRowStack(left: totalPlayersLabel, right: totalPlayersStepper)
        let liarCountRow = makeRowStack(left: liarCountLabel, right: liarCountStepper)

        let mainStack = UIStackView(arrangedSubviews: [
            titleLabel,
            makeSeparator(),
            totalPlayersTitleLabel,
            totalPlayersRow,
            makeSeparator(),
            liarCountTitleLabel,
            liarCountRow,
            makeSeparator(),
            categoryTitleLabel,
            categorySegmentedControl,
            makeSeparator(),
            startButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        startButton.heightAnchor.constraint(equalToConstant: 58).isActive = true

        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    private func makeRowStack(left: UIView, right: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }

    private func makeSeparator() -> UIView {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }

    // MARK: - Actions
    @objc private func totalPlayersChanged() {
        settings.totalPlayers = Int(totalPlayersStepper.value)
        totalPlayersLabel.text = "\(settings.totalPlayers)명"
        // 라이어 수가 총 인원 이상이 되지 않도록 자동 제한
        liarCountStepper.maximumValue = Double(settings.totalPlayers - 1)
        if settings.liarCount >= settings.totalPlayers {
            settings.liarCount = settings.totalPlayers - 1
            liarCountStepper.value = Double(settings.liarCount)
            liarCountLabel.text = "\(settings.liarCount)명"
        }
    }

    @objc private func liarCountChanged() {
        settings.liarCount = Int(liarCountStepper.value)
        liarCountLabel.text = "\(settings.liarCount)명"
    }

    @objc private func categoryChanged() {
        let categories = ["음식", "영화", "동물"]
        settings.category = categories[categorySegmentedControl.selectedSegmentIndex]
    }

    @objc private func startGame() {
        guard settings.liarCount < settings.totalPlayers else {
            let alert = UIAlertController(
                title: "설정 오류",
                message: "라이어 수는 총 인원보다 적어야 합니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }

        let roles = generateRoles(settings: settings)
        let cardVC = CardViewController(roles: roles)
        navigationController?.pushViewController(cardVC, animated: true)
    }
}
