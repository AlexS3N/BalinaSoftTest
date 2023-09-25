
import Foundation
import UIKit

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    func fetchData(completion: @escaping (GetModel?) -> ()) {
        guard let url = URL(string: Resources.getURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil,
               let data = data {
                do {
                    let pictures = try JSONDecoder().decode(GetModel.self, from: data)
                    completion(pictures)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func sendData(data: PostModel) {
        guard let url = URL(string: Resources.postURL) else { return }
        let boundary = UUID().uuidString

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        let requestBody = multipartFormDataBody(boundary, data.name, data.photo, data.typeId)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request) { dataResponse, response, error in
            if let error = error {
                print(error)
                return
            }
            if let dataResponse = dataResponse {
                let answer = try? JSONSerialization.jsonObject(with: dataResponse)
                if let answer = answer as? [String: Any] {
                    print(answer)
                }
            }
        }
        task.resume()
    }
    
    private func multipartFormDataBody(_ boundary: String, _ fromName: String, _ image: UIImage, _ id: Int) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"name\"\(lineBreak + lineBreak)")
        body.append("\(fromName + lineBreak)")
        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(uuid).jpeg\"\(lineBreak)")
            body.append("Content-Type: image/jpg\(lineBreak + lineBreak)")
            if let image = image.jpegData(compressionQuality: 1.0) {
                body.append(image)
            }
            body.append(lineBreak)
        }
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"typeId\"\(lineBreak + lineBreak)")
        body.append("\(id)")
        body.append(lineBreak)
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
