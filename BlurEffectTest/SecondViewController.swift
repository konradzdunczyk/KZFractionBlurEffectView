//
//  SecondViewController.swift
//  BlurEffectTest
//
//  Created by Konrad Zdunczyk on 11/11/2019.
//  Copyright © 2019 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var effectStyle: EffectStyle = EffectStyle.style(for: 0)
    var blurStyle: BlurEffectStyle = BlurEffectStyle.style(for: 0)

    var duration: TimeInterval = 0.3
    var target: CGFloat = 0.3
    var manualProgress: CGFloat = 0.0

    var effectView: KZFractionBlurEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDisplayButton()
        resetEffectView()
    }

    private func resetEffectView() {
        effectView?.removeFromSuperview()
        effectView = nil

        if effectStyle == .hide {
            return
        }

        effectView = {
            let v = KZFractionBlurEffectView(blurStyle: blurStyle.uiKitStyle)
            v.translatesAutoresizingMaskIntoConstraints = false

            return v
        }()

        view.addSubview(effectView)

        let c = [
            effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            effectView.topAnchor.constraint(equalTo: view.topAnchor),
        ]

        NSLayoutConstraint.activate(c)

        effectView.fractionComplete = manualProgress
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

extension SecondViewController: SettingsViewControllerDelegate {
    func settingsViewController(_ vc: SettingsViewController, changedProgress progress: CGFloat) {
        self.manualProgress = progress
        effectView?.fractionComplete = progress
    }

    func settingsViewController(_ vc: SettingsViewController, changedTarget target: CGFloat) {
        self.target = target
    }

    func settingsViewControllerChangedSettings(_ vc: SettingsViewController, effectStyle: EffectStyle, blurStyle: BlurEffectStyle) {
        self.effectStyle = effectStyle
        self.blurStyle = blurStyle

        resetEffectView()
    }

    func settingsViewControllerBlurIn(_ vc: SettingsViewController) {
        effectView?.blurIn(to: self.target,
                           duration: duration)
    }

    func settingsViewControllerBlurOut(_ vc: SettingsViewController) {
        effectView?.blurOut(duration: duration)
    }
}

extension SecondViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
