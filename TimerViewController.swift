import UIKit

class TimerViewController: UIViewController {

    // MARK: - Data
    private let totalTime: TimeInterval = 180  // 3분
    private var remainingTime: TimeInterval = 180
    private var timer: Timer?
    private let liarRoles: [PlayerRole]
    private let keyword: String
    private let totalPlayers: Int

    // MARK: - UI Components
    private let infoLabel = UILabel()
    private let timerLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let startButton = UIButton(type: .system)
    private let endButton = UIButton(type: .system)

    // MARK: - Init
    init(totalPlayers: Int, liarRoles: [PlayerRole], keyword: String) {
        self.totalPlayers = totalPlayers
        self.liarRoles = liarRoles
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "게임 진행"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "처음으로",
            style: .plain,
            target: self,
            action: #selector(goHome)
        )

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
        progressView.progressTintColor = .systemIndigo
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        // 두껍게 표시
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)

        // Start Button
        startButton.setTitle("▶  타이머 시작", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.backgroundColor = .systemIndigo
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 16
        startButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        startButton.layer.shadowRadius = 8
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)

        // End Button (조기 종료)
        endButton.setTitle("🗳  지금 투표하기", for: .normal)
        endButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        endButton.backgroundColor = .systemOrange
        endButton.setTitleColor(.white, for: .normal)
        endButton.layer.cornerRadius = 16
        endButton.isHidden = true  // 타이머 시작 전엔 숨김
        endButton.addTarget(self, action: #selector(endEarly), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [infoLabel, timerLabel, progressView, startButton, endButton])
        stack.axis = .vertical
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false

        startButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        endButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

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
        endButton.isHidden = false  // 타이머 시작되면 조기 종료 버튼 표시

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
        alert.addAction(UIAlertAction(title: "투표하기 →", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let voteVC = VoteViewController(totalPlayers: self.totalPlayers, liarRoles: self.liarRoles, keyword: self.keyword)
            self.navigationController?.pushViewController(voteVC, animated: true)
        })
        present(alert, animated: true)
    }

    @objc private func goHome() {
        let alert = UIAlertController(
            title: "처음으로 돌아가기",
            message: "게임을 종료하고 설정 화면으로 돌아가시겠어요?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "처음으로", style: .destructive) { [weak self] _ in
            self?.timer?.invalidate()
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }

    @objc private func endEarly() {
        let alert = UIAlertController(
            title: "투표 시작",
            message: "타이머를 종료하고 라이어를 지목하시겠어요?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "투표하기", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.timer?.invalidate()
            let voteVC = VoteViewController(totalPlayers: self.totalPlayers, liarRoles: self.liarRoles, keyword: self.keyword)
            self.navigationController?.pushViewController(voteVC, animated: true)
        })
        present(alert, animated: true)
    }
}
