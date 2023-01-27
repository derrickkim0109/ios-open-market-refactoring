# iOS-OpenMarket-Refactoring
> 프로젝트 기간 2023.01.09 ~ 2023.01.15    
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

### Layers

- **Domain Layer** = Entities + Use Cases + Repositories Interfaces
- **Data Repositories Layer** = Repositories Implementations + API (Network)
- **Presentation Layer (MVVM)** = ViewModels + Views

### Dependency Direction

<img src="https://i.imgur.com/O7ISX8z.png" width="600">

- 

### MVVM, CleanArchitecture

---


## 📝 기능설명
    
**서버 통신 기능 구현**

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
```swift
    func getItems<T: Decodable>(dataType: T.Type,
                                using client: APIClient = APIClient.shared) async throws -> T {
        var urlRequest = URLRequest(url: configuration.url)
        urlRequest.httpMethod = HTTPMethod.get
        
        do {
            let data = try await client.requestData(with: urlRequest)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.self,
                                                 from: data)
            return decodedData
        } catch {
            throw APIError.emptyData
        }
    }
 ```
 
**View 분리 작업**

- ProductListViewController에서 View를 분리하였습니다.
- Underline SegmentedControl으로 Custom 하였습니다.

--- 

## 🚀 트러블슈팅
    
### T1. DataSource & Snapshot 문제


### T2. 테스트 코드 


## 📚 참고문서
- [Concurrency - Explore structured concurrency in Swift WWDC21](https://developer.apple.com/videos/play/wwdc2021/10134/)
	- [정리한 글](https://hackmd.io/c44EHt6cR9iIxjog1ei5pQ)

-[malloc: nano zone abandoned due to inability to preallocate reserved vm space](https://www.youtube.com/watch?v=V0GeOd72xqQ)
