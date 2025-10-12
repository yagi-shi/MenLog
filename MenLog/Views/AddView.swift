/*
 新規追加画面
 */

import SwiftUI
import SwiftData
import PhotosUI
import StoreKit

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var storeName = ""
    @State private var rating = 0
    @State private var memo = ""
    @State private var date = Date()
    @State private var imageData: Data?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("店名", text: $storeName)
                    DatePicker("日付", selection: $date, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "en_US"))
                    HStack {
                        Text("評価")
                        Spacer()
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(index <= rating ? .yellow : .gray)
                                .onTapGesture {
                                    rating = index
                                }
                                .padding(.horizontal, 2)
                        }
                    }
                }
                Section(header: Text("メモ")) {
                    TextEditor(text: $memo)
                        .frame(height: 100)
                }
                Section(header: Text("画像")) {
                    PhotosPicker("写真を選択", selection: $selectedItem, matching: .images)
                }

                if let data = imageData, let uiImage = UIImage(data: data) {
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newEntry = RamenEntry(
                            date: date,
                            storeName: storeName,
                            rating: rating,
                            memo: memo,
                            imageData: imageData
                        )
                        context.insert(newEntry)
                        do {
                            try context.save()
                            if let scene = UIApplication.shared.connectedScenes
                                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                            dismiss() // 保存成功なら閉じる
                        } catch {
                            print("保存失敗: \(error.localizedDescription)")
                        }
                    }
                    .disabled(storeName.isEmpty)
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }
        }
    }
}
