//
//  SettingsViewController.swift
//  BlurEffectTest
//
//  Created by Konrad Zdunczyk on 11/11/2019.
//  Copyright © 2019 Konrad Zdunczyk. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerChangedSettings(_ vc: SettingsViewController, effectStyle: EffectStyle, blurStyle: BlurEffectStyle)
    func settingsViewController(_ vc: SettingsViewController, changedProgress progress: CGFloat)
    func settingsViewController(_ vc: SettingsViewController, changedTarget target: CGFloat)

    func settingsViewControllerBlurIn(_ vc: SettingsViewController)
    func settingsViewControllerBlurOut(_ vc: SettingsViewController)
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?

    @IBOutlet var contentSV: UIStackView!
    @IBOutlet var effectStyleSC: UISegmentedControl!
    @IBOutlet var blurStyleSC: UISegmentedControl!

    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var targetSlider: UISlider!

    @IBOutlet var progressValue: UILabel!
    @IBOutlet var progressSlider: UISlider!

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    func setupState(effectStyle: EffectStyle, blurStyle: BlurEffectStyle) {
        effectStyleSC.selectedSegmentIndex = effectStyle.index
        blurStyleSC.selectedSegmentIndex = blurStyle.index
    }

    func setupProgress(_ progress: CGFloat, andTarget target: CGFloat) {
        progressSlider.value = Float(progress)
        targetSlider.value = Float(target)

        setProgressLabel()
        setTargetLabel()
    }

    @IBAction private func blurIn(_ sender: UIButton) {
        delegate?.settingsViewControllerBlurIn(self)
    }

    @IBAction private func blurOut(_ sender: UIButton) {
        delegate?.settingsViewControllerBlurOut(self)
    }

    @objc private func settingsDidChange() {
        notifyDelegate()
    }

    @objc private func progressDidChange() {
        setProgressLabel()
        delegate?.settingsViewController(self,
                                         changedProgress: CGFloat(progressSlider.value))
    }

    @objc private func targetDidChange() {
        setTargetLabel()
        delegate?.settingsViewController(self, changedTarget: CGFloat(targetSlider.value))
    }

    private func setupViews() {
        effectStyleSC.removeAllSegments()
        for c in EffectStyle.allCases.reversed() {
            effectStyleSC.insertSegment(withTitle: c.name, at: 0, animated: false)
        }

        blurStyleSC.removeAllSegments()
        for c in BlurEffectStyle.allCases.reversed() {
            blurStyleSC.insertSegment(withTitle: c.name, at: 0, animated: false)
        }

        effectStyleSC.addTarget(self,
                                action: #selector(settingsDidChange),
                                for: .valueChanged)

        blurStyleSC.addTarget(self,
                              action: #selector(settingsDidChange),
                              for: .valueChanged)

        progressSlider.addTarget(self,
                                 action: #selector(progressDidChange),
                                 for: .valueChanged)

        targetSlider.addTarget(self,
                               action: #selector(targetDidChange),
                               for: .valueChanged)

        setProgressLabel()
        setTargetLabel()

        contentSV.setNeedsLayout()
        contentSV.layoutIfNeeded()
    }

    private func setProgressLabel() {
        let valueStr = numberFormatter.string(from: NSNumber(value: progressSlider.value)) ?? "0.00"

        progressValue.text = "Manual progress: \(valueStr)"
    }

    private func setTargetLabel() {
        let valueStr = numberFormatter.string(from: NSNumber(value: targetSlider.value)) ?? "0.00"

        targetLabel.text = "Target: \(valueStr)"
    }

    private func notifyDelegate() {
        let effectStyle = EffectStyle.style(for: effectStyleSC.selectedSegmentIndex)
        let blurStyle = BlurEffectStyle.style(for: blurStyleSC.selectedSegmentIndex)

        delegate?.settingsViewControllerChangedSettings(self,
                                                        effectStyle: effectStyle,
                                                        blurStyle: blurStyle)
    }
}
