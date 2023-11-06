import httpclient

import types

proc buildHttpClient*(client: OpenAiClient, contentType = ""): HttpClient =
  var openAiHeaders = newHttpHeaders()

  if client.apiKey != "":
    openAiHeaders.add("Authorization", "Bearer "&client.apiKey)

  if contentType != "":
    openAiHeaders.add("Content-Type", contentType)

  if client.organization != "":
    openAiHeaders.add("OpenAI_Organization", client.organization)

  if client.userAgent != "":
    openAiHeaders.add("User-Agent", client.userAgent)

  return newHttpClient(headers = openAiHeaders)
