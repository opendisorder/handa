# .alldocs File Index

This index provides a comprehensive map of every file stored in `.alldocs`, complete with exact folder paths and clickable links.

### /Agent_Subsystems/
*   [Agent_Subsystems/brain_region_updater.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/brain_region_updater.md) - Rules for updating the patient's long-term cognitive state (Prefrontal Cortex, Hippocampus, etc.).
*   [Agent_Subsystems/emotional_arc_extractor.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/emotional_arc_extractor.md) - System design for tracking emotional valence over the course of a session.
*   [Agent_Subsystems/function_call_handler.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/function_call_handler.md) - Specifications for executing UI-based function calls triggered by the Vertex AI model.
*   [Agent_Subsystems/mediapipe_face_mesh_integration.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/mediapipe_face_mesh_integration.md) - Design for on-device facial tracking to detect frustration and struggle without audio input.
*   [Agent_Subsystems/memory_injection_generator.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/memory_injection_generator.md) - How context is loaded from the database into the LLM context window pre-session.
*   [Agent_Subsystems/relationship_tree_updater.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/relationship_tree_updater.md) - Logic for analyzing references to family/friends and adjusting the relationship weights.
*   [Agent_Subsystems/session_fusion_analysis.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/session_fusion_analysis.md) - The post-session summary generation engine.
*   [Agent_Subsystems/speech_metrics_calculator.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/speech_metrics_calculator.md) - The Levenshtein-distance acoustic scoring pipeline.
*   [Agent_Subsystems/therapeutic_insight_extractor.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/therapeutic_insight_extractor.md) - Identifies psychological insights and therapy breakthroughs during speech tasks.
*   [Agent_Subsystems/vertex_ai_live_api_setup.md](file:///home/jay/Workspace/Therapy/.alldocs/Agent_Subsystems/vertex_ai_live_api_setup.md) - Technical setup logic for the Live WebSocket.

### /Chat_Histories/
*   [Chat_Histories/gemini_ui_ux_chat.md](file:///home/jay/Workspace/Therapy/.alldocs/Chat_Histories/gemini_ui_ux_chat.md) - Raw chat history focused on Riverpod UI/UX design decisions.
*   [Chat_Histories/kimi_webapp_chat_1.md](file:///home/jay/Workspace/Therapy/.alldocs/Chat_Histories/kimi_webapp_chat_1.md) - Initial chat history exploring the web app conversion logic.
*   [Chat_Histories/kimi_webapp_chat_2.md](file:///home/jay/Workspace/Therapy/.alldocs/Chat_Histories/kimi_webapp_chat_2.md) - Extended chat history continuing the web app discussion.
*   [Chat_Histories/opencode_session_1554.md](file:///home/jay/Workspace/Therapy/.alldocs/Chat_Histories/opencode_session_1554.md) - The massive 21,000-line OpenCode trajectory where the Flutter codebase was actually scaffolded.
*   [Chat_Histories/Gemini_Live_Therapy_App_Transcript.docx](file:///home/jay/Workspace/Therapy/.alldocs/Chat_Histories/Gemini_Live_Therapy_App_Transcript.docx) - The original Word Document containing the Gemini Live therapy app prototyping chat logs.
*   [Chat_Histories/Gemini_Live_Therapy_App_Transcript.md](file:///home/jay/Workspace/Therapy/.alldocs/Chat_Histories/Gemini_Live_Therapy_App_Transcript.md) - Markdown text extraction of the Gemini Live therapy app prototyping chat logs.

### /Core_Architecture/
*   [Core_Architecture/AURA_Digital_Brain_Clone_Architecture.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/AURA_Digital_Brain_Clone_Architecture.md) - The biological folder-hierarchy concept mapping AI memory to human brain regions.
*   [Core_Architecture/AURA_MASTER_PROMPT.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/AURA_MASTER_PROMPT.md) - The root configuration prompt defining the AI persona and core directive.
*   [Core_Architecture/AURA_Memory_Psychology_Architecture.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/AURA_Memory_Psychology_Architecture.md) - Deep dive into how the AI uses memory (Stranger Effect, Neutral Authority).
*   [Core_Architecture/AURA_PRD_for_AI_App_Builder.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/AURA_PRD_for_AI_App_Builder.md) - The comprehensive Product Requirements Document defining all features and phases.
*   [Core_Architecture/AURA_Speech_Therapy_Framework_v1.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/AURA_Speech_Therapy_Framework_v1.md) - The clinical framework for the 5-stage cueing ladder.
*   [Core_Architecture/AURA_Vertex_AI_Implementation_Guide.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/AURA_Vertex_AI_Implementation_Guide.md) - The master technical guide to building the Live API connection in Flutter.
*   [Core_Architecture/Complete_App_Architecture_MVP.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/Complete_App_Architecture_MVP.md) - Conceptual MVP architecture mapping Mode 1 and Mode 2 live exercises.
*   [Core_Architecture/Complete_App_Experience_Fathers_Stroke_Rehab.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/Complete_App_Experience_Fathers_Stroke_Rehab.md) - A narrative walkthrough of the end-user experience.
*   [Core_Architecture/Complete_App_Experience_Stroke_Rehab_2.md](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/Complete_App_Experience_Stroke_Rehab_2.md) - A secondary variant of the app experience walkthrough.
*   [Core_Architecture/Experience_Design_Philosophy.txt](file:///home/jay/Workspace/Therapy/.alldocs/Core_Architecture/Experience_Design_Philosophy.txt) - Raw notes on UI/UX details, success feedback pacing, and caregiver shields.

### /Reference_Code/
*   [Reference_Code/aura-extracted/](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted) - The unzipped React/Node.js reference architecture used to derive the Flutter backend logic.
    *   [backend/server.js](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/backend/server.js) - Node.js/Express server that acts as a proxy for Google Cloud API calls, fetches OAuth2 Bearer tokens, and sets up WebSocket relay.
    *   [frontend/App.tsx](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/App.tsx) - Main React application component containing the primary therapeutic UI screens.
    *   [frontend/hooks/useGeminiLive.ts](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/hooks/useGeminiLive.ts) - React hook containing the WebSocket setup and raw byte communication logic with Gemini Live.
    *   [frontend/services/audioUtils.ts](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/services/audioUtils.ts) - Audio processing utility functions including PCM conversion and WAV file headers.
    *   [frontend/components/widgets/](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/components/widgets/) - Reusable widgets for the interactive therapy views:
        *   [BreathingWidget.tsx](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/components/widgets/BreathingWidget.tsx) - Pacing and diaphragmatic circle expansions.
        *   [ConversationWidget.tsx](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/components/widgets/ConversationWidget.tsx) - Real-time conversational interface.
        *   [ExerciseWidget.tsx](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/components/widgets/ExerciseWidget.tsx) - Picture naming tasks and clinical scoring states.
        *   [ReportWidget.tsx](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-extracted/frontend/components/widgets/ReportWidget.tsx) - Weekly progress summaries.
*   [Reference_Code/aura-speech-therapy.zip](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/aura-speech-therapy.zip) - The raw exported zip from Google Vertex AI studio.
*   [Reference_Code/AURA-Complete-Documentation-v1.0.zip](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Code/AURA-Complete-Documentation-v1.0.zip) - A comprehensive ZIP archive containing the complete original documentation for the AURA framework.

### /Reference_Materials/
*   [Reference_Materials/generic_file_reading_skill.md](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Materials/generic_file_reading_skill.md) - A generic AI instruction set for processing PDFs and CSVs safely.

### /Reference_Media/
*   [Reference_Media/demo-session-recording.mp4](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Media/demo-session-recording.mp4) - Screen recording of the application flow demonstrating exercises.
*   [Reference_Media/app-screenshot-1.jpeg](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Media/app-screenshot-1.jpeg) - Settings screen screenshot highlighting the caregiver access PIN entry panel (overflow bug fixed).
*   [Reference_Media/app-screenshot-2.jpeg](file:///home/jay/Workspace/Therapy/.alldocs/Reference_Media/app-screenshot-2.jpeg) - Onboarding completion screen screenshot showing final checkmark and navigation bar (overflow bug fixed).
