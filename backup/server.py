from diffusers import StableDiffusionPipeline

pipeline = StableDiffusionPipeline.from_single_file(
    "./server/model/768-v-ema.safetensors"
)

prompt = "A realistic 3D rendering of a mysterious, ancient artifact. The artifact appears to be made from a mix of gold and stone, featuring intricate carvings and symbols that suggest a lost civilization. It sits on a pedestal in a dimly lit room, casting shadows on the walls that hint at its complex shape. The atmosphere is filled with a sense of wonder and ancient power, inviting the viewer to speculate about its origins and purpose."
image = pipeline(prompt).images[0]

image.save("artifact.jpg")
print(image)