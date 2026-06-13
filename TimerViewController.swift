import UIKit

class TimerViewController: UIViewController {

    // MARK: - Data
    private let totalTime: TimeInterval = 180  // 3분
    private var remainingTime: TimeInterval = 180
    private var timer: Timer?
    private let liarRoles: [PlayerRole]
    private let keyword: String

    // MARK: - UI Components
    private let infoLabel = UILabel()
    private let timerLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let startButton = UIButton(type: .system)

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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "게임 진행"
        navigationItem.hidesBackButton = true

        // Info Label
        infoLabel.text = "토론을 시작하세요!\n라이어를 찾아내세요 🕵️"
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .secondaryLabel

        // Timer Label
        timerLabel.text = "3:00"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 88, weight: .bold)
        timerLabel.textAlignment = .center
        timerLabel.textColor = .label

        // Progress View
        progressView.progress = 1.0
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        // 두껍게 표시
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)

        // Start Button
        startButton.setTitle("▶  타이머 시작", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 16
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [infoLabel, timerLabel, progressView, startButton])
        stack.axis = .vertical
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false

        startButton.heightAnchor.constraint(equalToConstant: 58).isActive = true

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
    }

    // MARK: - Timer Logic
    @objc private func startTimer() {
        startButton.isEnabled = false
        startButton.backgroundColor = .systemGray3
        startButton.setTitle("진행 중...", for: .normal)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        remainingTime -= 1
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        timerLabel.text = String(format: "%d:%02d", minutes, seconds)
        progressView.setProgress(Float(remainingTime / totalTime), animated: true)

        // 30초 이하: 빨간색으로 경고
        if remainingTime <= 30 {
            timerLabel.textColor = .systemRed
            progressView.progressTintColor = .systemRed
            // 깜빡임 효과
            UIView.animate(withDuration: 0.3, animations: {
                self.timerLabel.alpha = 0.4
            }) { _ in
                UIView.animate(withDuration: 0.3) { self.timerLabel.alpha = 1.0 }
            }
        }

        if remainingTime <= 0 {
            timer?.invalidate()
            timeUp()
        }
    }

    private func timeUp() {
        let alert = UIAlertController(
            title: "⏰ 시간 종료!",
            message: "이제 라이어를 지목하세요!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "결과 보기 →", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let resultVC = ResultViewController(liarRoles: self.liarRoles, keyword: self.keyword)
            self.navigationController?.pushViewController(resultVC, animated: true)
        })
        present(alert, animated: true)
    }
}
