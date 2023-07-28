import httpclient, json

import ../consts
import ../types
import ../utils


proc createModeration*(self: OpenAiClient,
    input: string|seq[string],
    model = ""
    ): Moderation =
    ## creates ``Moderation``

    var body = %*{
        "input": input
    }

    if model != "":
        body.add("model", %model)

    let resp = buildHttpClient(self, "application/json").post(
            OpenAiBaseUrl&"/moderations", body = $body)
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
