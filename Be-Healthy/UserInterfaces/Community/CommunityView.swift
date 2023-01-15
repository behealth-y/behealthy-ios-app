//
//  CommunityView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/03.
//

import UIKit

class CommunityView: BaseViewController {
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout).then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
}

// MARK: - Extensions
extension CommunityView {
    // MARK: View
    /// 네비게이션 바 설정
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = "#오운완"
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_content"), style: .plain, target: self, action: #selector(openForm))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /// 뷰 설정
    private func setupViews() {
        view.backgroundColor = .white
    }
    
    // MARK: Actions
    @objc private func openForm() {
        print(#function)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
