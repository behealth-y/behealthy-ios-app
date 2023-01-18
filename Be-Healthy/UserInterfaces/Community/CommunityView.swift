//
//  CommunityView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/03.
//

import UIKit

class CommunityView: BaseViewController {
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout).then {
        
        $0.delegate = self
        $0.dataSource = self
        
        $0.register(CommunityCell.self, forCellWithReuseIdentifier: CommunityCell.identifier)
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
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Actions
    @objc private func openForm() {
        let vc = CommunityFormView()
        vc.sheetPresentationController?.prefersGrabberVisible = true
        self.present(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCell.identifier, for: indexPath) as! CommunityCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(CommunityDetailView(), animated: true)
    }
}
