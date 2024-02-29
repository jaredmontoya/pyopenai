# PyOpenAI

![Github top language](https://img.shields.io/github/languages/top/jaredmontoya/pyopenai?style=for-the-badge&logo=nim&color=yellow)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/jaredmontoya/pyopenai?style=for-the-badge)

An attempt to reimplement python OpenAI API bindings in nim

## Project Status

- streams not implemented
- async not implemented
- not fully tested so if you encounter errors open an issue

If you need features that are not implemented yet, try [openaiclient](https://nimble.directory/pkg/openaiclient)

### What is implemented

- [Models](https://platform.openai.com/docs/api-reference/models)
- [Completions](https://platform.openai.com/docs/api-reference/completions)
- [ChatCompletions](https://platform.openai.com/docs/api-reference/chat)
- [Edits](https://platform.openai.com/docs/api-reference/edits)
- [Images](https://platform.openai.com/docs/api-reference/images)
- [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
- [Audio](https://platform.openai.com/docs/api-reference/audio/create)
- [Files](https://platform.openai.com/docs/api-reference/files)
- [Fine-Tunes](https://platform.openai.com/docs/api-reference/fine-tunes)
- [Moderations](https://platform.openai.com/docs/api-reference/moderations)

## Installation

To install pyopenai, you can simply run

```bash
nimble install pyopenai
```

- Uninstall with `nimble uninstall pyopenai`.
- [Nimble repo page](https://nimble.directory/pkg/pyopenai)

## Requisites

- [Nim](https://nim-lang.org)

## Example

```nim
import pyopenai, json, os

var openai = OpenAiClient(
  apiKey: getEnv("OPENAI_API_KEY")
)

let response = openai.createCompletion(
  model = "text-davinci-003",
  prompt = "nim is the best programming language",
  temperature = 0.6,
  maxTokens = 500
)

echo(response["choices"][0]["text"].str)

echo()

var chatMessages: seq[JsonNode]

chatMessages.add(
  %*{"role": "user", "content": "nim is the best programming language"}
)

let resp = openai.createChatCompletion(
  model = "gpt-3.5-turbo",
  messages = chatMessages,
  temperature = 0.5,
  maxTokens = 1000
)

chatMessages.add(
  resp["choices"][0]["message"]
)

echo(resp["choices"][0]["message"]["content"].str)
```
