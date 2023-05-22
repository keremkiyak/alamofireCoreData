//
//  ViewController.swift
//  t-softProjectAlamofire
//
//
//

import UIKit
import Alamofire
import CoreData


class ViewController: UIViewController {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var idLabel1: UILabel!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var idLabel2: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    //belli aralıklarla tekrar için  kullandım.
    var timer: Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // random olarak url deki verileri  çekmek için random kullandım .
        fetchRandomData(for: 1, with: Int.random(in: 1...100))
        fetchRandomData(for: 2, with: Int.random(in: 1...100))
        
        // 5 saniyede bir kartları güncelliyorum.
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(randomTekrarla), userInfo: nil, repeats: true)
    }
    

    
    @objc func randomTekrarla() {
        fetchRandomData(for: 1, with: Int.random(in: 1...100))
        fetchRandomData(for: 2, with: Int.random(in: 1...100))
    }
    
    func fetchRandomData(for index: Int, with randomID: Int) {
        let url = "https://jsonplaceholder.typicode.com/photos/\(randomID)"
        //  alamofire ile istek atıyorum yukarıda tanımladığım url e
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let id = json["id"] as? Int,
                   let title = json["title"] as? String,
                   let imageURLString = json["url"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    
                    
                    //asenkron olarak bu işlerin de yapılmasını sağladım.
                    DispatchQueue.main.async {
                        if index == 1 {
                            self.idLabel1.text = "\(id)"
                            self.titleLabel1.text = title
                            self.loadImage(from: imageURL, into: self.imageView1)
                        } else if index == 2 {
                            self.idLabel2.text = "\(id)"
                            self.titleLabel2.text = title
                            self.loadImage(from: imageURL, into: self.imageView2)
                        }
                    }
                }
            case .failure(let error):
                print("İstek başarısız: \(error)")
            }
        }
    }
    
//    resimler için istek atma
    func loadImage(from url: URL, into imageView: UIImageView) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            case .failure(let error):
                print("Resim yükleme başarısız: \(error)")
            }
        }
    }
    
    @IBAction func likeButton1(_ sender: Any) {
        //  kalp butonuna tıklanınca kırmızı kalp oluşmasını sağladım.
        var button = sender as? UIButton
        button?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button?.tintColor = .red
        //    kullanıcı kalp butonuna tıklarsa id ve title verilerini aldım.
        guard let id = idLabel1.text, let title = titleLabel1.text else {
            return
        }
        
        
        saveItem(id: id, title: title)
    }
    
    @IBAction func likeButton2(_ sender: Any) {
        let button = sender as? UIButton
        button?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button?.tintColor = .red
        guard let id = idLabel2.text, let title = titleLabel2.text else {
            return
        }
        
        // Core Data kayıt
        saveItem(id: id, title: title)
    }
    
    func saveItem(id: String, title: String) {
        
        
        
       // uygulamanın  bir nesnesini oluşturdum.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //entity adım Entity
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newItem = NSManagedObject(entity: entity!, insertInto: context)
        
        if let idNumber = Int(id) {
            //id atribute una idNumber ı atıyorum.
            newItem.setValue(idNumber, forKey: "id")
        }
        newItem.setValue(title, forKey: "title")
        
        do {
            //kayıt burda yapıldı
            try context.save()
            print("Veri kaydedildi.")
        } catch {
            print("Veri kaydedilirken hata oluştu: \(error)")
        }
    }
    
    
    
}
