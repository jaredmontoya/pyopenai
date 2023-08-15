import httpclient, json

import ../types
import ../utils


proc createEmbedding*(self: OpenAiClient,
    model: string,
    input: string|seq[string],
    user = ""
    ): Embeddings =
    ## creates ``Embeddings``

    var body = %*{
        "model": model,
        "input": input
    }

    if user != "":
        body.add("user", %user)

    let resp = buildHttpClient(self, "application/json").post(
            self.apiBase&"/embeddings", body = $body)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        of $Http400:
            raise InvalidParameters(msg: "Some of the parameters that you provided are invalid")
        of $Http429:
            raise TooManyRequests(msg: "You are being ratelimited")
        else:
            raise newException(Defect, "Unknown error")
