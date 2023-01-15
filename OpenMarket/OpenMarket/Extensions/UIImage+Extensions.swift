//
//  UIImage+Extensions.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

import UIKit

extension UIImage {
    func compress() -> Data? {
        guard var compressedImage = self.jpegData(compressionQuality: 0.2) else {
            return nil
        }

        while compressedImage.count > 307200 {
            compressedImage = UIImage(data: compressedImage)?.jpegData(compressionQuality: 0.5) ?? Data()
        }

        return compressedImage
    }

    func configureSquareImageView() -> UIView {
        let view = UIView()
        let imageView = configureProfileImageView(with: self)
        let button = configureDeleteButton()

        view.addSubview(imageView)
        view.addSubview(button)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor,
                                           constant: 10),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: -10),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                            constant: 10),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: -10),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        return view
    }

    private func configureProfileImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }

    private func configureDeleteButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"),
                        for: .normal)
        button.imageView?.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDeleteButton),
                         for: .touchDown)

        return button
    }

    @objc private func didTapDeleteButton(_ sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }
}
