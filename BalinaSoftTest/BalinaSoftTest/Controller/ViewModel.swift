import Foundation

final class ViewModel {
    
    //MARK: - var/let
    var fetchedData: GetModel?
    var tappedCellId: Int?
    
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
        APIManager.shared.fetchData { data in
            self.fetchedData = data
            completion()
        }
    }
    
    //MARK: - Flow functions
    func sendID(_ indexPath: IndexPath) {
        tappedCellId = fetchedData?.content[indexPath.row].id
    }
}
