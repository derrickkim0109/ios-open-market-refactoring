# iOS-OpenMarket-Refactoring
> 프로젝트 기간 2023.01.09 ~ 2023.01.15    
개발자 : [derrick](https://github.com/derrickkim0109) 

# 📋 목차
- [프로젝트 소개](#-프로젝트-소개)
- [프로젝트 실행화면](#-프로젝트-실행화면)
- [App 구조](#-app-구조)
- [폴더구조](#-폴더구조)

---
## 🔎 프로젝트 소개
> 해당 프로젝트는 야곰 아카데미 iOS 커리어 스타터 캠프 활동 기간동안 진행한 프로젝트를 리팩토링 한 것입니다. [기존 프로젝트 - OpenMarket](https://github.com/Jeon-Minsu/ios-open-market/tree/step04-leftover-derrick)

---

## 📺 프로젝트 실행화면
|GridView|Pagenation|DetailViewView|
|--|--|--|
|<img src="https://i.imgur.com/HXz7RaU.gif" width="250">|<img src="https://i.imgur.com/85oyqT7.gif" width="250">|<img src="https://i.imgur.com/k7EuAxK.gif" width="250">|

---

## 🗂 App 구조

### Layers

- **Domain Layer** = Entities + Use Cases + Repositories Interfaces
- **Data Repositories Layer** = Repositories Implementations + API (Network)
- **Presentation Layer (MVVM)** = ViewModels + Views

### Dependency Direction

<img src="https://i.imgur.com/O7ISX8z.png" width="600">

### Coordinator

- 이전 프로젝트 에서 각각 다른 View 에서 동일한 View로 화면전환시 중복코드가 생겨나고, 각 다른 View에서 동일한 Class 인스턴스 를 주입받아야 하는 상황이 발생해 이를 해결하고자 Coordinator 패턴에 대해 공부하고 적용했습니다.
- Coordinator 패턴을 적용해 화면 전환 로직을 ViewController 에서 분리 하였고, ViewController 간의 의존성을 제거 하였습니다.

### MVVM, CleanArchitecture
<img src="https://i.imgur.com/nB50IBY.png" width="800">

- 기존 MVVM의 경우 MVC보다는 계층이 분리되고, 객체들의 관심사가 분리되지만 그럼에도 ViewModel의 역할이 커지는 문제가 발생했습니다.
- CleanArchitecture를 통해 Layer를 한층 더 나누어 주면서 계층별로 관심사가 나누어지게 되고, 자연스럽게 각각의 객체들의 역할이 나누어 지도록 하였습니다.
- 이로 인해 객체들의 결합도가 낮아지고, 응집도는 높아지면서 문제가 발생했을 때 쉽게 찾을 수 있고 해당 부분만 수정이 가능해지면서 유지보수적인 측면에서 상당한 이점을 갖을 수 있게 되었습니다.

---
--- 
## 🗂 폴더구조
```
├── OpenMarket
│   ├── OpenMarket
│   │   ├── Application
│   │   │   ├── AppConfiguration.swift
│   │   │   ├── AppDelegate.swift
│   │   │   ├── AppFlowCoordinator.swift
│   │   │   ├── DIContainer
│   │   │   │   ├── AppDIContainer.swift
│   │   │   │   └── ProductsSceneDIContainer.swift
│   │   │   ├── Data
│   │   │   │   ├── ImageCacheManager.swift
│   │   │   │   ├── JSONResponseDecoder.swift
│   │   │   │   ├── Network
│   │   │   │   │   ├── API
│   │   │   │   │   │   ├── DataTransferService.swift
│   │   │   │   │   │   ├── NetworkService.swift
│   │   │   │   │   │   └── NetworkSessionManager.swift
│   │   │   │   │   ├── APIEndpoints.swift
│   │   │   │   │   ├── DataMapping
│   │   │   │   │   │   ├── ProductDetailsRequestDTO+Mapping.swift
│   │   │   │   │   │   ├── ProductImageDTO.swift
│   │   │   │   │   │   ├── ProductsRequestDTO+Mapping.swift
│   │   │   │   │   │   └── TypedProductDetailsRequestDTO.swift
│   │   │   │   │   ├── DataTransferError.swift
│   │   │   │   │   ├── NetworkError.swift
│   │   │   │   │   └── Utils
│   │   │   │   │       ├── Endpoint
│   │   │   │   │       │   ├── ApiDataNetworkConfig.swift
│   │   │   │   │       │   ├── Endpoint.swift
│   │   │   │   │       │   ├── MultiPartForm.swift
│   │   │   │   │       │   └── Requestable.swift
│   │   │   │   │       └── HTTP
│   │   │   │   │           ├── HTTPMethod.swift
│   │   │   │   │           └── User.swift
│   │   │   │   └── Repositories
│   │   │   │       ├── ProductDetails
│   │   │   │       │   ├── DefaultDeleteProductRepository.swift
│   │   │   │       │   ├── DefaultProductDetailsRepository.swift
│   │   │   │       │   ├── DefaultProductSecretRepository.swift
│   │   │   │       │   └── Protocols
│   │   │   │       │       ├── DeleteProductRepository.swift
│   │   │   │       │       ├── ProductDetailsRepository.swift
│   │   │   │       │       └── ProductSecretRepository.swift
│   │   │   │       ├── ProductEnrollment
│   │   │   │       │   ├── DefaultEnrollProductRepository.swift
│   │   │   │       │   └── Protocol
│   │   │   │       │       └── EnrollmentProductRepository.swift
│   │   │   │       ├── ProductList
│   │   │   │       │   ├── DefaultProductsRepository.swift
│   │   │   │       │   └── Protocol
│   │   │   │       │       └── ProductsRepository.swift
│   │   │   │       └── ProductModify
│   │   │   │           ├── DefaultModifyProductRepository.swift
│   │   │   │           └── Protocol
│   │   │   │               └── ModifyProductRepository.swift
│   │   │   ├── Domain
│   │   │   │   ├── Entities
│   │   │   │   │   ├── ProductDetails
│   │   │   │   │   │   └── ProductDetailsEntity.swift
│   │   │   │   │   └── ProductList
│   │   │   │   │       └── ProductEntity.swift
│   │   │   │   └── UseCase
│   │   │   │       ├── ProductDetails
│   │   │   │       │   ├── DeleteProductUseCase.swift
│   │   │   │       │   ├── FetchProductDetailsUseCase.swift
│   │   │   │       │   └── FetchProductSecretUseCase.swift
│   │   │   │       ├── ProductEnrollment
│   │   │   │       │   └── EnrollProductUseCase.swift
│   │   │   │       ├── ProductList
│   │   │   │       │   └── FetchProductsUseCase.swift
│   │   │   │       └── ProductModification
│   │   │   │           └── ModifyProductsUseCase.swift
│   │   │   ├── Presentation
│   │   │   │   └── ProductsScene
│   │   │   │       ├── CommonView
│   │   │   │       │   ├── ProductEnrollmentVIew.swift
│   │   │   │       │   └── ProductListView.swift
│   │   │   │       ├── Flow
│   │   │   │       │   └── ProductsMainFlowCoordinator.swift
│   │   │   │       ├── ProductDetail
│   │   │   │       │   ├── ProductDetailsViewController.swift
│   │   │   │       │   ├── View
│   │   │   │       │   │   ├── ProductDetailsCollectionViewCell.swift
│   │   │   │       │   │   └── ProductDetailsView.swift
│   │   │   │       │   └── ViewModel
│   │   │   │       │       ├── Actions
│   │   │   │       │       │   └── ProductDetailsViewModelActions.swift
│   │   │   │       │       ├── DefaultProductDetailsViewModel.swift
│   │   │   │       │       ├── ProductDetailsItemViewModel.swift
│   │   │   │       │       └── Protocols
│   │   │   │       │           └── ProductDetailsViewModel.swift
│   │   │   │       ├── ProductEnrollment
│   │   │   │       │   ├── ProductEnrollmentViewController.swift
│   │   │   │       │   └── ViewModel
│   │   │   │       │       ├── Actions
│   │   │   │       │       │   └── ProductEnrollmentViewModelActions.swift
│   │   │   │       │       ├── DefaultProductEnrollmentViewModel.swift
│   │   │   │       │       └── Protocol
│   │   │   │       │           └── ProductEnrollmentViewModel.swift
│   │   │   │       ├── ProductList
│   │   │   │       │   ├── ProductsListViewController.swift
│   │   │   │       │   ├── View
│   │   │   │       │   │   └── ProductListCollectionCell.swift
│   │   │   │       │   └── ViewModel
│   │   │   │       │       ├── Actions
│   │   │   │       │       │   └── ProductsListViewModelActions.swift
│   │   │   │       │       ├── DefaultProductsListViewModel.swift
│   │   │   │       │       ├── ProductsListItemViewModel.swift
│   │   │   │       │       └── Protocols
│   │   │   │       │           └── ProductsListViewModel.swift
│   │   │   │       └── ProductModification
│   │   │   │           ├── ProductModificationViewController.swift
│   │   │   │           └── ViewModel
│   │   │   │               ├── Actions
│   │   │   │               │   └── ProductModificationViewModelActions.swift
│   │   │   │               ├── DefaultProductModificationViewModel.swift
│   │   │   │               └── Protocol
│   │   │   │                   └── ProductModificationViewModel.swift
│   │   │   └── SceneDelegate.swift
│   │   ├── Extensions
│   │   │   ├── Double+Extensions.swift
│   │   │   ├── String+Extensions.swift
│   │   │   ├── UIImage+Extensions.swift
│   │   │   ├── UIImageView+Extensions.swift
│   │   │   ├── UIRefreshControl+Extensions.swift
│   │   │   └── UIViewController+Extensions.swift
│   │   ├── Resource
│   │   │   ├── Assets.xcassets
│   │   │   │   ├── AccentColor.colorset
│   │   │   │   │   └── Contents.json
│   │   │   │   ├── AppIcon.appiconset
│   │   │   │   │   └── Contents.json
│   │   │   │   ├── Contents.json
│   │   │   │   └── products.json
│   │   │   ├── Base.lproj
│   │   │   │   └── LaunchScreen.storyboard
│   │   │   └── Info.plist
│   │   └── Utils
│   │       ├── AlertSetting.swift
│   │       ├── AnyCancelTaskBag.swift
│   │       ├── AnyCancellableTask.swift
│   │       ├── Builder
│   │       │   └── AlertControllerBulider.swift
│   │       ├── Infrastructure
│   │       └── LoadingIndicator.swift
│   ├── OpenMarketTests
│   │   ├── Network
│   │   │   └── EndpointTests.swift
│   │   └── ProductListView
│   │       └── ProductListViewTest.swift
│   └── ProductDetailsView
└── README.md

```
