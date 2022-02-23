package com.glow.openbook.book.aladin;

/* Sample output:
{
  "version": "20131101",
  "logo": "http://image.aladin.co.kr/img/header/2011/aladin_logo_new.gif",
  "title": "알라딘 상품정보 - 위대한 이야기",
  "link": "https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=281256147&amp;partner=openAPI",
  "pubDate": "Sat, 27 Nov 2021 04:25:35 GMT",
  "totalResults": 1,
  "startIndex": 1,
  "itemsPerPage": 1,
  "query": "isbn13=9791191851069",
  "searchCategoryId": 0,
  "searchCategoryName": "",
  "item": [
    {
      "title": "위대한 이야기 - 아름다움, 선함, 진리에 대한 메타 내러티브",
      "link": "http://www.aladin.co.kr/shop/wproduct.aspx?ItemId=281256147&amp;partner=openAPI&amp;start=api",
      "author": "제임스 브라이언 스미스 (지은이), 이대근 (옮긴이)",
      "pubDate": "2021-10-11",
      "description": "“기독교의 이야기는 어떤 삶을 만들어 내는가?” 인생의 중요한 질문에 답할 수 있는 큰 이야기. 신학적 통찰력과 목회적 현실 감각을 살려 우리 인생의 중요한 질문에 답을 제공하고 우리 삶을 빚어 갈 메타 내러티브를 소개한 책이다.",
      "isbn": "K642734155",
      "isbn13": "9791191851069",
      "itemId": 281256147,
      "priceSales": 14400,
      "priceStandard": 16000,
      "mallType": "BOOK",
      "stockStatus": "",
      "mileage": 800,
      "cover": "https://image.aladin.co.kr/product/28125/61/coversum/k642734155_1.jpg",
      "categoryId": 51596,
      "categoryName": "국내도서>종교/역학>기독교(개신교)>기독교(개신교) 신앙생활>간증/영적성장",
      "publisher": "비아토르",
      "salesPoint": 1060,
      "adult": false,
      "fixedPrice": true,
      "customerReviewRank": 9,
      "subInfo": {
        "ebookList": [
          {
            "itemId": 281295529,
            "isbn": "E272539885",
            "priceSales": 12000,
            "link": "https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=281295529&amp;partner=openAPI"
          }
        ],
        "usedList": {
          "aladinUsed": {
            "itemCount": 0,
            "minPrice": 0,
            "link": "https://www.aladin.co.kr/shop/UsedShop/wuseditemall.aspx?ItemId=281256147&amp;TabType=2&amp;partner=openAPI"
          },
          "userUsed": {
            "itemCount": 0,
            "minPrice": 0,
            "link": "https://www.aladin.co.kr/shop/UsedShop/wuseditemall.aspx?ItemId=281256147&amp;TabType=1&amp;partner=openAPI"
          }
        },
        "subTitle": "아름다움, 선함, 진리에 대한 메타 내러티브",
        "originalTitle": "The Magnificent Story",
        "itemPage": 304
      }
    }
  ]
}
 */

public class AladinBookLookUpResult extends AladinApiResponse<AladinBookLookUpResultEntry> {
}
