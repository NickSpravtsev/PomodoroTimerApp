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

    // Bool flags
    private var isWorkTime = true
    private var isTimerStarted = false

    // Timer
    private var timer: Timer?
    private var workSeconds = 25
    private var restSeconds = 5
    private var currentSecondsRemain = 25
    private var accurateTimerCount = 1000

    // Progress bar
    private lazy var circularProgressBarView = CircularProgressBarView(frame: .zero)
    private var circularViewDuration = 5

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

        if currentSecondsRemain < 0 {
            timer?.invalidate()
        } else {
            currentSecondsRemain -= 1
            timerLabel.text = timeInSecondsToString(seconds: currentSecondsRemain)
            if currentSecondsRemain == -1 {
                timerLabel.text = timeInSecondsToString(seconds: 0)
                timer?.invalidate()
                changeTimePeriod()
            }
        }
    }

    private func changeTimePeriod() {
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
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale

        button.addTarget(self, action: #selector(controlButtonPressed), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func setupHierarchy(){
        view.addSubview(timerLabel)
        view.addSubview(controlButton)
    }

    private func setupLayout() {
        setupTimerLabel()
        setupControlButton()
        setupCircularProgressBarView(color: UIColor.systemRed, duration: currentSecondsRemain, autostart: false, clockwise: true)
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
}
