import httpclient, json

import ../types
import ../utils


proc getFileList*(self: OpenAiClient): JsonNode =
    let resp = buildHttpClient(self).get(
            self.apiBase&"/files")
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        else:
            raise newException(Defect, "Unknown error")


proc uploadFile*(self: OpenAiClient,
    file: string,
    purpose: string
    ): JsonNode =
    # uploads the file to openai

    var data = MultipartData()

    data.add({"purpose": purpose})

    data.addFiles({"file": file})

    let resp = buildHttpClient(self).post(
            self.apiBase&"/files", multipart = data)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The file that you specified does not exist")
        of $Http400:
            raise InvalidParameters(msg: "Some of the parameters that you provided are invalid")
        else:
            raise newException(Defect, "Unknown error")


proc deleteFile*(self: OpenAiClient, fileId: string): JsonNode =
    # deletes the file on openai

    let resp = buildHttpClient(self).delete(
            self.apiBase&"/files/"&fileId)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The file that you specified does not exist")
        else:
            raise newException(Defect, "Unknown error")


proc getFile*(self: OpenAiClient, fileId: string): JsonNode =
    # gets information about specified file

    let resp = buildHttpClient(self).get(
            self.apiBase&"/files/"&fileId)
    case resp.status
        of $Http200:
            return resp.body.parseJson()
        of $Http401:
            raise InvalidApiKey(msg: "Provided OpenAI API key is invalid")
        of $Http404:
            raise NotFound(msg: "The file that you specified does not exist")
        else:
            raise newException(Defect, "Unknown error")


proc downloadFile*(self: OpenAiClient, fileId: string): void =
    # downloads specified file

    let filename: string = self.getFile(fileId)["filename"].str

    try:
        buildHttpClient(self).downloadFile(self.apiBase&"/files/"&fileId&"/content", filename)
    except HttpRequestError:
        raise newException(HttpRequestError, "To help mitigate abuse, downloading of fine-tune training files is disabled for free accounts.")