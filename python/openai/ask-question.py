import os
import openai
import sys

# Set the OpenAI API key
print("You can create an API key from here: https://beta.openai.com/account/api-keys")
key = input("Please enter the OpenAI API key: ")

if key == "":
    os.getenv("OPENAI_API_KEY")
else:
    openai.api_key = key

# Define the model and prompt to use
model = input("""
text = ['text-davinci-002'], ['text-currie-001'], ['text-babbage-001'], ['text-ada-001']
What OpenAI model do you want to use?: """)

if model != "text-davinci-002" or "text-currie-001" or "text-babbage-001" or "text-ada-001":
    model_engine = str.lower(model)
else:
    print("Model input error")
    sys.exit()


# Ask a question
message = input("What do you want to ask?: ")
prompt = message

# Generate a response
response = openai.Completion.create(
    engine=model_engine,
    prompt=prompt,
    max_tokens=1024,
    n=1,
    stop=None,
    temperature=0.5,
)

# Print the response
message = response.choices[0].text
print(message)
