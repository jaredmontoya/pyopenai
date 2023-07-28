import json


type
    OpenAiClient* = object
        apiKey*: string
        organization*: string
        userAgent*: string

type
    Completions* = JsonNode
    ChatCompletions* = JsonNode
    Edits* = JsonNode
    Images* = JsonNode
    Embeddings* = JsonNode
    FineTune* = JsonNode
    Moderation* = JsonNode

type
    NotFound* = ref object of CatchableError
    InvalidApiKey* = ref object of CatchableError
    InvalidParameters* = ref object of CatchableError
