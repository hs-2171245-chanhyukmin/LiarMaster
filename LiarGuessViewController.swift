import UIKit

class LiarGuessViewController: UIViewController {

    // MARK: - Data
    private let liarRoles: [PlayerRole]
    private let keyword: String

    // MARK: - UI
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let warningLabel = UILabel()
    private let cardView = UIView()
    private let textField = UITextField()
    private let confirmButton = UIButton(type: .system)

    // MARK: - Init
    init(liarRoles: [PlayerRole], keyword: String) {
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
        title = "라이어 반격"
        navigationItem.hidesBackButton = true
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Title
        titleLabel.text = "🎯 라이어 반격 기회!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemIndigo

        // Description
        descLabel.text = "라이어를 잡았습니다!\n라이어가 제시어를 맞추면 역전!"
        descLabel.font = UIFont.systemFont(ofSize: 17)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.textColor = .secondaryLabel

        // Warning
        warningLabel.text = "⚠️ 다른 플레이어들은 화면을 보지 마세요!"
        warningLabel.font = UIFont.boldSystemFont(ofSize: 14)
        warningLabel.textAlignment = .center
        warningLabel.textColor = .systemOrange
        warningLabel.numberOfLines = 0

        // Card View
        cardView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.06)
        cardView.layer.cornerRadius = 20
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.systemIndigo.withAlphaComponent(0.3).cgColor

        // TextField
        textField.placeholder = "제시어를 입력하세요"
        textField.font = UIFont.boldSystemFont(ofSize: 22)
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20)
        ])

        // Confirm Button
        confirmButton.setTitle("정답 제출 →", for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        confirmButton.backgroundColor = .systemIndigo
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 16
        confirmButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        confirmButton.layer.shadowOpacity = 0.3
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        confirmButton.layer.shadowRadius = 8
        confirmButton.addTarget(self, action: #selector(submitGuess), for: .touchUpInside)

        // Layout
        [titleLabel, descLabel, warningLabel, cardView, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            warningLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            cardView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 36),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            cardView.heightAnchor.constraint(equalToConstant: 100),

            confirmButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 32),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            confirmButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    // MARK: - Actions
    @objc private func submitGuess() {
        let guess = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !guess.isEmpty else {
            textField.placeholder = "제시어를 입력해주세요!"
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }

        let isCorrect = guess == keyword
        let outcome: GameOutcome = isCorrect ? .liarWinsGuess : .citizensWin
        let resultVC = ResultViewController(liarRoles: liarRoles, keyword: keyword, outcome: outcome)
        navigationController?.pushViewController(resultVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LiarGuessViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitGuess()
        return true
    }
}
