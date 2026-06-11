// GENERATED CODE - DO NOT MODIFY BY HAND
//
// NOTE: This file was manually crafted for the gemini_live_fork.
// In the original gemini_live package, classes used FieldRename.snake
// which generated snake_case JSON keys. For Vertex AI, all JSON keys
// must be camelCase. This file implements camelCase serialization
// for ALL outgoing AND incoming messages.
//
// Server-only classes (createToJson: false) were already camelCase
// in the original and remain unchanged here.

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ============================================================================
// Part — already camelCase in original (no FieldRename.snake)
// ============================================================================

Part _$PartFromJson(Map<String, dynamic> json) => Part(
  mediaResolution: json['mediaResolution'] == null
      ? null
      : PartMediaResolution.fromJson(
          json['mediaResolution'] as Map<String, dynamic>,
        ),
  text: json['text'] as String?,
  thought: json['thought'] as bool?,
  thoughtSignature: json['thoughtSignature'] as String?,
  inlineData: json['inlineData'] == null
      ? null
      : Blob.fromJson(json['inlineData'] as Map<String, dynamic>),
  fileData: json['fileData'] == null
      ? null
      : FileData.fromJson(json['fileData'] as Map<String, dynamic>),
  videoMetadata: json['videoMetadata'] == null
      ? null
      : VideoMetadata.fromJson(json['videoMetadata'] as Map<String, dynamic>),
  functionCall: json['functionCall'] == null
      ? null
      : FunctionCall.fromJson(json['functionCall'] as Map<String, dynamic>),
  functionResponse: json['functionResponse'] == null
      ? null
      : FunctionResponse.fromJson(
          json['functionResponse'] as Map<String, dynamic>,
        ),
  toolCall: json['toolCall'] == null
      ? null
      : ToolCall.fromJson(json['toolCall'] as Map<String, dynamic>),
  toolResponse: json['toolResponse'] == null
      ? null
      : ToolResponse.fromJson(json['toolResponse'] as Map<String, dynamic>),
  partMetadata: json['partMetadata'] as Map<String, dynamic>?,
  executableCode: json['executableCode'] == null
      ? null
      : ExecutableCode.fromJson(json['executableCode'] as Map<String, dynamic>),
  codeExecutionResult: json['codeExecutionResult'] == null
      ? null
      : CodeExecutionResult.fromJson(
          json['codeExecutionResult'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
  'mediaResolution': ?instance.mediaResolution,
  'text': ?instance.text,
  'thought': ?instance.thought,
  'thoughtSignature': ?instance.thoughtSignature,
  'inlineData': ?instance.inlineData,
  'fileData': ?instance.fileData,
  'videoMetadata': ?instance.videoMetadata,
  'functionCall': ?instance.functionCall,
  'functionResponse': ?instance.functionResponse,
  'toolCall': ?instance.toolCall,
  'toolResponse': ?instance.toolResponse,
  'partMetadata': ?instance.partMetadata,
  'executableCode': ?instance.executableCode,
  'codeExecutionResult': ?instance.codeExecutionResult,
};

// ============================================================================
// Blob — already camelCase in original (no FieldRename.snake)
// ============================================================================

Blob _$BlobFromJson(Map<String, dynamic> json) => Blob(
  mimeType: json['mimeType'] as String,
  data: json['data'] as String,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$BlobToJson(Blob instance) => <String, dynamic>{
  'mimeType': instance.mimeType,
  'data': instance.data,
  'displayName': ?instance.displayName,
};

// ============================================================================
// FileData — WAS snake_case, now camelCase
// ============================================================================

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
  displayName: json['displayName'] as String?,
  fileUri: json['fileUri'] as String?,
  mimeType: json['mimeType'] as String?,
);

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
  'displayName': ?instance.displayName,
  'fileUri': ?instance.fileUri,
  'mimeType': ?instance.mimeType,
};

// ============================================================================
// VideoMetadata — WAS snake_case, now camelCase
// ============================================================================

VideoMetadata _$VideoMetadataFromJson(Map<String, dynamic> json) =>
    VideoMetadata(
      startOffset: json['startOffset'] as String?,
      endOffset: json['endOffset'] as String?,
      fps: (json['fps'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VideoMetadataToJson(VideoMetadata instance) =>
    <String, dynamic>{
      'startOffset': ?instance.startOffset,
      'endOffset': ?instance.endOffset,
      'fps': ?instance.fps,
    };

// ============================================================================
// PartMediaResolution — WAS snake_case (num_tokens), now camelCase
// ============================================================================

PartMediaResolution _$PartMediaResolutionFromJson(Map<String, dynamic> json) =>
    PartMediaResolution(
      level: $enumDecodeNullable(
        _$PartMediaResolutionLevelEnumMap,
        json['level'],
      ),
      numTokens: (json['numTokens'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PartMediaResolutionToJson(
  PartMediaResolution instance,
) => <String, dynamic>{
  'level': ?_$PartMediaResolutionLevelEnumMap[instance.level],
  'numTokens': ?instance.numTokens,
};

const _$PartMediaResolutionLevelEnumMap = {
  PartMediaResolutionLevel.MEDIA_RESOLUTION_UNSPECIFIED:
      'MEDIA_RESOLUTION_UNSPECIFIED',
  PartMediaResolutionLevel.MEDIA_RESOLUTION_LOW: 'MEDIA_RESOLUTION_LOW',
  PartMediaResolutionLevel.MEDIA_RESOLUTION_MEDIUM: 'MEDIA_RESOLUTION_MEDIUM',
  PartMediaResolutionLevel.MEDIA_RESOLUTION_HIGH: 'MEDIA_RESOLUTION_HIGH',
  PartMediaResolutionLevel.MEDIA_RESOLUTION_ULTRA_HIGH:
      'MEDIA_RESOLUTION_ULTRA_HIGH',
};

// ============================================================================
// Content — already camelCase in original
// ============================================================================

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  parts: (json['parts'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList(),
  role: json['role'] as String?,
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'parts': ?instance.parts,
  'role': ?instance.role,
};

// ============================================================================
// PrebuiltVoiceConfig — WAS snake_case (voice_name), now camelCase
// ============================================================================

PrebuiltVoiceConfig _$PrebuiltVoiceConfigFromJson(Map<String, dynamic> json) =>
    PrebuiltVoiceConfig(voiceName: json['voiceName'] as String?);

Map<String, dynamic> _$PrebuiltVoiceConfigToJson(
  PrebuiltVoiceConfig instance,
) => <String, dynamic>{'voiceName': ?instance.voiceName};

// ============================================================================
// VoiceConfig — WAS snake_case, now camelCase
// ============================================================================

VoiceConfig _$VoiceConfigFromJson(Map<String, dynamic> json) => VoiceConfig(
  replicatedVoiceConfig: json['replicatedVoiceConfig'] == null
      ? null
      : ReplicatedVoiceConfig.fromJson(
          json['replicatedVoiceConfig'] as Map<String, dynamic>,
        ),
  prebuiltVoiceConfig: json['prebuiltVoiceConfig'] == null
      ? null
      : PrebuiltVoiceConfig.fromJson(
          json['prebuiltVoiceConfig'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$VoiceConfigToJson(VoiceConfig instance) =>
    <String, dynamic>{
      'replicatedVoiceConfig': ?instance.replicatedVoiceConfig,
      'prebuiltVoiceConfig': ?instance.prebuiltVoiceConfig,
    };

// ============================================================================
// ReplicatedVoiceConfig — WAS snake_case, now camelCase
// ============================================================================

ReplicatedVoiceConfig _$ReplicatedVoiceConfigFromJson(
  Map<String, dynamic> json,
) => ReplicatedVoiceConfig(
  mimeType: json['mimeType'] as String?,
  voiceSampleAudio: json['voiceSampleAudio'] as String?,
);

Map<String, dynamic> _$ReplicatedVoiceConfigToJson(
  ReplicatedVoiceConfig instance,
) => <String, dynamic>{
  'mimeType': ?instance.mimeType,
  'voiceSampleAudio': ?instance.voiceSampleAudio,
};

// ============================================================================
// SpeakerVoiceConfig — WAS snake_case (voice_config), now camelCase
// ============================================================================

SpeakerVoiceConfig _$SpeakerVoiceConfigFromJson(Map<String, dynamic> json) =>
    SpeakerVoiceConfig(
      speaker: json['speaker'] as String?,
      voiceConfig: json['voiceConfig'] == null
          ? null
          : VoiceConfig.fromJson(json['voiceConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpeakerVoiceConfigToJson(SpeakerVoiceConfig instance) =>
    <String, dynamic>{
      'speaker': ?instance.speaker,
      'voiceConfig': ?instance.voiceConfig,
    };

// ============================================================================
// MultiSpeakerVoiceConfig — WAS snake_case, now camelCase
// ============================================================================

MultiSpeakerVoiceConfig _$MultiSpeakerVoiceConfigFromJson(
  Map<String, dynamic> json,
) => MultiSpeakerVoiceConfig(
  speakerVoiceConfigs: (json['speakerVoiceConfigs'] as List<dynamic>?)
      ?.map((e) => SpeakerVoiceConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MultiSpeakerVoiceConfigToJson(
  MultiSpeakerVoiceConfig instance,
) => <String, dynamic>{'speakerVoiceConfigs': ?instance.speakerVoiceConfigs};

// ============================================================================
// SpeechConfig — WAS snake_case, now camelCase
// ============================================================================

SpeechConfig _$SpeechConfigFromJson(Map<String, dynamic> json) => SpeechConfig(
  voiceConfig: json['voiceConfig'] == null
      ? null
      : VoiceConfig.fromJson(json['voiceConfig'] as Map<String, dynamic>),
  languageCode: json['languageCode'] as String?,
  multiSpeakerVoiceConfig: json['multiSpeakerVoiceConfig'] == null
      ? null
      : MultiSpeakerVoiceConfig.fromJson(
          json['multiSpeakerVoiceConfig'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SpeechConfigToJson(SpeechConfig instance) =>
    <String, dynamic>{
      'voiceConfig': ?instance.voiceConfig,
      'languageCode': ?instance.languageCode,
      'multiSpeakerVoiceConfig': ?instance.multiSpeakerVoiceConfig,
    };

// ============================================================================
// ThinkingConfig — WAS snake_case, now camelCase
// ============================================================================

ThinkingConfig _$ThinkingConfigFromJson(Map<String, dynamic> json) =>
    ThinkingConfig(
      includeThoughts: json['includeThoughts'] as bool?,
      thinkingBudget: (json['thinkingBudget'] as num?)?.toInt(),
      thinkingLevel: $enumDecodeNullable(
        _$ThinkingLevelEnumMap,
        json['thinkingLevel'],
      ),
    );

Map<String, dynamic> _$ThinkingConfigToJson(ThinkingConfig instance) =>
    <String, dynamic>{
      'includeThoughts': ?instance.includeThoughts,
      'thinkingBudget': ?instance.thinkingBudget,
      'thinkingLevel': ?_$ThinkingLevelEnumMap[instance.thinkingLevel],
    };

const _$ThinkingLevelEnumMap = {
  ThinkingLevel.THINKING_LEVEL_UNSPECIFIED: 'THINKING_LEVEL_UNSPECIFIED',
  ThinkingLevel.MINIMAL: 'MINIMAL',
  ThinkingLevel.LOW: 'LOW',
  ThinkingLevel.MEDIUM: 'MEDIUM',
  ThinkingLevel.HIGH: 'HIGH',
};

// ============================================================================
// StreamTranslationConfig — WAS snake_case, now camelCase
// ============================================================================

StreamTranslationConfig _$StreamTranslationConfigFromJson(
  Map<String, dynamic> json,
) => StreamTranslationConfig(
  echoTargetLanguage: json['echoTargetLanguage'] as bool?,
  targetLanguageCode: json['targetLanguageCode'] as String?,
);

Map<String, dynamic> _$StreamTranslationConfigToJson(
  StreamTranslationConfig instance,
) => <String, dynamic>{
  'echoTargetLanguage': ?instance.echoTargetLanguage,
  'targetLanguageCode': ?instance.targetLanguageCode,
};

// ============================================================================
// GenerationConfig — WAS snake_case, now camelCase
// ============================================================================

GenerationConfig _$GenerationConfigFromJson(Map<String, dynamic> json) =>
    GenerationConfig(
      temperature: (json['temperature'] as num?)?.toDouble(),
      topK: (json['topK'] as num?)?.toInt(),
      topP: (json['topP'] as num?)?.toDouble(),
      maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt(),
      responseModalities: (json['responseModalities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ModalityEnumMap, e))
          .toList(),
      mediaResolution: $enumDecodeNullable(
        _$MediaResolutionEnumMap,
        json['mediaResolution'],
      ),
      seed: (json['seed'] as num?)?.toInt(),
      speechConfig: json['speechConfig'] == null
          ? null
          : SpeechConfig.fromJson(
              json['speechConfig'] as Map<String, dynamic>,
            ),
      thinkingConfig: json['thinkingConfig'] == null
          ? null
          : ThinkingConfig.fromJson(
              json['thinkingConfig'] as Map<String, dynamic>,
            ),
      enableAffectiveDialog: json['enableAffectiveDialog'] as bool?,
      streamTranslationConfig: json['streamTranslationConfig'] == null
          ? null
          : StreamTranslationConfig.fromJson(
              json['streamTranslationConfig'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$GenerationConfigToJson(GenerationConfig instance) =>
    <String, dynamic>{
      'temperature': ?instance.temperature,
      'topK': ?instance.topK,
      'topP': ?instance.topP,
      'maxOutputTokens': ?instance.maxOutputTokens,
      'responseModalities': ?instance.responseModalities
          ?.map((e) => _$ModalityEnumMap[e]!)
          .toList(),
      'mediaResolution': ?_$MediaResolutionEnumMap[instance.mediaResolution],
      'seed': ?instance.seed,
      'speechConfig': ?instance.speechConfig,
      'thinkingConfig': ?instance.thinkingConfig,
      'enableAffectiveDialog': ?instance.enableAffectiveDialog,
      'streamTranslationConfig': ?instance.streamTranslationConfig,
    };

const _$ModalityEnumMap = {
  Modality.MODALITY_UNSPECIFIED: 'MODALITY_UNSPECIFIED',
  Modality.TEXT: 'TEXT',
  Modality.IMAGE: 'IMAGE',
  Modality.AUDIO: 'AUDIO',
  Modality.VIDEO: 'VIDEO',
};

const _$MediaResolutionEnumMap = {
  MediaResolution.MEDIA_RESOLUTION_UNSPECIFIED: 'MEDIA_RESOLUTION_UNSPECIFIED',
  MediaResolution.MEDIA_RESOLUTION_LOW: 'MEDIA_RESOLUTION_LOW',
  MediaResolution.MEDIA_RESOLUTION_MEDIUM: 'MEDIA_RESOLUTION_MEDIUM',
  MediaResolution.MEDIA_RESOLUTION_HIGH: 'MEDIA_RESOLUTION_HIGH',
};

// ============================================================================
// PartialArg — WAS snake_case, now camelCase
// ============================================================================

PartialArg _$PartialArgFromJson(Map<String, dynamic> json) => PartialArg(
  boolValue: json['boolValue'] as bool?,
  jsonPath: json['jsonPath'] as String?,
  nullValue: json['nullValue'] as String?,
  numberValue: (json['numberValue'] as num?)?.toDouble(),
  stringValue: json['stringValue'] as String?,
  willContinue: json['willContinue'] as bool?,
);

Map<String, dynamic> _$PartialArgToJson(PartialArg instance) =>
    <String, dynamic>{
      'boolValue': ?instance.boolValue,
      'jsonPath': ?instance.jsonPath,
      'nullValue': ?instance.nullValue,
      'numberValue': ?instance.numberValue,
      'stringValue': ?instance.stringValue,
      'willContinue': ?instance.willContinue,
    };

// ============================================================================
// FunctionCall — WAS snake_case (partial_args, will_continue), now camelCase
// ============================================================================

FunctionCall _$FunctionCallFromJson(Map<String, dynamic> json) => FunctionCall(
  id: json['id'] as String?,
  name: json['name'] as String?,
  args: json['args'] as Map<String, dynamic>?,
  partialArgs: (json['partialArgs'] as List<dynamic>?)
      ?.map((e) => PartialArg.fromJson(e as Map<String, dynamic>))
      .toList(),
  willContinue: json['willContinue'] as bool?,
);

Map<String, dynamic> _$FunctionCallToJson(FunctionCall instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'args': ?instance.args,
      'partialArgs': ?instance.partialArgs,
      'willContinue': ?instance.willContinue,
    };

// ============================================================================
// ToolCall — WAS snake_case (tool_type), now camelCase
// ============================================================================

ToolCall _$ToolCallFromJson(Map<String, dynamic> json) => ToolCall(
  id: json['id'] as String?,
  toolType: $enumDecodeNullable(_$ToolTypeEnumMap, json['toolType']),
  args: json['args'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ToolCallToJson(ToolCall instance) => <String, dynamic>{
  'id': ?instance.id,
  'toolType': ?_$ToolTypeEnumMap[instance.toolType],
  'args': ?instance.args,
};

const _$ToolTypeEnumMap = {
  ToolType.TOOL_TYPE_UNSPECIFIED: 'TOOL_TYPE_UNSPECIFIED',
  ToolType.GOOGLE_SEARCH_WEB: 'GOOGLE_SEARCH_WEB',
  ToolType.GOOGLE_SEARCH_IMAGE: 'GOOGLE_SEARCH_IMAGE',
  ToolType.URL_CONTEXT: 'URL_CONTEXT',
  ToolType.GOOGLE_MAPS: 'GOOGLE_MAPS',
  ToolType.FILE_SEARCH: 'FILE_SEARCH',
};

// ============================================================================
// ToolResponse — WAS snake_case (tool_type), now camelCase
// ============================================================================

ToolResponse _$ToolResponseFromJson(Map<String, dynamic> json) => ToolResponse(
  id: json['id'] as String?,
  toolType: $enumDecodeNullable(_$ToolTypeEnumMap, json['toolType']),
  response: json['response'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ToolResponseToJson(ToolResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'toolType': ?_$ToolTypeEnumMap[instance.toolType],
      'response': ?instance.response,
    };

// ============================================================================
// FunctionResponseBlob — WAS snake_case, now camelCase
// ============================================================================

FunctionResponseBlob _$FunctionResponseBlobFromJson(
  Map<String, dynamic> json,
) => FunctionResponseBlob(
  mimeType: json['mimeType'] as String?,
  data: json['data'] as String?,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$FunctionResponseBlobToJson(
  FunctionResponseBlob instance,
) => <String, dynamic>{
  'mimeType': ?instance.mimeType,
  'data': ?instance.data,
  'displayName': ?instance.displayName,
};

// ============================================================================
// FunctionResponseFileData — WAS snake_case, now camelCase
// ============================================================================

FunctionResponseFileData _$FunctionResponseFileDataFromJson(
  Map<String, dynamic> json,
) => FunctionResponseFileData(
  fileUri: json['fileUri'] as String?,
  mimeType: json['mimeType'] as String?,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$FunctionResponseFileDataToJson(
  FunctionResponseFileData instance,
) => <String, dynamic>{
  'fileUri': ?instance.fileUri,
  'mimeType': ?instance.mimeType,
  'displayName': ?instance.displayName,
};

// ============================================================================
// FunctionResponsePart — WAS snake_case (inline_data, file_data), now camelCase
// ============================================================================

FunctionResponsePart _$FunctionResponsePartFromJson(
  Map<String, dynamic> json,
) => FunctionResponsePart(
  inlineData: json['inlineData'] == null
      ? null
      : FunctionResponseBlob.fromJson(
          json['inlineData'] as Map<String, dynamic>,
        ),
  fileData: json['fileData'] == null
      ? null
      : FunctionResponseFileData.fromJson(
          json['fileData'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FunctionResponsePartToJson(
  FunctionResponsePart instance,
) => <String, dynamic>{
  'inlineData': ?instance.inlineData,
  'fileData': ?instance.fileData,
};

// ============================================================================
// FunctionResponse — WAS snake_case (will_continue), now camelCase
// ============================================================================

FunctionResponse _$FunctionResponseFromJson(Map<String, dynamic> json) =>
    FunctionResponse(
      id: json['id'] as String?,
      name: json['name'] as String?,
      response: json['response'] as Map<String, dynamic>?,
      willContinue: json['willContinue'] as bool?,
      scheduling: $enumDecodeNullable(
        _$FunctionResponseSchedulingEnumMap,
        json['scheduling'],
      ),
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => FunctionResponsePart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FunctionResponseToJson(FunctionResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'response': ?instance.response,
      'willContinue': ?instance.willContinue,
      'scheduling': ?_$FunctionResponseSchedulingEnumMap[instance.scheduling],
      'parts': ?instance.parts,
    };

const _$FunctionResponseSchedulingEnumMap = {
  FunctionResponseScheduling.SCHEDULING_UNSPECIFIED: 'SCHEDULING_UNSPECIFIED',
  FunctionResponseScheduling.SILENT: 'SILENT',
  FunctionResponseScheduling.WHEN_IDLE: 'WHEN_IDLE',
  FunctionResponseScheduling.INTERRUPT: 'INTERRUPT',
};

// ============================================================================
// FunctionDeclaration — WAS snake_case (parameters_json_schema, response_json_schema), now camelCase
// ============================================================================

FunctionDeclaration _$FunctionDeclarationFromJson(Map<String, dynamic> json) =>
    FunctionDeclaration(
      description: json['description'] as String?,
      name: json['name'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
      parametersJsonSchema: json['parametersJsonSchema'],
      response: json['response'] as Map<String, dynamic>?,
      responseJsonSchema: json['responseJsonSchema'],
      behavior: $enumDecodeNullable(_$BehaviorEnumMap, json['behavior']),
    );

Map<String, dynamic> _$FunctionDeclarationToJson(
  FunctionDeclaration instance,
) => <String, dynamic>{
  'description': ?instance.description,
  'name': ?instance.name,
  'parameters': ?instance.parameters,
  'parametersJsonSchema': ?instance.parametersJsonSchema,
  'response': ?instance.response,
  'responseJsonSchema': ?instance.responseJsonSchema,
  'behavior': ?_$BehaviorEnumMap[instance.behavior],
};

const _$BehaviorEnumMap = {
  Behavior.UNSPECIFIED: 'UNSPECIFIED',
  Behavior.BLOCKING: 'BLOCKING',
  Behavior.NON_BLOCKING: 'NON_BLOCKING',
};

// ============================================================================
// Interval — WAS snake_case (start_time, end_time), now camelCase
// ============================================================================

Interval _$IntervalFromJson(Map<String, dynamic> json) => Interval(
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
);

Map<String, dynamic> _$IntervalToJson(Interval instance) => <String, dynamic>{
  'startTime': ?instance.startTime?.toIso8601String(),
  'endTime': ?instance.endTime?.toIso8601String(),
};

// ============================================================================
// GoogleSearch — WAS snake_case, now camelCase
// ============================================================================

GoogleSearch _$GoogleSearchFromJson(Map<String, dynamic> json) => GoogleSearch(
  excludeDomains: (json['excludeDomains'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  timeRangeFilter: json['timeRangeFilter'] == null
      ? null
      : Interval.fromJson(json['timeRangeFilter'] as Map<String, dynamic>),
  blockingConfidence: json['blockingConfidence'] as String?,
);

Map<String, dynamic> _$GoogleSearchToJson(GoogleSearch instance) =>
    <String, dynamic>{
      'excludeDomains': ?instance.excludeDomains,
      'timeRangeFilter': ?instance.timeRangeFilter,
      'blockingConfidence': ?instance.blockingConfidence,
    };

// ============================================================================
// DynamicRetrievalConfig — WAS snake_case (dynamic_threshold), now camelCase
// ============================================================================

DynamicRetrievalConfig _$DynamicRetrievalConfigFromJson(
  Map<String, dynamic> json,
) => DynamicRetrievalConfig(
  dynamicThreshold: (json['dynamicThreshold'] as num?)?.toDouble(),
  mode: json['mode'] as String?,
);

Map<String, dynamic> _$DynamicRetrievalConfigToJson(
  DynamicRetrievalConfig instance,
) => <String, dynamic>{
  'dynamicThreshold': ?instance.dynamicThreshold,
  'mode': ?instance.mode,
};

// ============================================================================
// GoogleSearchRetrieval — WAS snake_case, now camelCase
// ============================================================================

GoogleSearchRetrieval _$GoogleSearchRetrievalFromJson(
  Map<String, dynamic> json,
) => GoogleSearchRetrieval(
  dynamicRetrievalConfig: json['dynamicRetrievalConfig'] == null
      ? null
      : DynamicRetrievalConfig.fromJson(
          json['dynamicRetrievalConfig'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GoogleSearchRetrievalToJson(
  GoogleSearchRetrieval instance,
) => <String, dynamic>{
  'dynamicRetrievalConfig': ?instance.dynamicRetrievalConfig,
};

// ============================================================================
// Tool — WAS snake_case, now camelCase
// ============================================================================

Tool _$ToolFromJson(Map<String, dynamic> json) => Tool(
  functionDeclarations: (json['functionDeclarations'] as List<dynamic>?)
      ?.map((e) => FunctionDeclaration.fromJson(e as Map<String, dynamic>))
      .toList(),
  googleSearch: json['googleSearch'] == null
      ? null
      : GoogleSearch.fromJson(json['googleSearch'] as Map<String, dynamic>),
  googleSearchRetrieval: json['googleSearchRetrieval'] == null
      ? null
      : GoogleSearchRetrieval.fromJson(
          json['googleSearchRetrieval'] as Map<String, dynamic>,
        ),
  codeExecution: json['codeExecution'] as Map<String, dynamic>?,
  urlContext: json['urlContext'] as Map<String, dynamic>?,
  googleMaps: json['googleMaps'] as Map<String, dynamic>?,
  retrieval: json['retrieval'] as Map<String, dynamic>?,
  computerUse: _computerUseFromJson(json['computerUse']),
  fileSearch: json['fileSearch'] as Map<String, dynamic>?,
  enterpriseWebSearch: json['enterpriseWebSearch'] as Map<String, dynamic>?,
  mcpServers: (json['mcpServers'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$ToolToJson(Tool instance) => <String, dynamic>{
  'functionDeclarations': ?instance.functionDeclarations,
  'googleSearch': ?instance.googleSearch,
  'googleSearchRetrieval': ?instance.googleSearchRetrieval,
  'codeExecution': ?instance.codeExecution,
  'urlContext': ?instance.urlContext,
  'googleMaps': ?instance.googleMaps,
  'retrieval': ?instance.retrieval,
  'computerUse': ?_computerUseToJson(instance.computerUse),
  'fileSearch': ?instance.fileSearch,
  'enterpriseWebSearch': ?instance.enterpriseWebSearch,
  'mcpServers': ?instance.mcpServers,
};

// ============================================================================
// ComputerUse — WAS snake_case, now camelCase
// ============================================================================

ComputerUse _$ComputerUseFromJson(Map<String, dynamic> json) => ComputerUse(
  environment: $enumDecodeNullable(_$EnvironmentEnumMap, json['environment']),
  excludedPredefinedFunctions:
      (json['excludedPredefinedFunctions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  enablePromptInjectionDetection:
      json['enablePromptInjectionDetection'] as bool?,
);

Map<String, dynamic> _$ComputerUseToJson(
  ComputerUse instance,
) => <String, dynamic>{
  'environment': ?_$EnvironmentEnumMap[instance.environment],
  'excludedPredefinedFunctions': ?instance.excludedPredefinedFunctions,
  'enablePromptInjectionDetection': ?instance.enablePromptInjectionDetection,
};

const _$EnvironmentEnumMap = {
  Environment.ENVIRONMENT_UNSPECIFIED: 'ENVIRONMENT_UNSPECIFIED',
  Environment.ENVIRONMENT_BROWSER: 'ENVIRONMENT_BROWSER',
  Environment.ENVIRONMENT_MOBILE: 'ENVIRONMENT_MOBILE',
  Environment.ENVIRONMENT_DESKTOP: 'ENVIRONMENT_DESKTOP',
};

// ============================================================================
// AutomaticActivityDetection — WAS snake_case, now camelCase
// ============================================================================

AutomaticActivityDetection _$AutomaticActivityDetectionFromJson(
  Map<String, dynamic> json,
) => AutomaticActivityDetection(
  disabled: json['disabled'] as bool?,
  startOfSpeechSensitivity: $enumDecodeNullable(
    _$StartSensitivityEnumMap,
    json['startOfSpeechSensitivity'],
  ),
  endOfSpeechSensitivity: $enumDecodeNullable(
    _$EndSensitivityEnumMap,
    json['endOfSpeechSensitivity'],
  ),
  prefixPaddingMs: (json['prefixPaddingMs'] as num?)?.toInt(),
  silenceDurationMs: (json['silenceDurationMs'] as num?)?.toInt(),
);

Map<String, dynamic> _$AutomaticActivityDetectionToJson(
  AutomaticActivityDetection instance,
) => <String, dynamic>{
  'disabled': ?instance.disabled,
  'startOfSpeechSensitivity':
      ?_$StartSensitivityEnumMap[instance.startOfSpeechSensitivity],
  'endOfSpeechSensitivity':
      ?_$EndSensitivityEnumMap[instance.endOfSpeechSensitivity],
  'prefixPaddingMs': ?instance.prefixPaddingMs,
  'silenceDurationMs': ?instance.silenceDurationMs,
};

const _$StartSensitivityEnumMap = {
  StartSensitivity.START_SENSITIVITY_UNSPECIFIED:
      'START_SENSITIVITY_UNSPECIFIED',
  StartSensitivity.START_SENSITIVITY_LOW: 'START_SENSITIVITY_LOW',
  StartSensitivity.START_SENSITIVITY_HIGH: 'START_SENSITIVITY_HIGH',
};

const _$EndSensitivityEnumMap = {
  EndSensitivity.END_SENSITIVITY_UNSPECIFIED: 'END_SENSITIVITY_UNSPECIFIED',
  EndSensitivity.END_SENSITIVITY_LOW: 'END_SENSITIVITY_LOW',
  EndSensitivity.END_SENSITIVITY_HIGH: 'END_SENSITIVITY_HIGH',
};

// ============================================================================
// RealtimeInputConfig — WAS snake_case, now camelCase
// ============================================================================

RealtimeInputConfig _$RealtimeInputConfigFromJson(Map<String, dynamic> json) =>
    RealtimeInputConfig(
      automaticActivityDetection: json['automaticActivityDetection'] == null
          ? null
          : AutomaticActivityDetection.fromJson(
              json['automaticActivityDetection'] as Map<String, dynamic>,
            ),
      activityHandling: $enumDecodeNullable(
        _$ActivityHandlingEnumMap,
        json['activityHandling'],
      ),
      turnCoverage: $enumDecodeNullable(
        _$TurnCoverageEnumMap,
        json['turnCoverage'],
      ),
    );

Map<String, dynamic> _$RealtimeInputConfigToJson(
  RealtimeInputConfig instance,
) => <String, dynamic>{
  'automaticActivityDetection': ?instance.automaticActivityDetection,
  'activityHandling': ?_$ActivityHandlingEnumMap[instance.activityHandling],
  'turnCoverage': ?_$TurnCoverageEnumMap[instance.turnCoverage],
};

const _$ActivityHandlingEnumMap = {
  ActivityHandling.ACTIVITY_HANDLING_UNSPECIFIED:
      'ACTIVITY_HANDLING_UNSPECIFIED',
  ActivityHandling.START_OF_ACTIVITY_INTERRUPTS: 'START_OF_ACTIVITY_INTERRUPTS',
  ActivityHandling.NO_INTERRUPTION: 'NO_INTERRUPTION',
  ActivityHandling.START_OF_ACTIVITY_DOES_NOT_INTERRUPT: 'NO_INTERRUPTION',
};

const _$TurnCoverageEnumMap = {
  TurnCoverage.TURN_COVERAGE_UNSPECIFIED: 'TURN_COVERAGE_UNSPECIFIED',
  TurnCoverage.TURN_INCLUDES_ONLY_ACTIVITY: 'TURN_INCLUDES_ONLY_ACTIVITY',
  TurnCoverage.TURN_INCLUDES_ALL_INPUT: 'TURN_INCLUDES_ALL_INPUT',
  TurnCoverage.TURN_INCLUDES_AUDIO_ACTIVITY_AND_ALL_VIDEO:
      'TURN_INCLUDES_AUDIO_ACTIVITY_AND_ALL_VIDEO',
};

// ============================================================================
// SessionResumptionConfig — WAS snake_case (transparent), now camelCase
// ============================================================================

SessionResumptionConfig _$SessionResumptionConfigFromJson(
  Map<String, dynamic> json,
) => SessionResumptionConfig(
  handle: json['handle'] as String?,
  transparent: json['transparent'] as bool?,
);

Map<String, dynamic> _$SessionResumptionConfigToJson(
  SessionResumptionConfig instance,
) => <String, dynamic>{
  'handle': ?instance.handle,
  'transparent': ?instance.transparent,
};

// ============================================================================
// SlidingWindow — WAS snake_case (target_tokens), now camelCase
// ============================================================================

SlidingWindow _$SlidingWindowFromJson(Map<String, dynamic> json) =>
    SlidingWindow(targetTokens: json['targetTokens'] as String?);

Map<String, dynamic> _$SlidingWindowToJson(SlidingWindow instance) =>
    <String, dynamic>{'targetTokens': ?instance.targetTokens};

// ============================================================================
// ContextWindowCompressionConfig — WAS snake_case, now camelCase
// ============================================================================

ContextWindowCompressionConfig _$ContextWindowCompressionConfigFromJson(
  Map<String, dynamic> json,
) => ContextWindowCompressionConfig(
  triggerTokens: json['triggerTokens'] as String?,
  slidingWindow: json['slidingWindow'] == null
      ? null
      : SlidingWindow.fromJson(json['slidingWindow'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContextWindowCompressionConfigToJson(
  ContextWindowCompressionConfig instance,
) => <String, dynamic>{
  'triggerTokens': ?instance.triggerTokens,
  'slidingWindow': ?instance.slidingWindow,
};

// ============================================================================
// AudioTranscriptionConfig — WAS snake_case (language_codes), now camelCase
// ============================================================================

AudioTranscriptionConfig _$AudioTranscriptionConfigFromJson(
  Map<String, dynamic> json,
) => AudioTranscriptionConfig(
  languageCodes: (json['languageCodes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AudioTranscriptionConfigToJson(
  AudioTranscriptionConfig instance,
) => <String, dynamic>{'languageCodes': ?instance.languageCodes};

// ============================================================================
// ProactivityConfig — WAS snake_case (proactive_audio), now camelCase
// ============================================================================

ProactivityConfig _$ProactivityConfigFromJson(Map<String, dynamic> json) =>
    ProactivityConfig(proactiveAudio: json['proactiveAudio'] as bool?);

Map<String, dynamic> _$ProactivityConfigToJson(ProactivityConfig instance) =>
    <String, dynamic>{'proactiveAudio': ?instance.proactiveAudio};

// ============================================================================
// SafetySetting — WAS snake_case (category, method, threshold — already single-word),
// but also fromJson enums. Keep camelCase where applicable.
// ============================================================================

SafetySetting _$SafetySettingFromJson(Map<String, dynamic> json) =>
    SafetySetting(
      category: $enumDecodeNullable(_$HarmCategoryEnumMap, json['category']),
      method: $enumDecodeNullable(_$HarmBlockMethodEnumMap, json['method']),
      threshold: $enumDecodeNullable(
        _$HarmBlockThresholdEnumMap,
        json['threshold'],
      ),
    );

Map<String, dynamic> _$SafetySettingToJson(SafetySetting instance) =>
    <String, dynamic>{
      'category': ?_$HarmCategoryEnumMap[instance.category],
      'method': ?_$HarmBlockMethodEnumMap[instance.method],
      'threshold': ?_$HarmBlockThresholdEnumMap[instance.threshold],
    };

const _$HarmCategoryEnumMap = {
  HarmCategory.HARM_CATEGORY_UNSPECIFIED: 'HARM_CATEGORY_UNSPECIFIED',
  HarmCategory.HARM_CATEGORY_HATE_SPEECH: 'HARM_CATEGORY_HATE_SPEECH',
  HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT:
      'HARM_CATEGORY_DANGEROUS_CONTENT',
  HarmCategory.HARM_CATEGORY_HARASSMENT: 'HARM_CATEGORY_HARASSMENT',
  HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT:
      'HARM_CATEGORY_SEXUALLY_EXPLICIT',
  HarmCategory.HARM_CATEGORY_CIVIC_INTEGRITY: 'HARM_CATEGORY_CIVIC_INTEGRITY',
  HarmCategory.HARM_CATEGORY_IMAGE_HATE: 'HARM_CATEGORY_IMAGE_HATE',
  HarmCategory.HARM_CATEGORY_IMAGE_DANGEROUS_CONTENT:
      'HARM_CATEGORY_IMAGE_DANGEROUS_CONTENT',
  HarmCategory.HARM_CATEGORY_IMAGE_HARASSMENT: 'HARM_CATEGORY_IMAGE_HARASSMENT',
  HarmCategory.HARM_CATEGORY_IMAGE_SEXUALLY_EXPLICIT:
      'HARM_CATEGORY_IMAGE_SEXUALLY_EXPLICIT',
  HarmCategory.HARM_CATEGORY_JAILBREAK: 'HARM_CATEGORY_JAILBREAK',
};

const _$HarmBlockMethodEnumMap = {
  HarmBlockMethod.HARM_BLOCK_METHOD_UNSPECIFIED:
      'HARM_BLOCK_METHOD_UNSPECIFIED',
  HarmBlockMethod.SEVERITY: 'SEVERITY',
  HarmBlockMethod.PROBABILITY: 'PROBABILITY',
};

const _$HarmBlockThresholdEnumMap = {
  HarmBlockThreshold.HARM_BLOCK_THRESHOLD_UNSPECIFIED:
      'HARM_BLOCK_THRESHOLD_UNSPECIFIED',
  HarmBlockThreshold.BLOCK_LOW_AND_ABOVE: 'BLOCK_LOW_AND_ABOVE',
  HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE: 'BLOCK_MEDIUM_AND_ABOVE',
  HarmBlockThreshold.BLOCK_ONLY_HIGH: 'BLOCK_ONLY_HIGH',
  HarmBlockThreshold.BLOCK_NONE: 'BLOCK_NONE',
  HarmBlockThreshold.OFF: 'OFF',
};

// ============================================================================
// CustomizedAvatar — WAS snake_case, now camelCase
// ============================================================================

CustomizedAvatar _$CustomizedAvatarFromJson(Map<String, dynamic> json) =>
    CustomizedAvatar(
      imageMimeType: json['imageMimeType'] as String?,
      imageData: json['imageData'] as String?,
    );

Map<String, dynamic> _$CustomizedAvatarToJson(CustomizedAvatar instance) =>
    <String, dynamic>{
      'imageMimeType': ?instance.imageMimeType,
      'imageData': ?instance.imageData,
    };

// ============================================================================
// AvatarConfig — WAS snake_case, now camelCase
// ============================================================================

AvatarConfig _$AvatarConfigFromJson(Map<String, dynamic> json) => AvatarConfig(
  avatarName: json['avatarName'] as String?,
  customizedAvatar: json['customizedAvatar'] == null
      ? null
      : CustomizedAvatar.fromJson(
          json['customizedAvatar'] as Map<String, dynamic>,
        ),
  audioBitrateBps: (json['audioBitrateBps'] as num?)?.toInt(),
  videoBitrateBps: (json['videoBitrateBps'] as num?)?.toInt(),
);

Map<String, dynamic> _$AvatarConfigToJson(AvatarConfig instance) =>
    <String, dynamic>{
      'avatarName': ?instance.avatarName,
      'customizedAvatar': ?instance.customizedAvatar,
      'audioBitrateBps': ?instance.audioBitrateBps,
      'videoBitrateBps': ?instance.videoBitrateBps,
    };

// ============================================================================
// LiveClientSetup — WAS snake_case, now camelCase
// ============================================================================

LiveClientSetup _$LiveClientSetupFromJson(
  Map<String, dynamic> json,
) => LiveClientSetup(
  model: json['model'] as String,
  generationConfig: json['generationConfig'] == null
      ? null
      : GenerationConfig.fromJson(
          json['generationConfig'] as Map<String, dynamic>,
        ),
  systemInstruction: json['systemInstruction'] == null
      ? null
      : Content.fromJson(json['systemInstruction'] as Map<String, dynamic>),
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => Tool.fromJson(e as Map<String, dynamic>))
      .toList(),
  realtimeInputConfig: json['realtimeInputConfig'] == null
      ? null
      : RealtimeInputConfig.fromJson(
          json['realtimeInputConfig'] as Map<String, dynamic>,
        ),
  sessionResumption: json['sessionResumption'] == null
      ? null
      : SessionResumptionConfig.fromJson(
          json['sessionResumption'] as Map<String, dynamic>,
        ),
  contextWindowCompression: json['contextWindowCompression'] == null
      ? null
      : ContextWindowCompressionConfig.fromJson(
          json['contextWindowCompression'] as Map<String, dynamic>,
        ),
  inputAudioTranscription: json['inputAudioTranscription'] == null
      ? null
      : AudioTranscriptionConfig.fromJson(
          json['inputAudioTranscription'] as Map<String, dynamic>,
        ),
  outputAudioTranscription: json['outputAudioTranscription'] == null
      ? null
      : AudioTranscriptionConfig.fromJson(
          json['outputAudioTranscription'] as Map<String, dynamic>,
        ),
  proactivity: json['proactivity'] == null
      ? null
      : ProactivityConfig.fromJson(json['proactivity'] as Map<String, dynamic>),
  explicitVadSignal: json['explicitVadSignal'] as bool?,
  avatarConfig: json['avatarConfig'] == null
      ? null
      : AvatarConfig.fromJson(json['avatarConfig'] as Map<String, dynamic>),
  safetySettings: (json['safetySettings'] as List<dynamic>?)
      ?.map((e) => SafetySetting.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LiveClientSetupToJson(LiveClientSetup instance) =>
    <String, dynamic>{
      'model': instance.model,
      'generationConfig': ?instance.generationConfig,
      'systemInstruction': ?instance.systemInstruction,
      'tools': ?instance.tools,
      'realtimeInputConfig': ?instance.realtimeInputConfig,
      'sessionResumption': ?instance.sessionResumption,
      'contextWindowCompression': ?instance.contextWindowCompression,
      'inputAudioTranscription': ?instance.inputAudioTranscription,
      'outputAudioTranscription': ?instance.outputAudioTranscription,
      'proactivity': ?instance.proactivity,
      'explicitVadSignal': ?instance.explicitVadSignal,
      'avatarConfig': ?instance.avatarConfig,
      'safetySettings': ?instance.safetySettings,
    };

// ============================================================================
// LiveClientContent — WAS snake_case (turn_complete), now camelCase
// ============================================================================

LiveClientContent _$LiveClientContentFromJson(Map<String, dynamic> json) =>
    LiveClientContent(
      turns: (json['turns'] as List<dynamic>?)
          ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      turnComplete: json['turnComplete'] as bool?,
    );

Map<String, dynamic> _$LiveClientContentToJson(LiveClientContent instance) =>
    <String, dynamic>{
      'turns': ?instance.turns,
      'turnComplete': ?instance.turnComplete,
    };

// ============================================================================
// ActivityStart — no fields, unchanged
// ============================================================================

ActivityStart _$ActivityStartFromJson(Map<String, dynamic> json) =>
    ActivityStart();

Map<String, dynamic> _$ActivityStartToJson(ActivityStart instance) =>
    <String, dynamic>{};

// ============================================================================
// ActivityEnd — no fields, unchanged
// ============================================================================

ActivityEnd _$ActivityEndFromJson(Map<String, dynamic> json) => ActivityEnd();

Map<String, dynamic> _$ActivityEndToJson(ActivityEnd instance) =>
    <String, dynamic>{};

// ============================================================================
// LiveClientRealtimeInput — WAS snake_case, now camelCase
// ============================================================================

LiveClientRealtimeInput _$LiveClientRealtimeInputFromJson(
  Map<String, dynamic> json,
) => LiveClientRealtimeInput(
  mediaChunks: (json['mediaChunks'] as List<dynamic>?)
      ?.map((e) => Blob.fromJson(e as Map<String, dynamic>))
      .toList(),
  audio: json['audio'] == null
      ? null
      : Blob.fromJson(json['audio'] as Map<String, dynamic>),
  video: json['video'] == null
      ? null
      : Blob.fromJson(json['video'] as Map<String, dynamic>),
  audioStreamEnd: json['audioStreamEnd'] as bool?,
  text: json['text'] as String?,
  activityStart: json['activityStart'] == null
      ? null
      : ActivityStart.fromJson(json['activityStart'] as Map<String, dynamic>),
  activityEnd: json['activityEnd'] == null
      ? null
      : ActivityEnd.fromJson(json['activityEnd'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveClientRealtimeInputToJson(
  LiveClientRealtimeInput instance,
) => <String, dynamic>{
  'mediaChunks': ?instance.mediaChunks,
  'audio': ?instance.audio,
  'video': ?instance.video,
  'audioStreamEnd': ?instance.audioStreamEnd,
  'text': ?instance.text,
  'activityStart': ?instance.activityStart,
  'activityEnd': ?instance.activityEnd,
};

// ============================================================================
// LiveClientToolResponse — WAS snake_case (function_responses), now camelCase
// ============================================================================

LiveClientToolResponse _$LiveClientToolResponseFromJson(
  Map<String, dynamic> json,
) => LiveClientToolResponse(
  functionResponses: (json['functionResponses'] as List<dynamic>?)
      ?.map((e) => FunctionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LiveClientToolResponseToJson(
  LiveClientToolResponse instance,
) => <String, dynamic>{'functionResponses': ?instance.functionResponses};

// ============================================================================
// LiveClientMessage — already camelCase in original (no FieldRename.snake)
// ============================================================================

LiveClientMessage _$LiveClientMessageFromJson(Map<String, dynamic> json) =>
    LiveClientMessage(
      setup: json['setup'] == null
          ? null
          : LiveClientSetup.fromJson(json['setup'] as Map<String, dynamic>),
      clientContent: json['clientContent'] == null
          ? null
          : LiveClientContent.fromJson(
              json['clientContent'] as Map<String, dynamic>,
            ),
      realtimeInput: json['realtimeInput'] == null
          ? null
          : LiveClientRealtimeInput.fromJson(
              json['realtimeInput'] as Map<String, dynamic>,
            ),
      toolResponse: json['toolResponse'] == null
          ? null
          : LiveClientToolResponse.fromJson(
              json['toolResponse'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$LiveClientMessageToJson(LiveClientMessage instance) =>
    <String, dynamic>{
      'setup': ?instance.setup,
      'clientContent': ?instance.clientContent,
      'realtimeInput': ?instance.realtimeInput,
      'toolResponse': ?instance.toolResponse,
    };

// ============================================================================
// LiveServerSetupComplete — already camelCase (createToJson: false)
// ============================================================================

LiveServerSetupComplete _$LiveServerSetupCompleteFromJson(
  Map<String, dynamic> json,
) => LiveServerSetupComplete(sessionId: json['sessionId'] as String?);

// ============================================================================
// Transcription — already camelCase (createToJson: false)
// ============================================================================

Transcription _$TranscriptionFromJson(Map<String, dynamic> json) =>
    Transcription(
      text: json['text'] as String?,
      finished: json['finished'] as bool?,
    );

// ============================================================================
// ExecutableCode — already camelCase (no FieldRename.snake)
// ============================================================================

ExecutableCode _$ExecutableCodeFromJson(Map<String, dynamic> json) =>
    ExecutableCode(
      language: json['language'] as String?,
      code: json['code'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$ExecutableCodeToJson(ExecutableCode instance) =>
    <String, dynamic>{
      'language': ?instance.language,
      'code': ?instance.code,
      'id': ?instance.id,
    };

// ============================================================================
// CodeExecutionResult — already camelCase (no FieldRename.snake)
// ============================================================================

CodeExecutionResult _$CodeExecutionResultFromJson(Map<String, dynamic> json) =>
    CodeExecutionResult(
      outcome: json['outcome'] as String?,
      output: json['output'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$CodeExecutionResultToJson(
  CodeExecutionResult instance,
) => <String, dynamic>{
  'outcome': ?instance.outcome,
  'output': ?instance.output,
  'id': ?instance.id,
};

// ============================================================================
// LiveServerContent — already camelCase (createToJson: false)
// ============================================================================

LiveServerContent _$LiveServerContentFromJson(Map<String, dynamic> json) =>
    LiveServerContent(
      modelTurn: json['modelTurn'] == null
          ? null
          : Content.fromJson(json['modelTurn'] as Map<String, dynamic>),
      turnComplete: json['turnComplete'] as bool?,
      interrupted: json['interrupted'] as bool?,
      groundingMetadata: json['groundingMetadata'] as Map<String, dynamic>?,
      inputTranscription: json['inputTranscription'] == null
          ? null
          : Transcription.fromJson(
              json['inputTranscription'] as Map<String, dynamic>,
            ),
      outputTranscription: json['outputTranscription'] == null
          ? null
          : Transcription.fromJson(
              json['outputTranscription'] as Map<String, dynamic>,
            ),
      generationComplete: json['generationComplete'] as bool?,
      urlContextMetadata: json['urlContextMetadata'] as Map<String, dynamic>?,
      turnCompleteReason: $enumDecodeNullable(
        _$TurnCompleteReasonEnumMap,
        json['turnCompleteReason'],
      ),
      waitingForInput: json['waitingForInput'] as bool?,
    );

const _$TurnCompleteReasonEnumMap = {
  TurnCompleteReason.TURN_COMPLETE_REASON_UNSPECIFIED:
      'TURN_COMPLETE_REASON_UNSPECIFIED',
  TurnCompleteReason.MALFORMED_FUNCTION_CALL: 'MALFORMED_FUNCTION_CALL',
  TurnCompleteReason.RESPONSE_REJECTED: 'RESPONSE_REJECTED',
  TurnCompleteReason.NEED_MORE_INPUT: 'NEED_MORE_INPUT',
  TurnCompleteReason.PROHIBITED_INPUT_CONTENT: 'PROHIBITED_INPUT_CONTENT',
  TurnCompleteReason.IMAGE_PROHIBITED_INPUT_CONTENT:
      'IMAGE_PROHIBITED_INPUT_CONTENT',
  TurnCompleteReason.INPUT_TEXT_CONTAIN_PROMINENT_PERSON_PROHIBITED:
      'INPUT_TEXT_CONTAIN_PROMINENT_PERSON_PROHIBITED',
  TurnCompleteReason.INPUT_IMAGE_CELEBRITY: 'INPUT_IMAGE_CELEBRITY',
  TurnCompleteReason.INPUT_IMAGE_PHOTO_REALISTIC_CHILD_PROHIBITED:
      'INPUT_IMAGE_PHOTO_REALISTIC_CHILD_PROHIBITED',
  TurnCompleteReason.INPUT_TEXT_NCII_PROHIBITED: 'INPUT_TEXT_NCII_PROHIBITED',
  TurnCompleteReason.INPUT_OTHER: 'INPUT_OTHER',
  TurnCompleteReason.INPUT_IP_PROHIBITED: 'INPUT_IP_PROHIBITED',
  TurnCompleteReason.BLOCKLIST: 'BLOCKLIST',
  TurnCompleteReason.UNSAFE_PROMPT_FOR_IMAGE_GENERATION:
      'UNSAFE_PROMPT_FOR_IMAGE_GENERATION',
  TurnCompleteReason.GENERATED_IMAGE_SAFETY: 'GENERATED_IMAGE_SAFETY',
  TurnCompleteReason.GENERATED_CONTENT_SAFETY: 'GENERATED_CONTENT_SAFETY',
  TurnCompleteReason.GENERATED_AUDIO_SAFETY: 'GENERATED_AUDIO_SAFETY',
  TurnCompleteReason.GENERATED_VIDEO_SAFETY: 'GENERATED_VIDEO_SAFETY',
  TurnCompleteReason.GENERATED_CONTENT_PROHIBITED:
      'GENERATED_CONTENT_PROHIBITED',
  TurnCompleteReason.GENERATED_CONTENT_BLOCKLIST: 'GENERATED_CONTENT_BLOCKLIST',
  TurnCompleteReason.GENERATED_IMAGE_PROHIBITED: 'GENERATED_IMAGE_PROHIBITED',
  TurnCompleteReason.GENERATED_IMAGE_CELEBRITY: 'GENERATED_IMAGE_CELEBRITY',
  TurnCompleteReason.GENERATED_IMAGE_PROMINENT_PEOPLE_DETECTED_BY_REWRITER:
      'GENERATED_IMAGE_PROMINENT_PEOPLE_DETECTED_BY_REWRITER',
  TurnCompleteReason.GENERATED_IMAGE_IDENTIFIABLE_PEOPLE:
      'GENERATED_IMAGE_IDENTIFIABLE_PEOPLE',
  TurnCompleteReason.GENERATED_IMAGE_MINORS: 'GENERATED_IMAGE_MINORS',
  TurnCompleteReason.OUTPUT_IMAGE_IP_PROHIBITED: 'OUTPUT_IMAGE_IP_PROHIBITED',
  TurnCompleteReason.GENERATED_OTHER: 'GENERATED_OTHER',
  TurnCompleteReason.MAX_REGENERATION_REACHED: 'MAX_REGENERATION_REACHED',
};

// ============================================================================
// LiveServerToolCall — already camelCase (createToJson: false)
// ============================================================================

LiveServerToolCall _$LiveServerToolCallFromJson(Map<String, dynamic> json) =>
    LiveServerToolCall(
      functionCalls: (json['functionCalls'] as List<dynamic>?)
          ?.map((e) => FunctionCall.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

// ============================================================================
// LiveServerToolCallCancellation — already camelCase (createToJson: false)
// ============================================================================

LiveServerToolCallCancellation _$LiveServerToolCallCancellationFromJson(
  Map<String, dynamic> json,
) => LiveServerToolCallCancellation(
  ids: (json['ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

// ============================================================================
// LiveServerGoAway — already camelCase (createToJson: false)
// ============================================================================

LiveServerGoAway _$LiveServerGoAwayFromJson(Map<String, dynamic> json) =>
    LiveServerGoAway(
      timeLeft: json['timeLeft'] as String?,
      reason: json['reason'] as String?,
    );

// ============================================================================
// LiveServerSessionResumptionUpdate — already camelCase (createToJson: false)
// ============================================================================

LiveServerSessionResumptionUpdate _$LiveServerSessionResumptionUpdateFromJson(
  Map<String, dynamic> json,
) => LiveServerSessionResumptionUpdate(
  newHandle: json['newHandle'] as String?,
  resumable: json['resumable'] as bool?,
  lastConsumedClientMessageIndex:
      json['lastConsumedClientMessageIndex'] as String?,
);

// ============================================================================
// VoiceActivityDetectionSignal — already camelCase (createToJson: false)
// ============================================================================

VoiceActivityDetectionSignal _$VoiceActivityDetectionSignalFromJson(
  Map<String, dynamic> json,
) => VoiceActivityDetectionSignal(
  vadSignalType: $enumDecodeNullable(
    _$VadSignalTypeEnumMap,
    json['vadSignalType'],
  ),
);

const _$VadSignalTypeEnumMap = {
  VadSignalType.VAD_SIGNAL_TYPE_UNSPECIFIED: 'VAD_SIGNAL_TYPE_UNSPECIFIED',
  VadSignalType.VAD_SIGNAL_TYPE_SOS: 'VAD_SIGNAL_TYPE_SOS',
  VadSignalType.VAD_SIGNAL_TYPE_EOS: 'VAD_SIGNAL_TYPE_EOS',
};

// ============================================================================
// VoiceActivity — already camelCase (createToJson: false)
// ============================================================================

VoiceActivity _$VoiceActivityFromJson(Map<String, dynamic> json) =>
    VoiceActivity(
      voiceActivityType: $enumDecodeNullable(
        _$VoiceActivityTypeEnumMap,
        json['voiceActivityType'],
      ),
    );

const _$VoiceActivityTypeEnumMap = {
  VoiceActivityType.TYPE_UNSPECIFIED: 'TYPE_UNSPECIFIED',
  VoiceActivityType.ACTIVITY_START: 'ACTIVITY_START',
  VoiceActivityType.ACTIVITY_END: 'ACTIVITY_END',
};

// ============================================================================
// ModalityTokenCount — already camelCase (createToJson: false)
// ============================================================================

ModalityTokenCount _$ModalityTokenCountFromJson(Map<String, dynamic> json) =>
    ModalityTokenCount(
      modality: $enumDecodeNullable(_$MediaModalityEnumMap, json['modality']),
      tokenCount: (json['tokenCount'] as num?)?.toInt(),
    );

const _$MediaModalityEnumMap = {
  MediaModality.MODALITY_UNSPECIFIED: 'MODALITY_UNSPECIFIED',
  MediaModality.TEXT: 'TEXT',
  MediaModality.IMAGE: 'IMAGE',
  MediaModality.VIDEO: 'VIDEO',
  MediaModality.AUDIO: 'AUDIO',
  MediaModality.DOCUMENT: 'DOCUMENT',
};

// ============================================================================
// UsageMetadata — already camelCase (createToJson: false)
// ============================================================================

UsageMetadata _$UsageMetadataFromJson(
  Map<String, dynamic> json,
) => UsageMetadata(
  promptTokenCount: (json['promptTokenCount'] as num?)?.toInt(),
  cachedContentTokenCount: (json['cachedContentTokenCount'] as num?)?.toInt(),
  responseTokenCount: (json['responseTokenCount'] as num?)?.toInt(),
  toolUsePromptTokenCount: (json['toolUsePromptTokenCount'] as num?)?.toInt(),
  thoughtsTokenCount: (json['thoughtsTokenCount'] as num?)?.toInt(),
  totalTokenCount: (json['totalTokenCount'] as num?)?.toInt(),
  promptTokensDetails: (json['promptTokensDetails'] as List<dynamic>?)
      ?.map((e) => ModalityTokenCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  cacheTokensDetails: (json['cacheTokensDetails'] as List<dynamic>?)
      ?.map((e) => ModalityTokenCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  responseTokensDetails: (json['responseTokensDetails'] as List<dynamic>?)
      ?.map((e) => ModalityTokenCount.fromJson(e as Map<String, dynamic>))
      .toList(),
  toolUsePromptTokensDetails:
      (json['toolUsePromptTokensDetails'] as List<dynamic>?)
          ?.map((e) => ModalityTokenCount.fromJson(e as Map<String, dynamic>))
          .toList(),
  trafficType: $enumDecodeNullable(_$TrafficTypeEnumMap, json['trafficType']),
);

const _$TrafficTypeEnumMap = {
  TrafficType.TRAFFIC_TYPE_UNSPECIFIED: 'TRAFFIC_TYPE_UNSPECIFIED',
  TrafficType.ON_DEMAND: 'ON_DEMAND',
  TrafficType.ON_DEMAND_PRIORITY: 'ON_DEMAND_PRIORITY',
  TrafficType.ON_DEMAND_FLEX: 'ON_DEMAND_FLEX',
  TrafficType.PROVISIONED_THROUGHPUT: 'PROVISIONED_THROUGHPUT',
};

// ============================================================================
// LiveServerMessage — already camelCase (createToJson: false)
// ============================================================================

LiveServerMessage _$LiveServerMessageFromJson(
  Map<String, dynamic> json,
) => LiveServerMessage(
  setupComplete: json['setupComplete'] == null
      ? null
      : LiveServerSetupComplete.fromJson(
          json['setupComplete'] as Map<String, dynamic>,
        ),
  serverContent: json['serverContent'] == null
      ? null
      : LiveServerContent.fromJson(
          json['serverContent'] as Map<String, dynamic>,
        ),
  usageMetadata: json['usageMetadata'] == null
      ? null
      : UsageMetadata.fromJson(json['usageMetadata'] as Map<String, dynamic>),
  toolCall: json['toolCall'] == null
      ? null
      : LiveServerToolCall.fromJson(json['toolCall'] as Map<String, dynamic>),
  toolCallCancellation: json['toolCallCancellation'] == null
      ? null
      : LiveServerToolCallCancellation.fromJson(
          json['toolCallCancellation'] as Map<String, dynamic>,
        ),
  goAway: json['goAway'] == null
      ? null
      : LiveServerGoAway.fromJson(json['goAway'] as Map<String, dynamic>),
  sessionResumptionUpdate: json['sessionResumptionUpdate'] == null
      ? null
      : LiveServerSessionResumptionUpdate.fromJson(
          json['sessionResumptionUpdate'] as Map<String, dynamic>,
        ),
  voiceActivityDetectionSignal: json['voiceActivityDetectionSignal'] == null
      ? null
      : VoiceActivityDetectionSignal.fromJson(
          json['voiceActivityDetectionSignal'] as Map<String, dynamic>,
        ),
  voiceActivity: json['voiceActivity'] == null
      ? null
      : VoiceActivity.fromJson(json['voiceActivity'] as Map<String, dynamic>),
);
