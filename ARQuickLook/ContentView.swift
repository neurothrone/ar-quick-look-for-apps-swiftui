//
//  ContentView.swift
//  ARQuickLook
//
//  Created by Zaid Neurothrone on 2022-12-23.
//

import SwiftUI

struct Model: Identifiable {
  let id = UUID()
  
  let name: String
  let image: UIImage
}

struct ContentView: View {
  @State private var selectedModel: Model?
  @State private var allowScaling: Bool = true
  
  private let modelNames = ["Teapot", "Gramophone", "Pig"]
  private var models: [Model] = []
  
  init() {
    for modelName in modelNames {
      if let modelImage = UIImage(named: "\(modelName).jpg") {
        let model = Model(
          name: modelName,
          image: modelImage
        )
        
        models.append(model)
      }
    }
  }
  
  var body: some View {
    NavigationStack {
      Toggle("Allow scaling", isOn: $allowScaling)
        .padding(.horizontal, 25)
      
      List {
        ForEach(models) { model in
          Button {
            selectedModel = model
          } label: {
            HStack {
              Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
              
              Text(model.name)
                .font(.largeTitle)
                .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
          .buttonStyle(.borderedProminent)
          .listRowSeparator(.hidden)
        }
      }
      .listStyle(.plain)
      .scrollDisabled(true)
      .scrollContentBackground(.hidden)
      .navigationTitle("Models")
      .sheet(item: $selectedModel) { selectedModel in
        NavigationStack {
          ARQuickLookView(
            name: selectedModel.name,
            allowScaling: allowScaling
          )
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              Button(action: { self.selectedModel = nil }) {
                Image(systemName: "xmark")
                  .imageScale(.large)
                  .foregroundColor(.secondary)
              }
            }
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
