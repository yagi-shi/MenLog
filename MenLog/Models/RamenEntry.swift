import Foundation
import SwiftData

@Model
class RamenEntry {
    var id: UUID
    var date: Date
    var storeName: String
    var rating: Int
    var memo: String
    var imageData: Data? // UIImageをDataで保存

    init(id: UUID = UUID(),
         date: Date = Date(),
         storeName: String,
         rating: Int = 0,
         memo: String = "",
         imageData: Data? = nil) {
        self.id = id
        self.date = date
        self.storeName = storeName
        self.rating = rating
        self.memo = memo
        self.imageData = imageData
    }
}
