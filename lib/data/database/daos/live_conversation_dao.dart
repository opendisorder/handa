import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/live_conversations_table.dart';

part 'live_conversation_dao.g.dart';

@DriftAccessor(tables: [LiveConversations])
class LiveConversationDao extends DatabaseAccessor<HandaDatabase>
    with _$LiveConversationDaoMixin {
  LiveConversationDao(super.db);

  /// Get all conversations for a session.
  Future<List<LiveConversation>> getBySession(int sessionId) =>
      (select(liveConversations)
            ..where((t) => t.sessionId.equals(sessionId))
            ..addOrderBy(OrderingTerm.asc(liveConversations.createdAt)))
          .get();

  /// Get conversations by exercise type.
  Future<List<LiveConversation>> getByType(String exerciseType) =>
      (select(liveConversations)
            ..where((t) => t.exerciseType.equals(exerciseType))
            ..addOrderBy(OrderingTerm.desc(liveConversations.createdAt)))
          .get();

  /// Get recent conversation records.
  Future<List<LiveConversation>> getRecent(int limit) =>
      (select(liveConversations)
            ..addOrderBy(OrderingTerm.desc(liveConversations.createdAt))
            ..limit(limit))
          .get();

  /// Insert a new conversation record.
  Future<int> insert(LiveConversationsCompanion entry) =>
      into(liveConversations).insert(entry);

  /// Update an existing record.
  Future<bool> update(LiveConversationsCompanion entry) =>
      update(liveConversations).replace(entry);
}
