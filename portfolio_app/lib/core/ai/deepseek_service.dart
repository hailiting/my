import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio_app/core/constants/profile_data.dart';

/// DeepSeek 对话服务：Web 走代理，单次请求 token 控制在 1 万以内。
class DeepSeekService {
  DeepSeekService({http.Client? client}) : _client = client ?? http.Client();

  static const _apiUrl = String.fromEnvironment(
    'DEEPSEEK_API_URL',
    defaultValue: 'https://api.deepseek.com/chat/completions',
  );
  static const _apiKey = String.fromEnvironment('DEEPSEEK_API_KEY', defaultValue: '');
  static const _proxyUrl = String.fromEnvironment(
    'AI_PROXY_URL',
    defaultValue: '/api/ai-about',
  );

  final http.Client _client;

  bool get hasDirectKey => _apiKey.isNotEmpty;

  Future<AiAboutResult> generateAbout(String keyword) async {
    final kw = keyword.trim();
    if (kw.isEmpty) {
      throw const AiAboutException('请输入关键词');
    }
    if (kw.length > 48) {
      throw const AiAboutException('关键词请控制在 48 字以内');
    }

    try {
      if (kIsWeb || !hasDirectKey) {
        return await _viaProxy(kw);
      }
      return await _viaDeepSeek(kw, authorization: 'Bearer $_apiKey');
    } on AiAboutException {
      rethrow;
    } catch (e) {
      return AiAboutResult(
        text: ProfileData.aiAboutForKeyword(kw),
        source: AiAboutSource.fallback,
        note: '网络或服务暂不可用，已展示本地模板：$e',
      );
    }
  }

  Future<AiAboutResult> _viaProxy(String keyword) async {
    final uri = Uri.parse(_proxyUrl);
    final res = await _client
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'keyword': keyword}),
        )
        .timeout(const Duration(seconds: 45));

    if (res.statusCode == 503) {
      return AiAboutResult(
        text: ProfileData.aiAboutForKeyword(keyword),
        source: AiAboutSource.fallback,
        note: '未配置服务端 DEEPSEEK_API_KEY，已使用本地模板',
      );
    }

    if (res.statusCode != 200) {
      throw AiAboutException(_parseError(res.body) ?? '服务错误 (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final text = data['text'] as String? ?? '';
    if (text.isEmpty) throw const AiAboutException('AI 返回为空');
    return AiAboutResult(
      text: text.trim(),
      source: AiAboutSource.deepseek,
      model: data['model'] as String?,
      usage: data['usage'] as Map<String, dynamic>?,
    );
  }

  Future<AiAboutResult> _viaDeepSeek(
    String keyword, {
    required String authorization,
  }) async {
    final body = _buildBody(keyword);
    final res = await _client
        .post(
          Uri.parse(_apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 45));

    if (res.statusCode != 200) {
      throw AiAboutException(_parseError(res.body) ?? 'DeepSeek 错误 (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    final content = (choices?.first as Map<String, dynamic>?)?['message']
        ?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw const AiAboutException('AI 返回为空');
    }

    return AiAboutResult(
      text: content.trim(),
      source: AiAboutSource.deepseek,
      model: data['model'] as String?,
      usage: data['usage'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> _buildBody(String keyword) {
    return {
      'model': 'deepseek-chat',
      'messages': [
        {'role': 'system', 'content': ProfileData.aiSystemContext},
        {
          'role': 'user',
          'content': '访客输入关键词：「$keyword」。请生成针对性个人介绍。',
        },
      ],
      'max_tokens': ProfileData.aiAboutMaxOutputTokens,
      'temperature': 0.65,
      'stream': false,
    };
  }

  String? _parseError(String body) {
    try {
      final m = jsonDecode(body) as Map<String, dynamic>;
      final err = m['error'];
      if (err is Map) return err['message'] as String?;
      return m['message'] as String?;
    } catch (_) {
      return null;
    }
  }

  void dispose() => _client.close();
}

enum AiAboutSource { deepseek, fallback }

class AiAboutResult {
  const AiAboutResult({
    required this.text,
    required this.source,
    this.model,
    this.usage,
    this.note,
  });

  final String text;
  final AiAboutSource source;
  final String? model;
  final Map<String, dynamic>? usage;
  final String? note;

  int? get totalTokens {
    final u = usage;
    if (u == null) return null;
    return u['total_tokens'] as int?;
  }
}

class AiAboutException implements Exception {
  const AiAboutException(this.message);
  final String message;

  @override
  String toString() => message;
}
