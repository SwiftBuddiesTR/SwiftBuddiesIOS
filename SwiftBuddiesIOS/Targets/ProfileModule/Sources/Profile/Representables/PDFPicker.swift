//
//  PDFPicker.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct PDFPicker: UIViewControllerRepresentable {
    @Binding var selectedPDFURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: PDFPicker

        init(_ parent: PDFPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let firstURL = urls.first else { return }
            parent.selectedPDFURL = firstURL
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Kullanıcı iptal ettiğinde herhangi bir işlem yapmanız gerekirse buraya ekleyin.
        }
    }
}
