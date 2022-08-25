//
//  ViewController.swift
//  PomodoroTimerApp
//
//  Created by Nick Spravtsev on 24.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties

    // Lock portrait screen orientation
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // Bool flags
    private var isWorkTime = true
    private var isTimerStarted = false

    // Timer
    private var timer: Timer?
    private var workSeconds = 25
    private var restSeconds = 5
    private var currentSecondsRemain = 0
    private var accurateTimerCount = 1000

    // Progress bar
    private lazy var circularProgressBarView = CircularProgressBarView(frame: .zero)

    // MARK: - Methods

    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(updateViewByTimer)), userInfo: nil, repeats: true)
    }

    @objc private func updateViewByTimer() {

        // To improve accuration of timer
        if accurateTimerCount > 0 {
            accurateTimerCount -= 1
            return
        }

        accurateTimerCount = 1000

        if currentSecondsRemain < 1 {
            timer?.invalidate()
        } else {
            currentSecondsRemain -= 1
            timerLabel.text = timeInSecondsToString(seconds: currentSecondsRemain)
            if currentSecondsRemain == 0 {
                timerLabel.text = timeInSecondsToString(seconds: 0)
                timer?.invalidate()
                autoChangeTimePeriod()
            }
        }
    }

    private func autoChangeTimePeriod() {
        if isWorkTime {
            isWorkTime = false
            controlButton.tintColor = .systemGreen
            timerLabel.textColor = .systemGreen
            timerLabel.text = timeInSecondsToString(seconds: restSeconds)
            setupCircularProgressBarView(color: .systemGreen, duration: restSeconds, autostart: true, clockwise: false)
            currentSecondsRemain = restSeconds
            accurateTimerCount = 1000
            runTimer()
        } else {
            isWorkTime = true
            controlButton.tintColor = .systemRed
            timerLabel.textColor = .systemRed
            timerLabel.text = timeInSecondsToString(seconds: workSeconds)
            setupCircularProgressBarView(color: .systemRed, duration: workSeconds, autostart: true, clockwise: true)
            currentSecondsRemain = workSeconds
            accurateTimerCount = 1000
            runTimer()
        }
    }

    private func goToNextTimePeriod() {
        if isWorkTime {
            isWorkTime = false
            isTimerStarted = false
            controlButton.tintColor = .systemGreen
            controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timerLabel.textColor = .systemGreen
            timerLabel.text = timeInSecondsToString(seconds: restSeconds)
            setupCircularProgressBarView(color: .systemGreen, duration: restSeconds, autostart: false, clockwise: false)
            currentSecondsRemain = restSeconds
            accurateTimerCount = 1000
            timer?.invalidate()
        } else {
            isWorkTime = true
            isTimerStarted = false
            controlButton.tintColor = .systemRed
            controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timerLabel.textColor = .systemRed
            timerLabel.text = timeInSecondsToString(seconds: workSeconds)
            setupCircularProgressBarView(color: .systemRed, duration: workSeconds, autostart: false, clockwise: true)
            currentSecondsRemain = workSeconds
            accurateTimerCount = 1000
            timer?.invalidate()
        }
    }

    private func repeatCurrentTimePeriod() {
        if isWorkTime {
            isTimerStarted = false
            controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timerLabel.text = timeInSecondsToString(seconds: workSeconds)
            setupCircularProgressBarView(color: .systemRed, duration: workSeconds, autostart: false, clockwise: true)
            currentSecondsRemain = workSeconds
            timer?.invalidate()
        } else {
            isTimerStarted = false
            controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timerLabel.text = timeInSecondsToString(seconds: restSeconds)
            setupCircularProgressBarView(color: .systemGreen, duration: restSeconds, autostart: false, clockwise: false)
            currentSecondsRemain = restSeconds
            accurateTimerCount = 1000
            timer?.invalidate()
        }
    }

    private func timeInSecondsToString(seconds: Int) -> String {
        let time = TimeInterval(seconds)
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: time) ?? "00:00"
    }

    // MARK: - Outlets

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = timeInSecondsToString(seconds: currentSecondsRemain)
        label.font = UIFont.systemFont(ofSize: 70)
        label.textColor = .systemRed

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var controlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .systemRed

        button.layer.cornerRadius = 20

        // Making shadow for button
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale

        button.addTarget(self, action: #selector(controlButtonPressed), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "backward.frame"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .systemGray

        button.addTarget(self, action: #selector(backwardButtonPressed), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.frame"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .systemGray

        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Pomodoro"
        label.textColor = .systemRed
        label.font = UIFont.boldSystemFont(ofSize: 42)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var logoImageView: UIImageView = {
        let image = UIImage(systemName: "timer", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemRed

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        currentSecondsRemain = workSeconds
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func setupHierarchy(){
        view.addSubview(timerLabel)
        view.addSubview(controlButton)
        view.addSubview(backwardButton)
        view.addSubview(nextButton)
        view.addSubview(appNameLabel)
        view.addSubview(logoImageView)
    }

    private func setupLayout() {
        setupTimerLabel()
        setupControlButton()
        setupCircularProgressBarView(color: UIColor.systemRed, duration: currentSecondsRemain, autostart: false, clockwise: true)
        setupBackwardButton()
        setupNextButton()
        setupAppNameLabel()
        setupLogoImageView()
    }

    private func setupTimerLabel() {
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
    }

    private func setupControlButton() {
        controlButton.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(170)
            make.centerX.equalTo(view)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
    }

    private func setupBackwardButton() {
        backwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(controlButton.snp.centerY)
            make.right.equalTo(controlButton.snp.left).offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }

    private func setupNextButton() {
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(controlButton.snp.centerY)
            make.left.equalTo(controlButton.snp.right).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }

    private func setupAppNameLabel() {
        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(timerLabel.snp.top).offset(-220)
        }
    }

    private func setupLogoImageView() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
        }
    }

    private func setupCircularProgressBarView(color: UIColor, duration: Int, autostart: Bool, clockwise: Bool) {
        circularProgressBarView.createCircularPath(color: color, clockwise: clockwise)
        circularProgressBarView.center = view.center
        circularProgressBarView.progressAnimation(duration: TimeInterval(duration), autostart: autostart)
        view.addSubview(circularProgressBarView)
    }

    // MARK: - Actions

    @objc private func controlButtonPressed() {

        if isTimerStarted {
            timer?.invalidate()
            controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)

            circularProgressBarView.pauseAnimation()
            
            isTimerStarted = false
        } else {
            runTimer()
            controlButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)

            circularProgressBarView.resumeAnimation()

            isTimerStarted = true
        }
    }

    @objc private func backwardButtonPressed() {
        repeatCurrentTimePeriod()
    }

    @objc private func nextButtonPressed() {
        goToNextTimePeriod()
    }
}
