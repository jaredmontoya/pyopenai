import unittest
import os
import json
import strutils

import pyopenai

suite "Generations Tests":
    test "Completions":
        var openai = newOpenAiClient(getEnv("OPENAI_API_KEY"))

        let response = openai.createCompletion(
            model = "text-davinci-003",
            prompt = "What's the capital of Poland? answer with one word.",
            temperature = 0.6,
            maxTokens = 50
        )

        check response["choices"][0]["text"].getStr().contains("Warsaw")