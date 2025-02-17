//
//  ShareView.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
