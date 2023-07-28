import httpclient, json

import ../consts
import ../types
import ../utils


proc createAudioTranscription*(self: OpenAiClient,
    file: string,
    model: string,
    prompt = "",
    temperature = 0.0,
    language = ""
    ): string =
    # creates an audio file's transcription

    var data = MultipartData()

    data.add({"model": model})

    data.addFiles({"file": file})

    if prompt != "":
        data.add({"prompt": prompt})
    
    if temperature != 0.0:
        data.add({"temperature": $temperature})

    if language != "":
        data.add({"language": language})

    let resp = buildHttpClient(self, "multipart/form-data").post(
            OpenAiBaseUrl&"/audio/transcriptions", multipart = data)
    case resp.status
        of $Http200:
            return resp.body.parseJson()["text"].str
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        of $Http400:
            raise InvalidParameters(msg: "Some of the parameters that you provided are invalid")
        else:
            raise newException(Defect, "Unknown error")


proc createAudioTranslation*(self: OpenAiClient,
    file: string,
    model: string,
    prompt = "",
    temperature = 0.0
    ): string =
    # creates an audio file's translation to english

    var data = MultipartData()

    data.add({"model": model})

    data.addFiles({"file": file})

    if prompt != "":
        data.add({"prompt": prompt})
    
    if temperature != 0.0:
        data.add({"temperature": $temperature})

    let resp = buildHttpClient(self, "multipart/form-data").post(
            OpenAiBaseUrl&"/audio/translations", multipart = data)
    case resp.status
        of $Http200:
            return resp.body.parseJson()["text"].str
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The model that you specified does not exist")
        of $Http400:
            raise InvalidParameters(msg: "Some of the parameters that you provided are invalid")
        else:
            raise newException(Defect, "Unknown error")