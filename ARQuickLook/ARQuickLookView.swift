//
//  ARQuickLookView.swift
//  ARQuickLook
//
//  Created by Zaid Neurothrone on 2022-12-24.
//

import ARKit
import SwiftUI
import QuickLook

struct ARQuickLookView: UIViewControllerRepresentable {
  // Properties: the file name (without extension), and whether we'll let the user scale the preview content.
  var name: String
  var allowScaling: Bool = true
  
  func makeCoordinator() -> Coordinator {
    // The coordinator object implements the mechanics of dealing with
    // the live UIKit view controller.
    .init(self)
  }
  
  func makeUIViewController(context: Context) -> QLPreviewController {
    // Create the preview controller, and assign our Coordinator class
    // as its data source.
    let controller = QLPreviewController()
    controller.dataSource = context.coordinator
    return controller
  }
  
  func updateUIViewController(
    _ controller: QLPreviewController,
    context: Context
  ) {
    // nothing to do here
  }
}


final class Coordinator: NSObject {
  let parent: ARQuickLookView
  
  private lazy var fileURL: URL = Bundle.main.url(
    forResource: parent.name,
    withExtension: "usdz")!
  
  init(_ parent: ARQuickLookView) {
    self.parent = parent
    
    super.init()
  }
}

extension Coordinator: QLPreviewControllerDataSource {
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    1
  }
  
  func previewController(
    _ controller: QLPreviewController,
    previewItemAt index: Int
  ) -> QLPreviewItem {
    guard let fileURL = Bundle.main.url(forResource: parent.name, withExtension: "usdz") else {
      fatalError("❌ -> Failed to load \(parent.name).usdz from main bundle.")
    }
    
    let item = ARQuickLookPreviewItem(fileAt: fileURL)
    item.allowsContentScaling = parent.allowScaling
    return item
  }
}

struct ARQuickLookView_Previews: PreviewProvider {
  static var previews: some View {
    ARQuickLookView(name: "Teapot")
  }
}
