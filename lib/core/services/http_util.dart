import 'dart:convert';
import 'dart:io';
import 'package:circle/core/model/account/login_result_model.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'config.dart';

class HttpUtil {

  static HttpUtil instance;
  Dio dio;
  BaseOptions options;

  CancelToken cancelToken = CancelToken();
  CommonDataUtil dataUtil = CommonDataUtil.getInstance();

  static HttpUtil getInstance() {
    if (null == instance) instance = HttpUtil();
    return instance;
  }

  /*
   * config it and create
   */
  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: HttpConfig.baseURL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: HttpConfig.timeout,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 0,
      //Http请求头.
      headers: {
        //do something
        "Accept-Language": "zh-cn",
        "Accept": "application/json",
        "Connetion": "keep-alive",
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: Headers.jsonContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.plain,
    );


    dio = Dio(options);
    _setToken();
    //Cookie管理
    // dio.interceptors.add(CookieManager(CookieJar()));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    // config the http client
      client.findProxy = (uri) {
          //proxy all request to localhost:8888
          return "PROXY 192.168.1.6:8888";
      };
    // you can also create a new HttpClient to dio
    // return new HttpClient();
    };
    //添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前");
      // Do something before request is sent
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前");
      // Do something with response param
      return response; // continue
    }, onError: (DioError e) {
      // if (e.request.path.contains('/files/') && e.response.statusCode == 302) {
      //   print('${e.response.headers['location']}');
      // }
      // print("拦截器error ${e.request.path}");

      print("错误之前");
      // Do something with response error
      return e; //continue
    }));
  }
  
  _setToken({String url}) async {
    if (url != null && url == '/auth/login') {
      dio.options.headers.remove('Authorization');
      return;
    }
    if (!dio.options.headers.keys.toList().contains('Authorization')){
      String tokenType = await dataUtil.getTokenType();
      String token = await dataUtil.getToken();
      if (token.length > 0) dio.options.headers['Authorization'] = '$tokenType $token';
    }

    DateTime expiresIn = await dataUtil.getExpiresIn();
    DateTime refreshTtl = await dataUtil.getRefreshTtl();
    DateTime now = DateTime.now();

    if (!now.isAfter(expiresIn)) return;

    if (now.isBefore(refreshTtl)){
      //token过期后 刷新过期时间前 刷新token
      Response response = await dio.post('/auth/refresh');
      LogInResultModel result = LogInResultModel.fromJson(jsonDecode(response.data));
      await dataUtil.setTokenWithLogInResultModel(result);
      dio.options.headers.remove('Authorization');
      _setToken();
    } else {
      //刷新时间过期 重新登录
      dio.options.headers.remove('Authorization');
    }
  }
  /*
   * get请求
   */
  get(url, {param, options, cancelToken}) async {
    await _setToken();
    Response response;
    try {
      response = await dio.get(url,
          queryParameters: param, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码
    } on DioError catch (e) {
      print('get error----$url-----$e');
      formatError(e);
    }
    return response;
  }

  /*
   * post请求
   */
  post(url, {param, data, options, cancelToken}) async {
    await _setToken(url: url);
    Response response;
    try {
      response = await dio.post(url,
          queryParameters: param, data: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error----$url-----$e');
      formatError(e);
    }
    return response;
  }
  /*
   * delete请求
   */
  delete(url, {param, options, cancelToken}) async {
    await _setToken();
    Response response;
    try {
      response = await dio.delete(url,
          queryParameters: param, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码
    } on DioError catch (e) {
      print('get error----$url-----$e');
      formatError(e);
    }
    return response;
  }
  /*
   * put请求
   */
  put(url, {param, data, options, cancelToken}) async {
    await _setToken();
    Response response;
    try {
      response = await dio.put(url,
          queryParameters: param, data: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码
    } on DioError catch (e) {
      print('get error-----$url----$e');
      formatError(e);
    }
    return response;
  }

  /*
   * patch请求
   */
  patch(url, {param, data, options, cancelToken}) async {
    await _setToken();
    Response response;
    try {
      response = await dio.patch(url,
          queryParameters: param, data: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码
    } on DioError catch (e) {
      print('get error----$url-----$e');
      formatError(e);
    }
    return response;
  }
  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    await _setToken();
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  Future<FormData> getFormDataWithFile(File file) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.absolute.path, filename: file.absolute.path)
    });
    return formData;
  }




  // static final BaseOptions baseOptions = BaseOptions(
  //   baseUrl: HttpConfig.baseURL, 
  //   connectTimeout: HttpConfig.timeout);
  
  // static final Dio dio = Dio(baseOptions);
/*
  static Future<T> request<T>(String url, {
                      String method = "get",
                      Map<String, dynamic> params,
                      Interceptor inter}) async {
    // 1.创建单独配置
    final options = Options(method: method);

    // 全局拦截器
    // 创建默认的全局拦截器
    Interceptor dInter = InterceptorsWrapper(
      onRequest: (options) {
        print("请求拦截");
        return options;
      },
      onResponse: (response) {
        print("响应拦截");
        return response;
      },
      onError: (err) {
        print("错误拦截");
        return err;
      }
    );
    List<Interceptor> inters = [dInter];

    // 请求单独拦截器
    if (inter != null) {
      inters.add(inter);
    }

    // 统一添加到拦截器中
    dio.interceptors.addAll(inters);

    // 2.发送网络请求
    try {
      Response response = await dio.request(url, queryParameters: params, options: options);
      return response.data;
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

  static Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {

    try {
      Response response = await dio.get(url, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
      return response.data;
    } on DioError catch(e) {
      return Future.error(e);
    }

  }

 static Future<Response<T>> post<T>(
    String url, {
    // data,
    Map<String, dynamic> param,
    Options options,
    // CancelToken cancelToken,
    // ProgressCallback onSendProgress,
    // ProgressCallback onReceiveProgress,
  }) async {
    try {
      // Response response = await dio.post(url, queryParameters: queryParameters);
      // return response.data;
      Response response = await HttpRequest.dio.post(url, queryParameters:param);
      return response.data;
    } on DioError catch(e) {
      return Future.error(e);
    }

  }
  */
}