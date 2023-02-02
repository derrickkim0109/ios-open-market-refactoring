# iOS-OpenMarket-Refactoring
> 프로젝트 기간 2023.01.09 ~ 2023.02.02    
개발자 : [derrick](https://github.com/derrickkim0109) 

# 📋 목차
- [🔎 프로젝트 소개](#-프로젝트-소개)
- [📺 프로젝트 실행화면](#-프로젝트-실행화면)
- [🗂 App 구조](#-app-구조)
- [📝 기능설명](#-기능설명)
- [🚀 트러블슈팅](#-트러블슈팅)
- [📚 참고문서](#-참고문서)

## 🔎 프로젝트 소개
> 해당 프로젝트는 야곰 아카데미 iOS 커리어 스타터 캠프 활동 기간동안 진행한 프로젝트를 리팩토링 한 것입니다. [기존 프로젝트 - OpenMarket](https://github.com/Jeon-Minsu/ios-open-market/tree/step04-leftover-derrick)

---

## 📺 프로젝트 실행화면

|GridView|Pagenation|DetailViewView|
|--|--|--|
|<img src="https://i.imgur.com/HXz7RaU.gif" width="250">|<img src="https://i.imgur.com/85oyqT7.gif" width="250">|<img src="https://user-images.githubusercontent.com/59466342/214778241-65207dd9-725f-4605-b262-5fe4c326a62c.gif" width="250">|

---

## 🗂 App 구조

<img src="https://i.imgur.com/dHG5nNH.gif" width="800">


### Layers

- **Domain Layer** = Entities + Use Cases + Repositories Interfaces
- **Data Repositories Layer** = Repositories Implementations + API (Network)
- **Presentation Layer (MVVM)** = ViewModels + Views

### Dependency Direction

<img src="https://i.imgur.com/O7ISX8z.png" width="600">

- Domain Layer에 다른 레이어(예: Presentation — UIKit, Data Layer — Mapping Codable)가 포함되지 않도록 처리하였습니다. 

### MVVM, CleanArchitecture

- Clean Architecture를 MVVM에서 사용할 경우, 역할을 명확히 나눌 수 있는 장점이 있습니다. 또한, 기능 추가 및 수정이 필요할 때 특정 레이어에만 접근하기 때문에 확장성과 유지보수에 용이하다고 생각합니다. 역할 분리가 명확하기에 테스트와 코드를 파악하는데 이점이 있다고 생각하였고, 레이어의 요소를 추상화하여(ViewModelUseCase, Repository, Service)테스트를 진행하였습니다.

- MVVM을 사용한 이유는 ViewController에서 작성해야할 비지니스 로직이 많을 것으로 예상되어 객체를 조금 더 세세하게 분리하고자 사용하게 되었습니다.
- MVVM에서 일반적으로 @escaping Closure를 사용하여 데이터가 바인딩 되는 방식과는 달리 async/await을 활용하여 메서드가 호출되는 방식으로 구성되어 있습니다. 

---

## 📝 기능설명
    
**1. 서버 통신 기능 구현**

- `CompletionHanlder`로 Request Data를 처리하였으나 async/await으로 리팩토링 하였습니다.

**`async/await `를 사용하게 된 이유**
- 백그라운드 상에서 데이터를 요청하여 `CompletionHandler`로 처리하게 되면 콜백 지옥을 격게 됩니다.

- CompletionHandler

```swift

    func requestData(with urlRequest: URLRequest,
                     completion: @escaping (Result<Data, APIError>) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownErrorOccured))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.invalidURL))
                
                return
            }
            
            guard let verifiedData = data else {
                completion(.failure(.emptyData))
                
                return
            }
            
            completion(.success(verifiedData))
        }.resume()
    }
    
    func requestAndDecodeProduct<T: Decodable>(using client: APIClient = APIClient.shared,
                                    completion: @escaping (Result<T,APIError>) -> Void) {
        var request = URLRequest(url: configuration.url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let decodedData = try decoder.decode(T.self,
                                                         from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToDecode))
                }
            case .failure(_):
                completion(.failure(.emptyData))
            }
        }
    }
```

- Async/Await

**NetworkSessionManager**
```swift
protocol NetworkSessionManager {
    func request(
        _ request: URLRequest) async throws -> Data?
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    private let session = URLSession.shared
    static let shared = DefaultNetworkSessionManager()

    private init() {}
    
    func request(
        _ request: URLRequest) async throws -> Data? {
        do {
            let (data, response) = try await session.data(
                for: request)

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                guard httpResponse.statusCode != 202 else {
                    return data
                }

                throw NetworkError.error(
                    statusCode: httpResponse.statusCode,
                    data: data)
            }

            return data
        } catch (let error) {
            throw resolve(
                error: error)
        }
    }

    private func resolve(
        error: Error) -> NetworkError {
        let code = URLError.Code(
            rawValue: (error as NSError).code)
            
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}

 ```
 
 **DataTransferService**
 
```swift
    
protocol DataTransferService {
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
                    with endpoint: E) async throws -> T  where E.Response == T   
}

final class DefaultDataTransferService {
    private let networkService: NetworkService

    init(
        with networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultDataTransferService: DataTransferService {
    @MainActor
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E) async throws -> T {
        do {
            let data = try await networkService.request(
                endpoint: endpoint)

            let result: T = try await decode(
                data: data,
                decoder: endpoint.responseDecoder)
            return result
        } catch (let error) {
            throw resolve(
                error: error)
        }
    }

    @MainActor
    func request<E>(
        with endpoint: E) async throws where E : ResponseRequestable, E.Response == () {
        do {
            try await networkService.request(
                endpoint: endpoint)
        } catch (let error) {
            throw resolve(error: error)
        }
    }

    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder) async throws -> T {
        do {
            guard let data = data else {
                throw DataTransferError.noResponse
            }

            return try await decoder.decode(
                from: data)
        } catch (let error) {
            throw DataTransferError.parsing(error)
        }
    }

    private func resolve(
        error: Error) -> DataTransferError {
        return error is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(error)
    }
}

protocol DataTransferErrorResolver {
    func resolve(
        error: NetworkError) -> Error
}

```

 
**2. View 분리 작업**

- ProductListViewController에서 View를 분리하였습니다.
- Underline SegmentedControl으로 Custom 하였습니다.

--- 

## 🚀 트러블슈팅

### T1. AlertController present할 때 topViewController 찾는 문제

**[상황]**
- API 호출시 Error Case를 처리하기 위해 Alert를 사용하였습니다. 화면 전환을 하는 방식을 `pushController`, `present` 두 가지 방식으로 처리한 상황입니다. 

**[문제점]**
- present로 띄워진 Scene에서 AlertBuilderController(Custom Object)로 Alert를 present시 topController를 찾지 못하는 문제가 있었습니다.

<img src="https://i.imgur.com/upzWBsX.gif" width="1000" height="70">


**[해결방안]**

- 해결 방법은 구글링을 통해 `stackoverflow`에서 찾은 방법입니다. 
```swift
     var topController =
            firstScene?.windows.filter{ $0.isKeyWindow }.first?.rootViewController

            while let presentedViewController = topController?.presentedViewController {
                topController = presentedViewController
            }
```
- 기존에 `pushController`를 통해 화면 전환시 `rootViewController`를 찾으면 해결되었으나 `present`를 통한 화면 전환에서는 `rootViewController`를 찾지 못하였던 부분을 위의 while문을 통해 찾을 수 있도록 해결하였습니다.

## 📚 참고문서
- [Concurrency - Explore structured concurrency in Swift WWDC21](https://developer.apple.com/videos/play/wwdc2021/10134/)
	- [정리한 글](https://hackmd.io/Lj__DHc_RlSu76KlqOr68g)

- [malloc: nano zone abandoned due to inability to preallocate reserved vm space](https://www.youtube.com/watch?v=V0GeOd72xqQ)

- [AlertController - present Error](https://stackoverflow.com/questions/61402211/warning-attempt-to-present-uialertcontroller-whose-view-is-not-in-the-win)

