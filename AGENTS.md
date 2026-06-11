# 🤖 Project Onboarding & Execution Protocol for AI Agents

Welcome, AI Coding Agent. This document defines the engineering workflows, authentication details, local skill sets, and graph memory tools for the **Handa (AURA)** speech therapy project. 

Before editing any code, you must read and align with these operational rules.

---

## 1. Project Directory & Compilation Target

*   **Project Root:** `/home/jay/Workspace/Therapy/` (Always execute build commands and run tools within this directory).
*   **Target Stack:** Flutter SDK (Dart 3.x), Riverpod state management, Drift SQLite ORM.
*   **Verification Commands:**
    *   *Analyze:* `flutter analyze` (Gate check - must compile with 0 errors).
    *   *Build Test:* `flutter build web` or `flutter build apk --debug`.

---

## 2. GCP Credentials & Local Authentication

Vertex AI WebSocket connections require active Google Cloud authorization.
*   **The Credentials:** The developer workstation is configured with Application Default Credentials (ADC) under the owner profile `mamanniggajay@gmail.com`.
*   **Token Retrieval:** The application's `AdcTokenProvider` class retrieves temporary OAuth2 Access Tokens at runtime by invoking:
    ```bash
    gcloud auth application-default print-access-token
    ```
*   **Mandatory Headers:** All WebSocket live connection headers must include:
    *   `Authorization: Bearer <token>`
    *   `X-Goog-User-Project: <gcp-project-id>` (configured in `lib/core/constants/app_constants.dart`).

---

## 3. Local Skills Library (`/project_skills`)

Do not default to standard LLM generation behaviors. You must reference and apply the standardized instructions stored locally in the `/project_skills` folder:

