import httpclient, json

import ../types
import ../utils


proc getFineTunes*(self: OpenAiClient): JsonNode =
  ## gets a list of ``FineTune``s

  let resp = buildHttpClient(self).get(self.apiBase&"/fine-tunes")
  case resp.status
    of $Http200:
      return resp.body.parseJson()
    of $Http401:
      raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
    of $Http429:
      raise TooManyRequests(msg: "You are being ratelimited")
    else:
      raise newException(Defect, "Unknown error")


proc getFineTune*(self: OpenAiClient, fineTuneId: string): FineTune =
  ## gets a ``FineTune``

  let resp = buildHttpClient(self).get(self.apiBase&"/fine-tunes/"&fineTuneId)
  case resp.status
    of $Http200:
      return resp.body.parseJson()
    of $Http401:
      raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
    of $Http404:
      raise NotFound(msg: "The fine-tune job that you specified does not exist")
    of $Http429:
      raise TooManyRequests(msg: "You are being ratelimited")
    else:
      raise newException(Defect, "Unknown error")


proc getFineTuneEvents*(self: OpenAiClient, fineTuneId: string): JsonNode =
  ## gets ``FineTune``'s events

  let resp = buildHttpClient(self).get(self.apiBase&"/fine-tunes/"&fineTuneId&"/events")
  case resp.status
    of $Http200:
      return resp.body.parseJson()
    of $Http401:
      raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
    of $Http404:
      raise NotFound(msg: "The fine-tune job that you specified does not exist")
    of $Http429:
      raise TooManyRequests(msg: "You are being ratelimited")
    else:
      raise newException(Defect, "Unknown error")


proc createFineTune*(self: OpenAiClient,
    trainingFile: string,
    validationFile: string = "",
    model = "curie",
    nEpochs: uint = 4,
    batchSize: uint = 0,
    learningRateMultiplier = 0.0,
    promptLossWeight = 0.1,
    computeClassificationMetrics = false,
    classificationNClasses = 0,
    classificationPositiveClass = "",
    classificationBetas: seq[float] = @[],
    suffix = ""
  ): FineTune =
  ## creates a ``FineTune``

  var body = %*{
    "training_file": trainingFile
  }

  if validationFile != "":
    body.add("validation_file", %validationFile)

  if model != "":
    body.add("model", %model)

  if nEpochs != 4:
    body.add("n_epochs", %nEpochs)

  if batchSize != 0:
    body.add("batch_size", %batchSize)

  if learningRateMultiplier != 0.0:
    body.add("learing_rate_multiplier", %learningRateMultiplier)

  if promptLossWeight != 0.1:
    body.add("prompt_loss_weight", %promptLossWeight)

  if computeClassificationMetrics != false:
    body.add("compute_classification_metrics", %computeClassificationMetrics)

  if classificationNClasses != 0:
    body.add("classification_n_classes", %classificationNClasses)

  if classificationPositiveClass != "":
    body.add("classification_positive_class", %classificationPositiveClass)

  if len(classificationBetas) != 0:
    body.add("classification_betas", %classificationBetas)

  if suffix != "":
    body.add("suffix", %suffix)

  let resp = buildHttpClient(self, "application/json").post(
    self.apiBase&"/fine-tunes", body = $body
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


proc cancelFineTune*(self: OpenAiClient, fineTuneId: string): FineTune =
  ## cancels a ``FineTune``

  let resp = buildHttpClient(self).post(
    self.apiBase&"/fine-tunes/"&fineTuneId&"/cancel"
  )
  case resp.status
    of $Http200:
      return resp.body.parseJson()
    of $Http401:
      raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
    of $Http404:
      raise NotFound(msg: "The fine-tune job that you specified does not exist")
    of $Http429:
      raise TooManyRequests(msg: "You are being ratelimited")
    else:
      raise newException(Defect, "Unknown error")
