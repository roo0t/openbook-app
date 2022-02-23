package com.glow.openbook.book.aladin;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

/* Example response:
    {
        "version":"20131101",
        "logo":"http://image.aladin.co.kr/img/header/2011/aladin_logo_new.gif",
        "title":"알라딘 검색결과 - 위대한 이야기",
        "link":"http:\/\/www.aladin.co.kr\/search\/wsearchresult.aspx?KeyWord=%c0%a7%b4%eb%c7%d1+%c0%cc%be%df%b1%e2&amp;SearchTarget=book&amp;partner=openAPI",
        "pubDate":"Sat, 13 Nov 2021 06:57:05 GMT",
        "totalResults":246,
        "startIndex":1,
        "itemsPerPage":10,
        "query":"위대한 이야기",
        "searchCategoryId":0,
        "searchCategoryName":"전체",
        "item":[
            {"title":"위대한 이야기 - 아름다움, 선함, 진리에 대한 메타 내러티브","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=281256147&amp;partner=openAPI&amp;start=api","author":"제임스 브라이언 스미스 (지은이), 이대근 (옮긴이)","pubDate":"2021-10-11","description":"“기독교의 이야기는 어떤 삶을 만들어 내는가?” 인생의 중요한 질문에 답할 수 있는 큰 이야기. 신학적 통찰력과 목회적 현실 감각을 살려 우리 인생의 중요한 질문에 답을 제공하고 우리 삶을 빚어 갈 메타 내러티브를 소개한 책이다.","isbn":"K642734155","isbn13":"9791191851069","itemId":281256147,"priceSales":14400,"priceStandard":16000,"mallType":"BOOK","stockStatus":"","mileage":800,"cover":"https:\/\/image.aladin.co.kr\/product\/28125\/61\/cover\/k642734155_1.jpg","categoryId":51596,"categoryName":"국내도서>종교\/역학>기독교(개신교)>기독교(개신교) 신앙생활>간증\/영적성장","publisher":"비아토르","salesPoint":1415,"adult":false,"fixedPrice":true,"customerReviewRank":9,"subInfo":{}},
            {"title":"세상에서 가장 위대한 이야기","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=70331028&amp;partner=openAPI&amp;start=api","author":"케빈 드영 (지은이), 돈 클락 (그림), 박총 (옮긴이)","pubDate":"2015-11-16","description":"베스트셀러 작가이자 설교자 케빈 드영이 누구나 알고 있는 크리스마스 이야기를 성경 본문에 충실하면서도 신선한 메시지로 전한다. 이야기와 함께 한 강렬한 그림들은 모두 디자인 업계에 잘 알려진 일러스트레이터 돈 클락의 작품이다.","isbn":"8932530564","isbn13":"9788932530567","itemId":70331028,"priceSales":16200,"priceStandard":18000,"mallType":"BOOK","stockStatus":"","mileage":900,"cover":"https:\/\/image.aladin.co.kr\/product\/7033\/10\/cover\/8932530564_1.jpg","categoryId":51593,"categoryName":"국내도서>종교\/역학>기독교(개신교)>기독교(개신교) 목회\/신학>설교\/성경연구","publisher":"성서유니온선교회","salesPoint":504,"adult":false,"fixedPrice":true,"customerReviewRank":0,"subInfo":{}},
            {"title":"10대를 위한 한 줄 과학 - 명언으로 쉽게 배우는 위대한 과학사","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=280305875&amp;partner=openAPI&amp;start=api","author":"알렉시스 로젠봄 (지은이), 윤여연 (옮긴이), 권재술 (감수)","pubDate":"2021-09-30","description":"과학의 대중화에 관심 많은 과학철학자 알렉시스 로젠봄이 44개의 명언을 통해 과학의 역사를 설명한다. 고대부터 현대까지 과학사의 흐름에 따라 장이 구성되어 있지만, 시기별로 나열하기보다 명언을 남긴 과학자에 초점을 맞추어 전개해 나간다.","isbn":"K642734030","isbn13":"9791197155161","itemId":280305875,"priceSales":11700,"priceStandard":13000,"mallType":"BOOK","stockStatus":"","mileage":650,"cover":"https:\/\/image.aladin.co.kr\/product\/28030\/58\/cover\/k642734030_1.jpg","categoryId":1143,"categoryName":"국내도서>청소년>청소년 수학\/과학","publisher":"이야기공간","salesPoint":640,"adult":false,"fixedPrice":true,"customerReviewRank":10,"subInfo":{}},
            {"title":"위대한 동양유산에 담긴 8가지 재미있는 이야기","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=564938&amp;partner=openAPI&amp;start=api","author":"배수원 (지은이), 오정아 (그림)","pubDate":"2005-06-07","description":"","isbn":"897288832X","isbn13":"9788972888321","itemId":564938,"priceSales":8550,"priceStandard":9500,"mallType":"BOOK","stockStatus":"","mileage":470,"cover":"https:\/\/image.aladin.co.kr\/product\/56\/49\/cover\/897288832x_2.jpg","categoryId":48900,"categoryName":"국내도서>어린이>문화\/예술\/인물>세계문화","publisher":"어린이작가정신","salesPoint":345,"adult":false,"fixedPrice":true,"customerReviewRank":9,"seriesInfo":{"seriesId":13095,"seriesLink":"http://www.aladin.co.kr/shop/common/wseriesitem.aspx?SRID=13095&amp;partner=openAPI","seriesName":"재미있는 이야기 살아있는 역사 2"},"subInfo":{}},
            {"title":"위대한 서양미술사 2 - 서양 예술을 단숨에 독파하는 미술 이야기","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=281762739&amp;partner=openAPI&amp;start=api","author":"권이선 (지은이)","pubDate":"2021-10-25","description":"마치 뮤지엄에서 전문 큐레이터의 설명을 듣는 것처럼 편안하게 읽을 수 있다. 작품의 기술방식과 도판의 배치가 뮤지엄 현장에서 작품을 접하듯 감상의 즐거움을 더해 주기 때문이다. 책의 저자인 권이선 큐레이터는 뉴욕을 기반으로 전시기획과 평론을 해온 베테랑이다.","isbn":"K422835662","isbn13":"9791197582103","itemId":281762739,"priceSales":19800,"priceStandard":22000,"mallType":"BOOK","stockStatus":"","mileage":1100,"cover":"https:\/\/image.aladin.co.kr\/product\/28176\/27\/cover\/k422835662_1.jpg","categoryId":50982,"categoryName":"국내도서>예술\/대중문화>미술>미술사","publisher":"가로책길","salesPoint":520,"adult":false,"fixedPrice":true,"customerReviewRank":0,"seriesInfo":{"seriesId":1010705,"seriesLink":"http://www.aladin.co.kr/shop/common/wseriesitem.aspx?SRID=1010705&amp;partner=openAPI","seriesName":"위대한 서양미술사 2"},"subInfo":{}},
            {"title":"청소년을 위한 위대한 수학자들 이야기 - 고대 그리스부터 20세기 초까지","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=273718079&amp;partner=openAPI&amp;start=api","author":"야노 겐타로 (지은이), 손영수 (옮긴이)","pubDate":"2021-06-01","description":"청소년들은 물론이고 그동안 막연하게 수학을 어렵다고만 생각했던 일반 독자들에게도 산수나 수학에 흥미를 갖게 하고 고대 수학자들의 에피소드와 그 업적을 알게 함으로써 더욱 친숙하게 수학을 접할 수 있도록 만들어진 책이다.","isbn":"8970449671","isbn13":"9788970449678","itemId":273718079,"priceSales":12350,"priceStandard":13000,"mallType":"BOOK","stockStatus":"","mileage":650,"cover":"https:\/\/image.aladin.co.kr\/product\/27371\/80\/cover\/8970449671_1.jpg","categoryId":1143,"categoryName":"국내도서>청소년>청소년 수학\/과학","publisher":"전파과학사","salesPoint":249,"adult":false,"fixedPrice":true,"customerReviewRank":0,"subInfo":{}},
            {"title":"폰더 씨의 위대한 하루 - 한 남자의 인생을 바꾼 7가지 선물 이야기","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=8643937&amp;partner=openAPI&amp;start=api","author":"앤디 앤드루스 (지은이), 이종인 (옮긴이)","pubDate":"2011-01-18","description":"\"데이비드 폰더\"라는 한 중년 가장이 만 하루 동안 겪은 환상여행을 감동적인 필치로 그려낸 책이다. 연이은 실직, 쌓인 빚, 딸의 대수술 등으로 곤경에 처한 40대 가장 폰더 씨는 우연한 사고로 인해 역사 속으로 여행을 떠나게 된다. 폰더 씨는 여행에서 7명의 역사적 인물―트루먼 대통령, 안네 프랑크, 체임벌린 대령, 콜럼버스 등―을 차례로 만나게 되는데, 이들에게서 '성공적인 삶이란 어떤 것인가'에 관한 소중한 메시지 7가지를 선물로 받고서 환상에서 깨어난다.","isbn":"8984073474","isbn13":"9788984073470","itemId":8643937,"priceSales":10800,"priceStandard":12000,"mallType":"BOOK","stockStatus":"","mileage":600,"cover":"https:\/\/image.aladin.co.kr\/product\/864\/39\/cover\/8984073474_1.jpg","categoryId":70216,"categoryName":"국내도서>자기계발>성공>성공학","publisher":"세종(세종서적)","salesPoint":4750,"adult":false,"fixedPrice":true,"customerReviewRank":8,"seriesInfo":{"seriesId":21723,"seriesLink":"http://www.aladin.co.kr/shop/common/wseriesitem.aspx?SRID=21723&amp;partner=openAPI","seriesName":"폰더씨 시리즈 1"},"subInfo":{}},
            {"title":"위대한 발명 이야기 - 세상을 바꾸는 놀라운 생각","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=2068016&amp;partner=openAPI&amp;start=api","author":"애나 클레이본 (지은이), 애덤 라컴 (그림), 김명남 (옮긴이)","pubDate":"2008-04-20","description":"&lt;세상을 바꾸는 놀라운 생각 위대한 발명 이야기&gt;는 이렇게 우리 사회를 만들고 우리의 삶을 바꾸어 온 다양한 발명품이 누구에 의해서 어떻게 만들어졌는지, 원리가 무엇인지를 알기 쉽게 설명해주는 책이다. 각각의 발명가들이 발명을 하게 된 계기와 발명의 과정, 발명품의 원리 등 발명에 관한 정보를 소개한다.","isbn":"8952751663","isbn13":"9788952751669","itemId":2068016,"priceSales":7200,"priceStandard":8000,"mallType":"BOOK","stockStatus":"","mileage":400,"cover":"https:\/\/image.aladin.co.kr\/product\/206\/80\/cover\/8952751663_1.jpg","categoryId":48867,"categoryName":"국내도서>어린이>과학\/수학\/컴퓨터>과학 일반","publisher":"시공주니어","salesPoint":222,"adult":false,"fixedPrice":true,"customerReviewRank":10,"seriesInfo":{"seriesId":5317,"seriesLink":"http://www.aladin.co.kr/shop/common/wseriesitem.aspx?SRID=5317&amp;partner=openAPI","seriesName":"시공주니어 어린이 교양서 16"},"subInfo":{}},
            {"title":"나의 행복과 모두의 행복 - 벤담이 들려주는 최대 다수의 최대 행복 이야기","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=220752489&amp;partner=openAPI&amp;start=api","author":"서정욱 (지은이)","pubDate":"2019-12-09","description":"어느 날 갑자기 1700년대 영국으로 떨어진 주인공들이 훗날 위대한 철학자가 되는 어린 벤담을 만난다는 흥미로운 이야기를 담고 있다. 시공간의 이동이라는 재미난 설정, 개성 넘치는 등장인물들의 새로운 만남과 생생한 에피소드 등을 통해 벤담의 철학을 쉽고 재미있게 풀어낸다.","isbn":"8954440231","isbn13":"9788954440233","itemId":220752489,"priceSales":10800,"priceStandard":12000,"mallType":"BOOK","stockStatus":"","mileage":600,"cover":"https:\/\/image.aladin.co.kr\/product\/22075\/24\/cover\/8954440231_1.jpg","categoryId":48912,"categoryName":"국내도서>어린이>사회\/역사\/철학>철학","publisher":"자음과모음","salesPoint":3722,"adult":false,"fixedPrice":true,"customerReviewRank":10,"seriesInfo":{"seriesId":845480,"seriesLink":"http://www.aladin.co.kr/shop/common/wseriesitem.aspx?SRID=845480&amp;partner=openAPI","seriesName":"위대한 철학자가 들려주는 어린이 인문교양 8"},"subInfo":{}},
            {"title":"초강력 아빠 팬티 - 세상에서 가장 위대한 아빠 이야기","link":"http:\/\/www.aladin.co.kr\/shop\/wproduct.aspx?ItemId=7270234&amp;partner=openAPI&amp;start=api","author":"타이-마르크 르탄 (글), 바루 (그림), 이주희 (옮긴이)","pubDate":"2010-07-15","description":"많고 많은 팬티 중에 아빠는 슈퍼 챔피언이라는 글자가 새겨진 팬티를 늘 입고 다닙니다. 그 팬티는 엄마가 자신의 사랑을 듬뿍 담아 금빛 실로 수놓아 준 팬티입니다. 프로 레슬링 선수인 아빠는 무지 힘이 세고 자신의 일을 사랑하며 열정이 대단합니다. 아빠의 초강력 힘은 마치 엄마가 선물한 팬티에서 나오는 듯합니다. 아이가 상상하는 가장 완벽한 아빠의 모습을 기발한 상상력으로 그려낸 저학년 동화. <알몸으로 학교 간 날>에 이어 두 번째로 소개되는 프랑스 작가 타이-마르크 르탄의 작품입니다.","isbn":"8965130328","isbn13":"9788965130321","itemId":7270234,"priceSales":8820,"priceStandard":9800,"mallType":"BOOK","stockStatus":"","mileage":490,"cover":"https:\/\/image.aladin.co.kr\/product\/727\/2\/cover\/8965130328_1.jpg","categoryId":48861,"categoryName":"국내도서>어린이>초등 전학년>그림책","publisher":"아름다운사람들","salesPoint":3550,"adult":false,"fixedPrice":true,"customerReviewRank":9,"seriesInfo":{"seriesId":17944,"seriesLink":"http://www.aladin.co.kr/shop/common/wseriesitem.aspx?SRID=17944&amp;partner=openAPI","seriesName":"꿈공작소 4"},"subInfo":{}}
        ]
    }
 */

@Getter
@Data
@NoArgsConstructor
public class AladinApiResponse<ItemType> {
    private String version;
    private String logo;
    private String title;
    private String link;
    private String pubDate;
    private int totalResults;
    private int startIndex;
    private int itemsPerPage;
    private String query;
    private int searchCategoryId;
    private String searchCategoryName;
    private List<ItemType> item;
}
