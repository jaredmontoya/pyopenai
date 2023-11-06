import httpclient, json

import ../types
import ../utils


proc createEdit*(self: OpenAiClient,
    model: string,
    instruction: string,
    input = "",
    n: uint = 1,
    temperature = 1.0,
    topP = 1.0
  ): Edits =
  ## creates ``Edits``

  var body = %*{
    "model": model,
    "instruction": instruction
  }

  if input != "":
    body.add("input", %input)

  if n != 1:
    body.add("n", %n)

  if temperature != 1.0:
    body.add("temperature", %temperature)

  if topP != 1.0:
    body.add("top_p", %topP)

  let resp = buildHttpClient(self, "application/json").post(
    self.apiBase&"/edits", body = $body
  )
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
