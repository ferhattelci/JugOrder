import UIKit

class LoadViewController: UIViewController{
    
    @IBOutlet weak var progress: UIProgressView!

    fileprivate var downloadTask1:  DownloadTask?
    fileprivate var downloadTask2:  DownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0.0

        if Products.count < 1 {
            downloadProducts()
        } else {
            progress.progress = 100.0
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationNavigationController = storyboard.instantiateViewController(withIdentifier: "TableNavigationController") as! UINavigationController
            DispatchQueue.main.async {
                self.present(destinationNavigationController, animated: true, completion: nil)
            }
        }
        
    }
    
    func downloadProducts(){
        let url = URL(string: "http://192.168.23.178/api/products/read.php")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        downloadTask1 = DownloadService.shared.download(request: request)
        downloadTask1?.completionHandler = { [weak self] in
            switch $0 {
            case .failure(let error):
                print(error)
            case .success(let data):
                print("Number of bytes: \(data.count)")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    ProductModel.downloadProducts(json: json)
             
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destinationNavigationController = storyboard.instantiateViewController(withIdentifier: "TableNavigationController") as! UINavigationController

                    DispatchQueue.main.async {
                        self?.present(destinationNavigationController, animated: true, completion: nil)

                    }
                } catch let error  {
                    print(error.localizedDescription)
                }
                
                
            }
            self?.downloadTask1 = nil
        }
        downloadTask1?.progressHandler = { [weak self] in
            print("Task1: \($0 * -1)")
            self?.progress.progress = Float($0 * (-1))
        }
        
        downloadTask1?.resume()
    }
    
    func downloadTables(){
        let url = URL(string: "http://localhost:8002/?imageID=02&tilestamp=\(Date.timeIntervalSinceReferenceDate)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        downloadTask2 = DownloadService.shared.download(request: request)
        downloadTask2?.completionHandler = { [weak self] in
            switch $0 {
            case .failure(let error):
                print(error)
            case .success(let data):
                print("Number of bytes: \(data.count)")
            }
            self?.downloadTask2 = nil
        }
        downloadTask2?.progressHandler = { [weak self] in
            print("Task2: \($0)")
            self?.progress.progress = Float($0 * -1)
        }
       
        downloadTask2?.resume()
    }


}
