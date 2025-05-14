import requests
import json
import base64
from PIL import Image
import io

url = "https://api.cortex.cerebrium.ai/v4/p-cdf3ec7f/hugging-face-starter/run"

payload = json.dumps({"prompt": "make a portrait of a cat"})

headers = {
  'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9qZWN0SWQiOiJwLWNkZjNlYzdmIiwibmFtZSI6IiIsImRlc2NyaXB0aW9uIjoiIiwiZXhwIjoyMDU1ODI5Nzk4fQ.zp0-WSkE7JyG8Ol8Ksfdnt4V-Je2EHsy5mlJ6lnMUAtiqh7s98NfQhsxs-DHCHHQVslK8QSOHn1iJEju2p-5TppiTFdsZrMQicgrI4b8DjkgtkeeRU60nYTG3LTuFXlKHkEGnZ068lYUYvsPdWforhYVlKObAiTlHJ8NtLW_FtK7U-rYg21tg55dQi0L64RdfZi_8-YOChQyLDYzPABEVw3OfncT2nGgwqGjyeisLkC6mI_pQVtw-gwFZlL9uc83UPAmklzW9lDWL-7IFMF-jvUbCPbeV_EGmIoAFYaYFXYeQJIEUJ0lrZ0zk_xssYVKpPkjdxxddP4Yq2JJuwSE_A',
  'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)

image_encode = response.json()['result']['image']
buffered = base64.b64decode(image_encode)
image = Image.open(io.BytesIO(buffered))
image.save("output.png", format="PNG")

print(response.text)