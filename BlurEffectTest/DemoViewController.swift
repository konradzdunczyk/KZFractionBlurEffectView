//
//  DemoViewController.swift
//  BlurEffectTest
//
//  Created by Konrad Zdunczyk on 11/11/2019.
//  Copyright © 2019 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    private var effectStyle: EffectStyle = EffectStyle.style(for: 0)
    private var blurStyle: BlurEffectStyle = BlurEffectStyle.style(for: 0)

    private var duration: TimeInterval = 0.3
    private var target: CGFloat = 0.3
    private var manualProgress: CGFloat = 0.0

    private let effectView: KZFractionBlurEffectView = {
        let v = KZFractionBlurEffectView()
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDisplayButton()
        setupEffectView()
    }

    private func setupEffectView() {
        view.addSubview(effectView)

        let c = [
            effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            effectView.topAnchor.constraint(equalTo: view.topAnchor),
        ]

        NSLayoutConstraint.activate(c)

        effectView.blurIntensity = manualProgress
        effectView.blurStyle = blurStyle.uiKitStyle
        effectView.isHidden = effectStyle == .hide

        effectView.backgroundColor = .black // no effect
    }

    private func setupDisplayButton() {
        let displayButton = UIBarButtonItem(title: "Settings",
                                            style: .plain,
                                            target: self,
                                            action: #selector(displaySettings(sender:)))

        navigationItem.leftBarButtonItem = displayButton
    }

    @objc private func displaySettings(sender: UIBarButtonItem) {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.delegate = self
        popover.barButtonItem = sender
        present(vc, animated: true, completion:nil)

        vc.setupState(effectStyle: effectStyle, blurStyle: blurStyle)
        vc.setupProgress(manualProgress, andTarget: target)
        vc.delegate = self
    }
}

extension DemoViewController: SettingsViewControllerDelegate {
    func settingsViewController(_ vc: SettingsViewController, changedProgress progress: CGFloat) {
        self.manualProgress = progress
        effectView.blurIntensity = progress
    }

    func settingsViewController(_ vc: SettingsViewController, changedTarget target: CGFloat) {
        self.target = target
    }

    func settingsViewControllerChangedSettings(_ vc: SettingsViewController, effectStyle: EffectStyle, blurStyle: BlurEffectStyle) {
        self.effectStyle = effectStyle
        self.blurStyle = blurStyle

        effectView.blurStyle = blurStyle.uiKitStyle
        effectView.isHidden = effectStyle == .hide
    }

    func settingsViewControllerBlurIn(_ vc: SettingsViewController) {
        effectView.blurIn(to: target,
                          duration: duration)
    }

    func settingsViewControllerBlurOut(_ vc: SettingsViewController) {
        effectView.blurOut(duration: duration)
    }
}

extension DemoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
