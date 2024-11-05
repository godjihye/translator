//
//  ViewController.swift
//  Translator
//
//  Created by jhshin on 11/4/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
	let APIKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as! String
	var translations: [Translations] = []
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	@IBAction func btn(_ sender: Any) {
		trans(textField.text)
	}
	func trans(_ text: String?) {
		guard let text else {return}
		let endPoint = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=en,ja,es,fr,zh,de,it,ru,pt,ar";
		let headers: HTTPHeaders = ["Ocp-Apim-Subscription-Key": APIKey, "Ocp-Apim-Subscription-Region":"eastus", "Content-Type":"Application/json"]
		let params: [[String: String]] = [["Text": text]]
		var request = try! URLRequest(url: endPoint, method: .post, headers: headers)
		request.httpBody = try? JSONSerialization.data(withJSONObject: params)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		AF.request(request).responseDecodable(of: [Root].self) { response in
			switch response.result {
			case .success(let data):
				for item in data {
					self.translations = item.translations
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		translations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "trans", for: indexPath)
		let trn = translations[indexPath.row]
		let lblTo = cell.viewWithTag(1) as? UILabel
		let lblText = cell.viewWithTag(2) as? UILabel
		lblTo?.text = trn.to.components(separatedBy: "-")[0]
		lblText?.text = trn.text
		return cell
	}
}
