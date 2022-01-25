class APIENV {
  static const int DEVELOP = 1;
  static const int PRODUCT = 0;
}

int apiEnv = APIENV.PRODUCT;

///混合开发 or 独立运行
const bool mixDev = false;

///调试开关
bool debug = false;

///App beta模式（用于内部测试）
bool beta = false;

///Flutter 独立运行模式下模拟token
const bool shouldMockHeader = !mixDev;
Map<String, String> mockHeader = apiEnv == APIENV.DEVELOP
    ? {
        'X-Auth-Token':
            'LGMa3F0z6r+WGsz9CWdb9Owb9PkwxFCfinDuCAdwRaqsnyT56iIVPlsu2Oj0OYUINRc1xsiwr5oN98V+RSvSRQ=='
      }
    : {
        'X-Auth-Token':
            'l+5xnJZ/Uzr4bPA74BglMaJjKHlVEFWUKEz9jrrR4nKSLEpye+YP7N57UwyLwk5GWa/fcqKzxkHtzcGIEsUVDQ=='
      };

void initGlobal(bool debugMode, bool betaMode,
    {int apiEnvironment, bool review, String app}) {
  // debug = debugMode;
  // beta = betaMode;
  if (apiEnvironment != null) {
    apiEnv = apiEnvironment;
  }
  // isReview = review ?? false;
  // appFlag = app;
}