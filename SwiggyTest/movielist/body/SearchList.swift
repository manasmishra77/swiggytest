//
//  SearchList.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import UIKit

protocol SearchListDelegate: AnyObject {
    func itemSelected(id: String)
    var getSearchList: [MovieSearch] {get}
    func callForNextPageData()
}

class SearchList: UIView {
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    let cellIdentifier = "SearchCollectionViewCell"
    
    
    class func instanceFromNib() -> SearchList {
        return UINib(nibName: "SearchList", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SearchList
    }
    
    private var itemSize: CGSize = CGSize.zero
    private var linespacing: CGFloat = 0
    private var interitemspacing: CGFloat = 0
    
    weak var delegate: SearchListDelegate!
    
    
    func configureView(delegate: SearchListDelegate, itemSize: CGSize, linespacing: CGFloat = 20, itemspacing: CGFloat = 20) {
        
        self.delegate = delegate
        self.itemSize = itemSize
        self.linespacing = linespacing
        self.interitemspacing = itemspacing
        
        
        let proposalcellNib = UINib(nibName: cellIdentifier, bundle: nil)
        searchCollectionView.register(proposalcellNib, forCellWithReuseIdentifier: cellIdentifier)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.reloadData()
    }
    
    func reloadCollectionView() {
        self.searchCollectionView.reloadData()
    }
    
}

extension SearchList: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return linespacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemspacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.getSearchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SearchCollectionViewCell
        
        let model = self.delegate.getSearchList[indexPath.row]
        cell.configureCell(name: model.title ?? "", id: model.imdbID ?? "")
        
        if indexPath.row == delegate.getSearchList.count - 1 {
            delegate.callForNextPageData()
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell {
            delegate.itemSelected(id: cell.idLabel.text ?? "")
        }
    }

}
    

