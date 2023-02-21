//
//  CommunityDetailView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/15.
//

import UIKit
import SnapKit
import Then

final class CommunityDetailView: BaseViewController {
    private let stackView = UIStackView().then {
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // MARK: - 프로필
    private let profileView = UIView()
    
    // 만족도 이미지
    private let satisfactionImgView = UIImageView().then {
        $0.image = UIImage(named: "winked_face_colored")
        $0.tintColor = .systemPink
    }
    
    // 닉네임
    private let nicknameLabel = UILabel().then {
        $0.text = "회원"
        $0.font = .systemFont(ofSize: 16)
    }
    
    // 만족도
    private let satisfactionLabel = UILabel().then {
        $0.text = "오늘 운동의 만족도는 최고였어요!"
        $0.font = .systemFont(ofSize: 10)
    }
    
    // n시간 전
    private let agoLabel = UILabel().then {
        $0.text = "2시간 전"
        $0.font = .systemFont(ofSize: 10)
    }
    
    // MARK: - 이미지 배너
    private let bannerView = UIView()
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false

        $0.isPagingEnabled = true
        
        $0.delegate = self
        $0.dataSource = self
        
        $0.register(CommunityDetailBannerCell.self, forCellWithReuseIdentifier: CommunityDetailBannerCell.identifier)
    }
    
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .init(named: "mainColor")
        $0.pageIndicatorTintColor = .gray
        
        $0.isUserInteractionEnabled = false
        
        $0.currentPage = 0
        $0.numberOfPages = 3
    }
    
    // MARK: - 내용
    private let contentLabel = UILabel().then {
        $0.text = """
            2022.09.03 오운완 인증글 ㅎㅎ
            오늘 PT 처음 받았는데, 정말 재밌었어요!
            내일도 열운 하겠습니다. . .
            오늘 하루도 화이팅 하세요!
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
            스크롤 테스트
        """
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
}

extension CommunityDetailView {
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = "#오운완"
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.edges.equalToSuperview()
        }
        
        [profileView, bannerView, contentLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        // 프로필
        [satisfactionImgView, nicknameLabel, satisfactionLabel, agoLabel].forEach {
            profileView.addSubview($0)
        }
        
        satisfactionImgView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(41)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(satisfactionImgView.snp.top).offset(3)
            $0.leading.equalTo(satisfactionImgView.snp.trailing).offset(13)
            $0.bottom.greaterThanOrEqualTo(satisfactionLabel.snp.top).offset(-3)
        }
        
        satisfactionLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.bottom.equalTo(satisfactionImgView.snp.bottom).offset(-3)
        }
        
        agoLabel.snp.makeConstraints {
            $0.centerY.equalTo(satisfactionLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
            
        // 이미지 배너
        [collectionView, pageControl].forEach {
            bannerView.addSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(collectionView.snp.width)
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(pageControl.snp.top).offset(-5)
        }
        
        pageControl.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
        
        // 내용
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(bannerView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityDetailBannerCell.identifier, for: indexPath) as! CommunityDetailBannerCell
        
        cell.updateUI()
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / view.frame.width)
        
        self.pageControl.currentPage = page
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommunityDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

