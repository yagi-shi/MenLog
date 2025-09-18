/*
 一覧表示画面
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \RamenEntry.date, order: .reverse) var entries: [RamenEntry]
    @Environment(\.modelContext) private var context
    @State private var showingAdd = false

    @State private var showDeleteAlert = false
    @State private var entryToDelete: RamenEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if entries.isEmpty {
                        Text("まだ記録がありません")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    LazyVStack(spacing: 16) {
                        ForEach(entries) { entry in
                            NavigationLink {
                                EditView(entry: entry)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                                        .shadow(radius: 1, y: 1)
                                    HStack(spacing: 16) {
                                        if let data = entry.imageData,
                                           let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 80, height: 80)
                                                .overlay(Text("No\nImage").font(.caption))
                                                .foregroundColor(Color.gray.opacity(0.3))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(entry.storeName)
                                                .font(.callout)
                                                .foregroundColor(.black)
                                            Text(entry.date, style: .date)
                                                .font(.callout)
                                                .foregroundColor(.secondary)
                                            HStack(spacing: 2) {
                                                ForEach(1...5, id: \.self) { starIndex in
                                                    Image(systemName: starIndex <= entry.rating ? "star.fill" : "star")
                                                        .foregroundColor(starIndex <= entry.rating ? .yellow : .gray)
                                                        .font(.callout)
                                                }
                                            }
                                        }
                                        Spacer()
                                        HStack {
                                            Button {
                                                entryToDelete = entry
                                                showDeleteAlert = true
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                            .alert("check-key", isPresented: $showDeleteAlert) {
                                                Button("ok-key", role: .destructive) {
                                                    if let entry = entryToDelete {
                                                        context.delete(entry)
                                                        try? context.save()
                                                    }
                                                    entryToDelete = nil
                                                }
                                                Button("no-key", role: .cancel) {
                                                    entryToDelete = nil
                                                }
                                            }
                                        }
                                        .padding(.trailing)
                                    }
                                    .padding()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .font(.system(size: 20, weight: .regular))
            .navigationTitle("MenLog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.gray.opacity(0.3), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)

            HStack {
                Spacer()
                Button {
                    showingAdd = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                        .shadow(radius: 1, y: 1)
                }
                .sheet(isPresented: $showingAdd) {
                    AddView()
                }
                .padding()
            }
        }
    }
}
