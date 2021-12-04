const String readingBooksTestData = '''
  [
    {
      "isbn": "9788988042731",
      "title": "일의 기술",
      "authors": [{ "name": "제프 고인스", "role": "지은이" }, { "name": "윤종석", "role": "옮긴이" }],
      "publisher": "도서출판 CUP",
      "publishedOn": "2016-03-23",
      "totalPages": 272,
      "coverImageUrl": "https://image.aladin.co.kr/product/8036/60/cover150/8988042735_1.jpg",
      "tags": "행복론;마음 다스리기",
      "description": "일에 의한 삶이 아니라 삶을 위한 일의 기술. 저자 제프 고인스는 일이란, 한 사람의 인생이며 삶이라는 측면에서 각 사람에게 주어진 부르심을 찾아가는 여정이라고 보며, 자신의 길을 발견한 수백 명의 사람들의 이야기를 통해 일곱 가지 공통된 특징을 찾아냈다.\\n각 장마다 적절하고 실제적인 예화들을 통해 자신의 길을 정련하며 완성해가는 구체적인 방법을 제시한다. 책을 읽어 가면서 독자는 마치 자신의 생각을 들여다보듯 공감하며, 용기와 자신감을 얻고 인생의 큰 그림을 그려갈 수 있게 될 것이다. 우리가 일도 놀이와 똑같은 방식으로 생각해 즐거움을 위한 추구로 대한다면 그것이 자신과 세상을 변화시킬 것이다.",
      "notes": [
        {
          "author": "Austin",
          "pictureUrls": [
            "https://picsum.photos/id/1073/500"
          ],
          "text": "I love this line!"
        }
      ]
    },
    {
      "isbn": "9791155812679",
      "title": "비밀의 화원",
      "authors": [{ "name": "프랜시스 호슨 버넷", "role": "지은이" }, { "name": "이경아", "role": "옮긴이" }],
      "publisher": "윌북",
      "publishedOn": "2020-05-20",
      "totalPages": 456,
      "coverImageUrl": "https://image.aladin.co.kr/product/23995/8/cover150/k092639218_1.jpg",
      "tags": "영미소설;서양고전;미국문학;어른들을 위한 동화;따뜻한",
      "description": "2020년 출간 110주년을 맞은 <비밀의 화원>이 '걸 클래식 컬렉션 2' 도서로 번역되었다. 10년간 잠겨 있던 비밀의 화원 이야기처럼, 이 작품 또한 비슷한 운명을 지녔다. 유명 작가였던 프랜시스 호지슨 버넷이 이 작품을 '아메리칸 매거진'에 1910년부터 1년간 연재할 당시, <비밀의 화원>은 큰 주목을 받지 못했다. 심지어 버넷이 세상을 떠났을 때에도 버넷의 대표작으로 기록되지 않았다. 하지만 숨겨진 진가를 언젠가 드러내는 비밀의 화원처럼 이 작품 또한 버넷의 사후에 더 주목받았다.\\n2003년 영국 BBC 설문조사, ‘영국이 선택한 소설 200선’ 중 51위를 기록했고, 2007년 온라인 여론조사를 바탕으로 미국 국가교육협회는 이를 '교사가 추천하는 100대 책' 중 하나로 선정했다. 2012년에는 미국 월간 학교도서관저널이 발표한 설문조사에서 역대 아동 소설 중 15위에 올랐다. 100년이 넘은 소설이, 시간이 지날수록 더 사랑받는 이유는 무엇일까? 아이들뿐 아니라 어른들에게도 정원과 식물, 자연이 주는 치유와, 문학의 치유를 가장 이상적으로 구현하고 있는 작품이다.",
      "notes": [
        {
          "author": "Caris",
          "pictureUrls": [
            "https://picsum.photos/id/152/500"
          ],
          "text": "The Secret Garden was what Mary called it. She liked still more the feeling that when its beautiful old walls shut her in no one knew where she was. It seemed almost like being shut out in some fairy place."
        },
        {
          "author": "Caris",
          "pictureUrls": [
            "https://picsum.photos/id/190/500"
          ],
          "text": "It is the sun shining on the rain and the rain falling on the sunshine, and things pushing up and working under the earth.\\nI have had a strange feeling of being happy as if something were pushing and drawing in my chest and making me breathe fast. Magic is always pushing and drawing and making things out of nothing."
        }
      ]
    },
    {
      "isbn": "9791160943733",
      "title": "실격당한 자들을 위한 변론",
      "authors": [{ "name": "김원영", "role": "지은이" }],
      "publisher": "사계절",
      "publishedOn": "2018-06-15",
      "totalPages": 324,
      "coverImageUrl": "https://image.aladin.co.kr/product/11380/16/cover150/k522533969_1.jpg",
      "tags": "인권문제;사회학;인문에세이;사회비평",
      "description": "세상에 태어난 것 자체가 손해인 삶이 있을까? 평생을 방에 누워 있어야 하는 중대한 장애, 자식에게 밥 한 끼 먹이기 어려운 처절한 빈곤, 누구에게도 호감을 사본 적 없는 추한 외모나 다른 성적 지향……. 이런 소수성을 안은 채 소외되고 배척당하며 자기 비하 속에 사는 삶이라면, 차라리 태어나지 않는 편이 낫지 않을까?\\n이 책의 주요 모티프가 된 ‘잘못된 삶 소송’은 장애를 가진 아이가 세상에 태어나, 차라리 태어나지 않는 편이 나았다며 장애를 진단해내지 못한 의사에게 손해배상을 청구하는 민사소송의 한 유형이다. 이 소송은 우리에게 태어난 것이 태어나지 않은 것보다 손해일 수 있는가라는 어려운 질문을 던진다.\\n1급 지체장애인인 변호사 김원영은 성장기 내내 이 질문과 싸워야 했다. 가난한 집에서 걷지 못하는 몸으로 태어난 그는 자신의 존재가 부모와 이 사회는 물론, 스스로에게도 손해인 것은 아닌지 끊임없이 물어야 했다. 이 책에서 그는 자신과 마찬가지로 흔히 ‘잘못된 삶’, ‘실격당한 인생’이라 불리는 이들도 그 존재 자체로 존엄하고 매력적임을 증명해 보이는 변론을 시도한다. 그의 변론은 사람들 간의 일상적인 상호작용에서 어떻게 인간에 대한 존중이 싹트는지를 탐색하며 시작한다.\\n이후 자신의 결핍과 차이를 자기 정체성으로 받아들이는 결단이란 어떤 의미인지를 제시하며, 그렇게 정체성을 받아들이고 살아가는 개개인의 고유한 이야기가 법과 제도의 문에 들어설 수 있는 길을 모색한다. 나아가 모든 존재에게 자신이 누구인지, 어떤 특징과 경험과 선호와 고통을 가진 사람인지를 드러낼 무대가 주어진다면, 소수자들 스스로가 ‘인간 실격’이라는 낙인에 맞서 자신을 변론할 수 있으리란 전망을 제시한다.",
      "notes": [
        {
          "author": "DK",
          "pictureUrls": [
            "https://picsum.photos/id/2/500",
            "https://picsum.photos/id/20/500"
          ],
          "text": "실격당한 자들을 위한 변론. 최고의 책."
        }
      ]
    }
  ]
''';
