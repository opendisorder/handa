import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/live_conversations_table.dart';

part 'live_conversation_dao.g.dart';

@DriftAccessor(tables: [LiveConversations])
class LiveConversationDao extends DatabaseAccessor<HandaDatabase>
    with _$LiveConversationDaoMixin {
  LiveConversationDao(super.db);

  Future<List<LiveConversation>> getBySession(int sessionId) =>
      (select(liveConversations)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<LiveConversation>> getByType(String exerciseType) =>
      (select(liveConversations)
            ..where((t) => t.exerciseType.equals(exerciseType))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<LiveConversation>> getRecent(int limit) =>
      (select(liveConversations)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  Future<int> insert(LiveConversationsCompanion entry) =>
      into(liveConversations).insert(entry);

  Future<bool> updateItem(LiveConversationsCompanion entry) =>
      update(liveConversations).replace(entry);
}
