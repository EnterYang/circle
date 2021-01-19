/*
名称	类型	描述
w	float	需要获取的图片宽度，小数点后两位。
h	float	需要获取的图片高度，小数点后两位。
q	integer	可选，1 <= q <= 100，可以和 w、h 配合使用，也可以单独使用，该参数表示图片质量
b	Integer	可选，范围 0 - 100 ，表示需要高斯模糊的程度。
json	mixed	可选，不存在的情况下资源会使用 302 网络状态重定向到真实地址，如果存在则以 json 格式返回地址
*/
class GetFileParamModel {
  double w;
  double h;
  int q;
  int b;
  String json;

  GetFileParamModel ({this.w, this.h, this.q = 50, this.b });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (w != null){
      data['w'] = this.w;
    }
    if (h != null){
      data['h'] = this.h;
    }
    data['q'] = this.q;
    if (b != null){
      data['b'] = this.b;
    }
    
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['url'] = '';
    data['json'] = jsonData;

    return data;
  }
}