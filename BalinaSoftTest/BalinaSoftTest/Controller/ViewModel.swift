import Foundation

final class ViewModel {
    
    //MARK: - var/let
    var fetchedData: [Content] = []
    var tappedCellId: Int?
    var page = 0
    var isPagination: Bool = false
    
    var namePhoto: String? {
        didSet {
            if let namePhoto = namePhoto,
               let id = tappedCellId,
                let image = ImageManager.shared.loadImage(fileName: namePhoto) {
                APIManager.shared.sendData(data: PostModel(name: Resources.developer,
                                                          photo: image,
                                                          typeId: id))
            }
        }
    }
    
    //MARK: - GetRequest
    func getData(completion: @escaping () -> ()) {
        isPagination = true
        APIManager.shared.fetchData(parameters: [Resources.page: String(page)]) { data in
            guard let data = data else { return }
            self.fetchedData.append(contentsOf: data.content)
            completion()
            if self.page < data.totalPages {
                self.page += 1
                self.isPagination = false
            }
        }
    }
    
    //MARK: - Flow functions
    func sendID(_ indexPath: IndexPath) {
        tappedCellId = fetchedData[indexPath.row].id
    }
}
