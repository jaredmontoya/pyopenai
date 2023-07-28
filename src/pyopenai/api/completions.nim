import httpclient, json

import ../consts
import ../types
import ../utils


proc createCompletion*(self: OpenAiClient,
    model: string,
    prompt: string = "",
    suffix = "",
    maxTokens: uint = 0,
    temperature = 1.0,
    topP = 1.0,
    n: uint = 1,
    logprobs: uint = 0,
    promptEcho = false,
    stop: seq[string] = @[],
    presencePenalty = 0.0,
    frequencyPenalty = 0.0,
    bestOf: uint = 1,
    logitBias: JsonNode = %false,
    user = ""
    ): Completions =
    ## creates ``Completions``

    var body = %*{
        "model": model
    }

    if prompt != "":
        body.add("prompt", %prompt)

    if suffix != "":
        body.add("suffix", %suffix)

    if maxTokens != 0:
        body.add("max_tokens", %maxTokens)

    if temperature != 1.0:
        body.add("temperature", %temperature)

    if topP != 1.0:
        body.add("top_p", %topP)

    if n != 1:
        body.add("n", %n)

    if logprobs != 0:
        body.add("logprobs", %logprobs)

    if promptEcho != false:
        body.add("echo", %promptEcho)

    if len(stop) != 0:
        body.add("stop", %stop)

    if presencePenalty != 0.0:
        body.add("presence_penalty", %presencePenalty)

    if frequencyPenalty != 0.0:
        body.add("frequency_penalty", %frequencyPenalty)

    if bestOf != 1:
        body.add("best_of", %bestOf)

    if logitBias != %false:
        body.add("logit_bias", %logitBias)

    if user != "":
        body.add("user", %user)

    let resp = buildHttpClient(self, "application/json").post(
            OpenAiBaseUrl&"/completions", body = $body)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        of $Http400:
            raise InvalidParameters(msg: "Some of the parameters that you provided are invalid")
        else:
            raise newException(Defect, "Unknown error")


proc createChatCompletion*(self: OpenAiClient,
    model: string,
    messages: seq[JsonNode],
    temperature = 1.0,
    topP = 1.0,
    n: uint = 1,
    stop: string = "",
    maxTokens: uint = 0,
    presencePenalty = 0.0,
    frequencyPenalty = 0.0,
    logitBias: JsonNode = %false,
    user = ""
    ): ChatCompletions =
    ## creates ``ChatCompletions``

    var body = %*{
        "model": model,
        "messages": messages
    }

    if temperature != 1.0:
        body.add("temperature", %temperature)

    if topP != 1.0:
        body.add("top_p", %topP)

    if n != 1:
        body.add("n", %n)

    if stop != "":
        body.add("stop", %stop)

    if maxTokens != 0:
        body.add("max_tokens", %maxTokens)

    if presencePenalty != 0.0:
        body.add("presence_penalty", %presencePenalty)

    if frequencyPenalty != 0.0:
        body.add("frequency_penalty", %frequencyPenalty)

    if logitBias != %false:
        body.add("logit_bias", %logitBias)

    if user != "":
        body.add("user", %user)

    let resp = buildHttpClient(self, "application/json").post(
            OpenAiBaseUrl&"/chat/completions", body = $body)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        of $Http400:
            raise InvalidParameters(msg: "Some of the parameters that you provided are invalid")
        else:
            raise newException(Defect, "Unknown error")
