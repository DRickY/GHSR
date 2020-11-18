//
//  PreviewUIKit.swift
//  SERW
//
//  Created by Dmytro.k on 11/15/20.
//

import SwiftUI

struct UIViewPreview<V: UIView>: View {
    private let factory: () -> V
    
    public init(factory: @escaping () -> V) {
        self.factory = factory
    }
    
    var body: some View {
        UIRenderer(factory: self.factory)
    }
}

private struct UIRenderer<V: UIView>: UIViewRepresentable {
    
    private let factory: () -> V
    
    init(factory: @escaping () -> V) {
        self.factory = factory
    }

    func makeUIView(context: Context) -> V {
        return self.factory()
    }
    
    func updateUIView(_ view: V, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

public struct UIViewControllerPreview<ViewController: UIViewController>: View {
    private let factory: () -> ViewController

    init(_ factory: @escaping () -> ViewController) {
        self.factory = factory
    }
    public var body: some View {
        ControllerRenderer(factory: self.factory)
    }
}

private struct ControllerRenderer<ViewController: UIViewController>: UIViewControllerRepresentable {
    private let factory: () -> ViewController
    
    init(factory: @escaping () -> ViewController) {
        self.factory = factory
    }
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        self.factory()
    }
    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<ControllerRenderer<ViewController>>) {
        
        return
    }
}
