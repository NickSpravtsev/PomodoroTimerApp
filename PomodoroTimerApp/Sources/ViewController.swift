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

    //Timer
    private var timer = Timer()
    private var workSeconds = 25
    private var restSeconds = 5
    private var currentSecondsRemain = 5

    // MARK: - Methods

    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(updateViewByTimer)), userInfo: nil, repeats: true)
    }

    @objc private func updateViewByTimer() {
        if currentSecondsRemain < 1 {
            timer.invalidate()
        } else {
            currentSecondsRemain -= 1
            timerLabel.text = timeCountToString(seconds: currentSecondsRemain)
            if currentSecondsRemain == 0 {
                timer.invalidate()
            }
        }
    }

    private func timeCountToString(seconds: Int) -> String {
        let time = TimeInterval(seconds)
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: time) ?? "00:00"
    }

    // MARK: - Outlets

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = timeCountToString(seconds: workSeconds)
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .systemRed

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var controlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .systemRed

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
    }

    private func setupTimerLabel() {
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
    }

    private func setupControlButton() {
        controlButton.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }

    // MARK: - Actions

    @objc private func controlButtonPressed() {

        if isTimerStarted {
            timer.invalidate()
            controlButton.setImage(UIImage(systemName: "play"), for: .normal)
            isTimerStarted = false
        } else {
            runTimer()
            controlButton.setImage(UIImage(systemName: "pause"), for: .normal)
            isTimerStarted = true
        }
    }
}
