import httpclient

import consts
import types

proc newOpenAiClient*(): OpenAiClient =
    OpenAiClient(apiBase: OpenAiBaseUrl)

proc newOpenAiClient*(apiKey: string): OpenAiClient =
    OpenAiClient(apiBase: OpenAiBaseUrl, apiKey: apiKey)

proc buildHttpClient*(client: OpenAiClient, contentType = ""): HttpClient =

    var openAiHeaders = newHttpHeaders(
        [
            ("Authorization", "Bearer "&client.apiKey)
        ]
    )

    if contentType != "":
        openAiHeaders.add("Content-Type", contentType)

    if client.organization != "":
        openAiHeaders.add("OpenAI_Organization", client.organization)

    if client.userAgent != "":
        openAiHeaders.add("User-Agent", client.userAgent)

    return newHttpClient(headers = openAiHeaders)