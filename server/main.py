
# def run(param_1: str, param_2: str, run_id):  # run_id is optional, injected by Cerebrium at runtime
#     my_results = {"1": param_1, "2": param_2}
#     my_status_code = 200 # if you want to return a specific status code

#     return {"my_result": my_results, "status_code": my_status_code} # return your results

import base64
import io
import os
import torch

from diffusers import DiffusionPipeline
from diffusers import BitsAndBytesConfig as DiffusersBitsAndBytesConfig, StableAudioDiTModel, StableAudioPipeline
from transformers import BitsAndBytesConfig as BitsAndBytesConfig, T5EncoderModel

import scipy
import numpy as np

image_model_name = "stabilityai/sdxl-turbo"
song_model_name = "stabilityai/stable-audio-open-1.0"

hf_token = os.environ.get('hf_token')

def init():
    global image_pipe
    global song_pipe

    image_pipe = DiffusionPipeline.from_pretrained(image_model_name, torch_dtype=torch.float16).to("cuda")

    quant_config = BitsAndBytesConfig(load_in_8bit=True)
    text_encoder_8bit = T5EncoderModel.from_pretrained(
        "stabilityai/stable-audio-open-1.0",
        subfolder="text_encoder",
        quantization_config=quant_config,
        torch_dtype=torch.float16,
    )

    quant_config = DiffusersBitsAndBytesConfig(load_in_8bit=True)
    transformer_8bit = StableAudioDiTModel.from_pretrained(
        "stabilityai/stable-audio-open-1.0",
        subfolder="transformer",
        quantization_config=quant_config,
        torch_dtype=torch.float16,
    )


    song_pipe = StableAudioPipeline.from_pretrained(
        "stabilityai/stable-audio-open-1.0",
        text_encoder=text_encoder_8bit,
        transformer=transformer_8bit,
        torch_dtype=torch.float16,
        device_map="balanced",
    )

def generate_image(prompt: str):
    image = image_pipe(prompt).images[0]
    buffered = io.BytesIO()
    image.save(buffered, format="PNG")
    return {"image": base64.b64encode(buffered.getvalue()).decode("utf-8")}

def generate_song(prompt: str):
    audio = song_pipe(
        prompt,
        num_inference_steps=20,
        audio_end_in_s=30.0,
        num_waveforms_per_prompt=3
    ).audios[0]
    audio_np = audio.T.float().cpu().numpy()
    buffered = io.BytesIO()
    scipy.io.wavfile.write(buffered, song_pipe.vae.sampling_rate, audio_np)
    buffered.seek(0)
    
    return {"song": base64.b64encode(buffered.getvalue()).decode("utf-8")}


# To deploy your app, run:
# cerebrium deploy
