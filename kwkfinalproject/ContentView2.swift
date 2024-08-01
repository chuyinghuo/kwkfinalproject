import SwiftUI
// Define a model to represent each to-do item
struct TodoItem: Identifiable {
  let id = UUID()
  let task: String
  var isCompleted: Bool
}
struct CheckToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      Label {
        configuration.label
      } icon: {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
          .foregroundStyle(configuration.isOn ? Color(red: 0.729, green: 0.959, blue: 0.782) :Color(red: 0.729, green: 0.959, blue: 0.782))
          .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
          .imageScale(.large)
      }
    }
    .buttonStyle(.plain)
  }
}
// Define an observable object to manage the list of todo items
class TodoListViewModel: ObservableObject {
  @Published var items: [TodoItem] = []
}
struct ContentView2: View {
  @StateObject private var viewModel = TodoListViewModel()
  @State private var newItem = ""
  var body: some View {
    ZStack {
      // Pink background covering the entire view
      Color(red: 0.949, green: 0.514, blue: 0.714)
        .ignoresSafeArea()
      VStack {
        List {
          ForEach(viewModel.items) { item in
            ZStack {
              VStack {
                HStack {
                  Toggle(isOn: Binding(
                    get: { item.isCompleted },
                    set: { newValue in
                      if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                        viewModel.items[index].isCompleted = newValue
                      }
                    }
                  )) {
                    Text(item.task)
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .toggleStyle(CheckToggleStyle())
                  Button("x") {
                    if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                      viewModel.items.remove(at: index)
                    }
                  }
                  .font(.footnote)
                  .foregroundStyle(Color.white)
                  .frame(width: 20.0, height: 20)
                  .background(Color(red: 1.0, green: 0.388, blue: 0.616))
                  .cornerRadius(100)
                }
              }
            }
          }
        }
        .navigationTitle("To-Do List")
        TextField(" ", text: $newItem)
          .multilineTextAlignment(.center)
          .font(.title)
          .border(Color(red: 0.729, green: 0.959, blue: 0.782), width: 4)
          .padding([.top, .leading, .trailing])
          .foregroundStyle(Color(red: 0.729, green: 0.959, blue: 0.782))
        Button("Add Item") {
          viewModel.items.append(TodoItem(task: newItem, isCompleted: false))
          newItem = "" // Clear the text field after adding the item
        }
        .foregroundStyle(Color(red: 0.949, green: 0.514, blue: 0.714))
        .frame(width: 100.0, height: 30)
        .border(Color(red: 0.729, green: 0.959, blue: 0.782), width: 4)
        .background(Color(hue: 0.372, saturation: 0.104, brightness: 0.988))
        Text("To-Do List")
        .foregroundStyle(Color(red: 0.949, green: 0.514, blue: 0.714))
        .frame(width: 150.0, height: 40)
        .background(Color(red: 0.729, green: 0.959, blue: 0.782))
        .cornerRadius(100)
        .font(.title)
        .padding()
      }
      .padding()
    }
  }
}
#Preview {
  ContentView2()
}
