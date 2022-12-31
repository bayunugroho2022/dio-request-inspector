import 'dart:convert';

class UrlUtil {
  Uri isUrlNeedToOveride(Uri? globalUrl, Uri url) {
    if (globalUrl != null) {
      bool isEligible = url.isAbsolute;
      bool isHaveBaseSection = url.hasAuthority;
      bool isHaveHost = url.host.isNotEmpty;
      bool isOverride = (isEligible && isHaveBaseSection && isHaveHost);

      var result = (isOverride) ? url : compilePathToUri(url, globalUrl);
      return result;
    } else {
      return url;
    }
  }

  Uri compilePathToUri(Uri uri, Uri baseUri) {
    var baseUrl = baseUri.toString();
    var url = uri.toString();
    var result = Uri.parse('$baseUrl$url');
    return result;
  }

  String mapToQuery(Map<String, String> map, {Encoding? encoding}) {
    var pairs = <List<String>>[];
    map.forEach(
      (key, value) => pairs.add(
        [
          Uri.encodeQueryComponent(key, encoding: encoding ?? utf8),
          Uri.encodeQueryComponent(value, encoding: encoding ?? utf8)
        ],
      ),
    );
    return pairs.map((pair) => '${pair[0]}=${pair[1]}').join('&');
  }
}