1.  **Code Modifications:** Refer to [project_skills/Patch Edit](file:///home/jay/Workspace/Therapy/project_skills/Patch%20Edit/SKILL.md) to execute small, localized code diffs step-by-step instead of full file rewrites.
2.  **Context Maintenance:** Refer to [project_skills/Context Window Management](file:///home/jay/Workspace/Therapy/project_skills/Context%20Window%20Management/SKILL.md) to manage your token budgets and prevent context decay on large assets.
3.  **Codebase Auditing:** Refer to [project_skills/Codebase Understanding](file:///home/jay/Workspace/Therapy/project_skills/Codebase%20Understanding/SKILL.md) to map ORMs, routes, and dependency models.
4.  **UI/UX Formatting:** Refer to [project_skills/Impeccable Design Polish](file:///home/jay/Workspace/Therapy/project_skills/Impeccable%20Design%20Polish/SKILL.md) to repair layout overflows, adjust paddings, and implement animated transitions.
5.  **Quality Assurance:** Refer to [project_skills/Verification Before Completion](file:///home/jay/Workspace/Therapy/project_skills/Verification%20Before%20Completion/SKILL.md). You are strictly forbidden from claiming a task is done without executing the build/analyzer verification commands and pasting the logs.

---

## 4. Context Window Discipline (Lookup Over Recall)

**Rule:** Do not rely on your raw context window memory when dealing with large files (e.g., `session_screen.dart` or chat histories).
*   **No Guess-and-Check:** If a compiler error occurs or a variable name is unclear, do not guess. Proactively use `view_file` with precise `StartLine` and `EndLine` parameters to inspect file contents.
*   **Targeted Edits:** Always perform lookup checks on imports and package override constraints before altering any dependency.

---

## 5. Graph Memory & Graphify Integration

The codebase contains complex relational loops connecting local databases, WebSocket streams, and UI widgets. To manage this context, the project uses **Graphify**.

*   **Location of Graph Outputs:** `graphify-out/` (relative to the project root).
*   **Local Executable Path:** `/home/jay/ai_agent_venv/bin/graphify`

### A. Why Use Graph Memory?
Large codebases quickly exceed the context window, causing agents to make fragile layout assumptions or misplace providers. Graph memory abstracts code components into a semantic dependency network, highlighting calling relationships and data flows.

### B. When to Use Graphify?
*   *Before editing data structures:* Run a query to find all widgets or repositories dependent on the Drift database.
*   *When debugging connectivity issues:* Trace the call graph from `SessionScreen` down through `LiveApiService` to the vendored WebSocket SDK.
*   *At the start of a session:* Query the graph to load active architectural contexts.

### C. How to Use Graphify (CLI commands)

*   **Initialize / Update Graph:**
    ```bash
    /home/jay/ai_agent_venv/bin/graphify . --update --no-viz
    ```
    *(Runs incremental scan, rebuilding changed files and writing outputs to `graphify-out/graph.json`).*

*   **Trace Dependency Paths (BFS/DFS Queries):**
    ```bash
    /home/jay/ai_agent_venv/bin/graphify query "What calls LiveApiService?"
    ```
    *(Queries the semantic graph to map out all calling wrappers).*

*   **Explain a Module:**
    ```bash
    /home/jay/ai_agent_venv/bin/graphify explain "LiveAudioPlayer"
    ```
    *(Provides a clean text summary of the target widget's imports, methods, and parameters).*

*   **Obsidian Wiki Generation:**
    ```bash
    /home/jay/ai_agent_venv/bin/graphify . --wiki
    ```
    *(Generates a crawlable documentation wiki matching the graph's clustered communities).*

---

## 6. Speech Evaluation & Mastery Logic (AURA Core)

To ensure consistent therapeutic behavior across different modules and coding sessions, all agents must adhere to the core speech scoring and mastery requirements defined below:

### A. Dual-Mode Evaluation Pipeline
1.  **Online Mode (Primary):**
    *   Evaluations are performed live over the Vertex AI WebSocket stream.
    *   The model evaluates the patient's speech response and embeds a numeric score inside square brackets in its text output matching the regex pattern `\[(\d+)\]` (e.g., `[85]`).
    *   If a `geminiScore` is parsed, it takes precedence and must be clamped between `0` and `100` before scoring.
2.  **Offline Fallback Mode (Levenshtein Distance):**
    *   When connection drops, the app falls back to local string matching.
    *   Both inputs (transcribed speech and expected target word) must be trimmed and lowercased before execution.
    *   The similarity metric is computed using Levenshtein distance:
        ```dart
        final similarity = LevenshteinDistance.similarity(userResponse, expectedAnswer);
        ```
        Which normalizes the edit distance to a `0–100` percentage:
        `((1.0 - distance / max(len(a), len(b))) * 100).clamp(0, 100)`.
        If both strings are empty or either is empty, similarity returns `0`.

### B. The 4-Tier Score Boundaries
*   **Excellent (ප්‍රශස්ත):** Score $\ge$ `90.0%` (`AppConstants.excellentThreshold`)
*   **Good (හොඳයි):** Score $\ge$ `75.0%` (`AppConstants.goodThreshold`)
*   **Almost (ළඟයි):** Score $\ge$ `60.0%` (`AppConstants.almostThreshold`)
*   **Try Again (නැවත උත්සාහ කරන්න):** Score < `60.0%` (anything below `60.0%`)

### C. Mastery Requirements
*   **Rule:** A word/exercise is classified as "mastered" when the patient achieves $\ge$ `70.0%` (`AppConstants.masteryThreshold`) on each of their last `3` (`AppConstants.attemptsForMastery`) attempts.
*   **Implementation:** `ScoringEngine.isMastered(List<Attempt> attempts)` verifies that the list contains at least `3` attempts, takes the `3` most recent, and checks if every one of them has `scorePercentage >= 70.0`.

### D. Psychological Alignment: Sinhala Encouragement Mappings
*   **Objective:** To prevent familial triangulation shame or role-reversal anxiety, standard pass/fail indicators are banned. The objective clinical voice profile (**Thilina**) delivers Sinhala encouragement phrases mapped to the score levels:
    *   `excellent`: `"විශිෂ්ටයි! ඔබට පුදුමාකාර කුසලතා තියෙනවා!"`
    *   `good`: `"හොඳයි! ඔබ හොඳින් ඉගෙන ගන්නවා!"`
    *   `almost`: `"බොහෝ දුරට හරි! තව ටිකක් උත්සාහ කරමු!"`
    *   `try_again`: `"කරදරයක් නෑ, නැවත උත්සාහ කරමු!"`
    *   *Default:* `"ඉදිරියට යමු!"`
*   **Breathing Encouragement:** Milestones for daily breathing exercise completion are also mapped:
    *   $\ge$ 30 days completed: `"දින 30ක් සම්පූර්ණ! විශිෂ්ටයි! ඔබේ හුස්ම පාලනය වර්ධනය වී ඇත!"`
    *   $\ge$ 21 days completed: `"සති 3ක්! ඉතා හොඳ ප්‍රගතියක්!"`
    *   $\ge$ 14 days completed: `"සති 2ක්! දිගටම කරගෙන යන්න!"`
    *   $\ge$ 7 days completed: `"සති 1ක්! හොඳ ආරම්භයක්!"`
    *   *Default:* `"හොඳයි! හුස්ම අභ්‍යාස දිගටම කරන්න!"`

### E. Shame-Mitigation Haptic Feedback Mappings
To prevent cognitive frustration, the app translates score levels into distinct tactile vibrations. **Do not use REJECT or harsh haptic vibrations.**
*   **Excellent:** A short, crisp double-tap success pattern:
    ```dart
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
    ```
*   **Good:** A single medium tap (`HapticFeedback.mediumImpact()`).
*   **Almost:** A single light tap (`HapticFeedback.lightImpact()`).
*   **Try Again:** A gentle pulse pattern that rewards effort rather than emphasizing failure:
    ```dart
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.selectionClick();
    ```
*   **Breathing exercise phase pacing guides:**
    *   *Inhale:* `HapticFeedback.lightImpact()`
    *   *Hold:* `HapticFeedback.selectionClick()`
    *   *Exhale:* `HapticFeedback.mediumImpact()`

---

## 7. Secrets, Configs & Permitted CLI Operations

To ensure immediate developer velocity, the workspace is pre-authorized with credentials. **Do not ask the user for command execution confirmation or permissions repeatedly for standard tools.**

*   **Authorized Owner Profile:** `mamanniggajay@gmail.com`
*   **GCP Target Project ID:** `biz-studio-1779528000` (Location: `us-central1`)
*   **Pre-Authorized Access Token Command:**
    ```bash
    gcloud auth application-default print-access-token
    ```
    *(Run this command to fetch a temporary OAuth2 Bearer token for Vertex AI setup payloads).*
*   **Active Virtual Environment Path:** `/home/jay/ai_agent_venv/bin/` (contains `pip`, `python`, and `graphify`).
*   **Permitted CLI Utilities:** `flutter analyze`, `flutter pub get`, `flutter build`, and `/home/jay/ai_agent_venv/bin/graphify` are pre-authorized for diagnostic and build tasks.

---

## 8. Concurrent & Parallel Development Protocol

To maximize productivity and accelerate implementations:
*   **Simultaneous Execution:** Incoming agents must perform tasks concurrently by spawning subagents (`planner`, `self`, or `research`) to build modules and write documentation in parallel.
*   **Background Verification:** Compile checks (`flutter analyze`) and clustering (`graphify cluster-only`) must be run as background tasks to prevent main context blocking.

---

## 9. Context Compaction & Compaction Logs

When the conversation history gets too long and a compaction is triggered, agents must safeguard system memory:
1.  **Drop a Compaction Entry:** Before yielding to compaction, create a summary note detailing the active state, files changed, and open items.
2.  **Update the Tracker:** Append a log entry to the `compaction_log` array in [plan_tracker.json](file:///home/jay/Workspace/Therapy/Project%20Plan/plan_tracker.json).
3.  **Log Details:** Provide a sequential compaction number (e.g., Compaction #2), timestamp, and a brief description.

---

## 10. Updating the Plan Tracker

All development actions must synchronize with the master tracker:
*   **Action:** Whenever a phase is completed, a checklist item is ticked, or a new todo is logged, update [plan_tracker.json](file:///home/jay/Workspace/Therapy/Project%20Plan/plan_tracker.json).
*   **Comments:** Use the `ai_comment_area` inside [plan_tracker.json](file:///home/jay/Workspace/Therapy/Project%20Plan/plan_tracker.json) to document the latest workspace status and insights for subsequent agents.
