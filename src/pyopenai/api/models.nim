import httpclient, json

import ../consts
import ../types
import ../utils


proc getModelList*(self: OpenAiClient): JsonNode =
    ## gets list of available models

    let resp = buildHttpClient(self).get(
            OpenAiBaseUrl&"/models")
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        else:
            raise newException(Defect, "Unknown error")


proc getModel*(self: OpenAiClient, model: string): JsonNode =
    ## gets model details

    let resp = buildHttpClient(self).get(
            OpenAiBaseUrl&"/models/"&model)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        else:
            raise newException(Defect, "Unknown error")

proc deleteModel*(self: OpenAiClient, model: string): JsonNode =
    # deletes the model on openai

    let resp = buildHttpClient(self).delete(OpenAiBaseUrl&"/models/"&model)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        else:
            raise newException(Defect, "Unknown error")
