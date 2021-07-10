# 📢📢📢 Flutter Best Architecture Challenge 📢📢📢

**「此為參加 Flutter Best Architecture Challenge 活動的專案」**
**聯絡方式：clementlin321@gmail.com**

Hi, This is Clement
感謝Flutter Taipei舉辦這個活動解救WFH到快悶死的我XD

本次我採用的是經典Clean Architecture架構，雖然對這項目來說跟用光劍殺螞蟻沒兩樣，
但是專案規模越大，你越能感受Clean Architecture的優勢，畫面、業務邏輯、資料…職責明確的分層，
高複用性、以及高測試性，會節省你許多維護時間。

<div align="center">
<img src="/doc_img/clean_circle.png"/>
</div>

上圖是`Clean Architecture`的概念圖，架構中有四個角色，以及一條`Dependecy Rule`，線的方向代表依賴關係，外層依賴內層，每一層除了內層成員外，不知道外層發生的任何事，例如：`UseCases`能使用`Entities`提供的對外接口，本身也提供對外接口。

四個角色分別是：

* **Entities**：也能理解為Model。

* **UseCases**：usecase持有Entities，負責操作Entities資料存取以及管理商業邏輯，本身提供Presenter層使用。

* **Presenters**：提供接口給UI呼叫，使用UseCase操作商業邏輯。

* **UI**：UI、tools、framework都是屬於這塊。

## Clean Architecture in Flutter
Clean Architecture在Flutter實作上可以理解成MVVM + Repository pattern的組合

假設我們從上帝視角來看一個專案可以分成三個部份：

<div align="center">
<img src="/doc_img/clean_architecture_all.png"/>
</div>

### Data Layer

<div align="center">
<img src="/doc_img/data_layer.png"/>
</div>

Model層實作Repository Pattern只專注於資料存取，Repository是倉庫的意思，它掌管所有資料的入口，UseCase一律透過Repository來存取資料。Call Api和存取本地儲存(資料庫/Shared Preferences)都在Repository內執行。

### Domain Layer

<div align="center">
<img src="/doc_img/domain_layer.png"/>
</div>

`UseCase` 封裝商業邏輯，目的是提高其複用性。

UseCase跟其它class命名不同，因為`UseCase`使用上跟function相同，所以要用`動詞+名詞`組成如`GetUserInfoUseCase`。

### Presentation Layer


話不多說！趕快 Fork 專案！Let's get started !  
專案傳送門： https://github.com/flutterTaipei/BestArchitectureChallenge

**如果對活動有任何建議或想法的，也歡迎來信通知我們唷🥳**  
**聯絡方式：flutter.taipei@gmail.com**

## 活動時間
即日起至 2021 年 8 月 31 日晚上 00:00 分截止

## 評選方式
以 Github 專案獲得的星星數，由多到少排序，取前 3 名為優勝者

## 獲勝獎品
Google 贊助的 Flutter 馬克杯乙份 🎁

## 參賽方式

1. Fork Flutter Taipei 的 專案到你自己的 Github 上
2. 在專案 README 找地方註明「此為參加 Flutter Best Architecture Challenge 活動的專案」，並留下可以讓我們聯絡到你聯絡方式
3. 改寫架構後並提交，就這麼簡單！

## 增加星星小秘訣⭐️⭐️⭐️

1. 在 README 介紹你的架構、介紹你使用的第三方套件以及為什麼會去使用它，  
   甚至去分析你的架構優缺點在哪裡（小編看到詳細的README絕對第一個去Star 🙋‍♂️
2. 在 Flutter Taipei Facebook 社團 或 Discord 分享你的專案或提問，和大家一起討論，增加曝光度

___


## 開發環境

```
Flutter 2.2.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision d79295af24 (3 weeks ago) • 2021-06-11 08:56:01 -0700
Engine • revision 91c9fc8fe0
Tools • Dart 2.13.3
```
## 目標

- 將貼文API的內容呈現在畫面上，這裡使用 https://jsonplaceholder.typicode.com/posts
- 可以根據選擇的內容來排序（範例是用id/title來排序）
- 改造成你自己的 Best Architecture 🎉🎉🎉






