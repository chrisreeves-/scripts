provider "opnsense" {
  uri            = ""   # e.g. http://10.0.0.254
  api_key        = ""   # See README.md for how to generate an API key
  api_secret     = ""   # See README.md for how to generate an API secret
  allow_insecure = true # Set true if you are using self-signed certificate
}