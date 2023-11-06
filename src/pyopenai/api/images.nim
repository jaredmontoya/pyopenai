import httpclient, json

import ../types
import ../utils


proc createImage*(self: OpenAiClient,
    prompt: string,
    n: uint = 1,
    size = "1024x1024",
    responseFormat = "url",
    user = ""
  ): Images =
  ## creates ``Images``

  var body = %*{
    "prompt": prompt
  }

  if n != 1:
    body.add("n", %n)

  if size != "1024x1024":
    body.add("size", %size)

  if responseFormat != "url":
    body.add("response_format", %responseFormat)

  if user != "":
    body.add("user", %user)

  let resp = buildHttpClient(self, "application/json").post(
    self.apiBase&"/images/generations", body = $body
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


proc createImageEdit*(self: OpenAiClient,
    image: string,
    prompt: string,
    mask = "",
    n: uint = 1,
    size = "1024x1024",
    responseFormat = "url",
    user = ""
  ): Images =
  # creates ``Images`` based on another image and an edit prompt

  var data = MultipartData()

  data.add({"prompt": prompt})

  data.addFiles({"image": image})

  if mask != "":
    data.addFiles({"mask": mask})

  if n != 1:
    data.add({"n": $n})

  if size != "1024x1024":
    data.add({"size": size})

  if responseFormat != "url":
    data.add({"response_format": responseFormat})

  if user != "":
    data.add({"user": user})

  let resp = buildHttpClient(self, "multipart/form-data").post(
    self.apiBase&"/images/edits", multipart = data
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


proc createImageVariation*(self: OpenAiClient,
    image: string,
    n: uint = 1,
    size = "1024x1024",
    responseFormat = "url",
    user = ""
  ): Images =
  # creates ``Images`` based on another image and an edit prompt

  var data = MultipartData()

  data.addFiles({"image": image})

  if n != 1:
    data.add({"n": $n})

  if size != "1024x1024":
    data.add({"size": size})

  if responseFormat != "url":
    data.add({"response_format": responseFormat})

  if user != "":
    data.add({"user": user})

  let resp = buildHttpClient(self, "multipart/form-data").post(
    self.apiBase&"/images/variations", multipart = data
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
