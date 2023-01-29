import openai

# Set the OpenAI API key
key = input("Please enter the OpenAI API key: ")
openai.api_key = key
message = input("What do you want to ask?: ")

# Define the model and prompt to use
model_engine = "text-davinci-002"
prompt = message

# Generate a response
result = openai.Completion.create(
    engine=model_engine,
    prompt=prompt,
    max_tokens=1024,
    n=1,
    stop=None,
    temperature=0.5,
)

# Print the response
message = result.choices[0].text
print(message)

