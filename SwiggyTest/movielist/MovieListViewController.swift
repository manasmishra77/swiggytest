//
//  MovieListViewController.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var bodyContainer: UIView!
    weak var searchListView: SearchList?
    
    var searchListArr: [MovieSearch] = []
    
    var currentPageNo: Int = 1
    var prevSearchKey = "" {
        didSet {
            currentPageNo = 1
            self.searchListArr = []
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView() {
        searchTextField.delegate = self
        configureBody()
    }
    
    func configureBody() {
        let body = SearchList.instanceFromNib()
        body.addAsSubViewWithConstraints(self.bodyContainer)
        body.configureView(delegate: self, itemSize: CGSize(width: self.bodyContainer.frame.width - 20, height: 80))
        self.searchListView = body
    }


}

extension MovieListViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            guard let newTxt = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            AppManager.shared.networkManager.getMovieList(searchKey: newTxt, pageNo: currentPageNo) {[weak self] (code, models, err) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if let err = err as? NetworkManager.NetworkError {
                        let alert = UIAlertController(title: "failed", message: err.msg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                            action in
                                 // Called when user taps outside
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                       
                        if let models = models as? [MovieSearch] {
                            if text != self.prevSearchKey {
                                self.prevSearchKey = text
                            }
                            self.currentPageNo = self.currentPageNo + 1
                            self.searchListArr = self.searchListArr + models
                            self.searchListView?.reloadCollectionView()
                        } else {
                            let alert = UIAlertController(title: "No content", message: "try again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                                action in
                                     // Called when user taps outside
                                alert.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        

                    }
                }
            }
        }
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
}


extension MovieListViewController: SearchListDelegate {
    func itemSelected(id: String) {
        
        AppManager.shared.networkManager.getMovieDetail(id: id) { (code, model, error) in
            DispatchQueue.main.async {
                if let err = error as? NetworkManager.NetworkError {
                    let alert = UIAlertController(title: "failed", message: err.msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                        action in
                             // Called when user taps outside
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storyboard.instantiateInitialViewController() as? ViewController, let model = model as? Movie {
                        vc.movie = model
                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                }
            }
            
        }
    }
    
    var getSearchList: [MovieSearch] {
        return searchListArr
    }
    
    func callForNextPageData() {
        textFieldDidEndEditing(self.searchTextField)
    }
    
    
}


