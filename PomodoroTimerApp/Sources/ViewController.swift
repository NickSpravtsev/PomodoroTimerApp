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
    var isWorkTime = true
    var isStarted = false

    //Timer
    var timer = Timer()
    var workCount = 25
    var restCount = 5
    var currentCount = 25

    // MARK: - Methods

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        currentCount -= 1
        timerLabel.text = timeCountToString(time: TimeInterval(currentCount))
    }

    func timeCountToString(time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: time) ?? "00:00"
    }

    // MARK: - Outlets

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:25"
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

        if isStarted {
            timer.invalidate()
            controlButton.setImage(UIImage(systemName: "play"), for: .normal)
            isStarted = false
        } else {
            runTimer()
            controlButton.setImage(UIImage(systemName: "pause"), for: .normal)
            isStarted = true
        }
    }
}
