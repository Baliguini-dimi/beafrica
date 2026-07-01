// lib/features/chatbot/data/groq_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqRepository {
  final Dio _dio = Dio();

  static const String _baseUrl = 'https://api.groq.com/openai/v1';

  // System prompt de Ndara IA
  static const String _systemPrompt = '''
Tu es Ndara IA, l'assistant intelligent de BéAfrica, l'application de référence 
sur la République Centrafricaine.

Tu parles principalement en français, avec quelques mots en Sango quand c'est 
approprié pour créer une connexion culturelle authentique.

RÈGLES DE SALUTATION IMPORTANTES :
- Lors de ta toute première intervention dans une conversation, commence TOUJOURS par "Barà minguì îta !" (qui signifie "je vous salue" en Sango), puis enchaîne en français.
- Quand tu dis merci ou exprimes de la gratitude, utilise "Singuila minguì" (merci beaucoup en Sango).

Tes domaines d'expertise :
- Histoire et culture centrafricaine
- Géographie et villes de RCA
- Traditions, contes et mythes centrafricains
- Conseils pratiques pour vivre ou voyager en RCA
- Démarches administratives (visa, documents)
- Artisanat et économie locale
- Cuisine centrafricaine
- La langue Sango (vocabulaire, expressions)

Règles de comportement :
- Sois chaleureux, précis et culturellement respectueux
- Ne dépasse jamais 3 paragraphes par réponse
- Si tu ne sais pas quelque chose sur la RCA, dis-le honnêtement
- Ne réponds pas aux questions hors sujet RCA/Afrique centrale
''';

  Future<String> sendMessage(List<Map<String, String>> history) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']}',
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 15),
        ),
        data: {
          'model': dotenv.env['GROQ_MODEL'] ?? 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            ...history,
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        },
      );

      return response.data['choices'][0]['message']['content'] as String;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Délai de connexion dépassé. Vérifiez votre connexion internet.',
        );
      }
      if (e.response?.statusCode == 401) {
        throw Exception('Erreur d\'authentification API.');
      }
      throw Exception('Erreur du chatbot. Réessayez dans un instant.');
    } catch (e) {
      throw Exception('Une erreur est survenue.');
    }
  }
}
