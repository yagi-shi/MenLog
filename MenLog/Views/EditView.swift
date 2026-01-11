/*
 編集画面
 */

import SwiftUI
import SwiftData
import PhotosUI

struct EditView: View {
    @Bindable var entry: RamenEntry
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var tempStoreName: String = ""
    @State private var tempDate: Date = Date()
    @State private var tempRating: Int = 0
    @State private var tempMemo: String = ""
    @State private var tempImageData: Data?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        Form {
            TextField("店名", text: $tempStoreName)
            DatePicker("Date", selection: $tempDate, displayedComponents: .date)
                .environment(\.locale, Locale(identifier: "en_US"))
            HStack {
                Text("評価")
                Spacer()
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= tempRating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(index <= tempRating ? .yellow : .gray)
                        .onTapGesture {
                            tempRating = index
                        }
                        .padding(.horizontal, 2)
                }
            }
            Section(header: Text("メモ")) {
                TextEditor(text: $tempMemo)
                    .frame(height: 100)
            }
            Section(header: Text("画像")) {
                PhotosPicker("写真を変更", selection: $selectedItem, matching: .images)
            }
            if let data = tempImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
        }
        .navigationTitle("MenLog")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.gray.opacity(0.3), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    entry.storeName = tempStoreName
                    entry.date = tempDate
                    entry.rating = tempRating
                    entry.memo = tempMemo
                    entry.imageData = tempImageData
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        print("保存に失敗しました。アプリを再起動してください。")
                    }
                }
            }
        }
        .onAppear {
            tempStoreName = entry.storeName
            tempDate = entry.date
            tempRating = entry.rating
            tempMemo = entry.memo
            tempImageData = entry.imageData
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    tempImageData = data
                }
            }
        }
    }
}
