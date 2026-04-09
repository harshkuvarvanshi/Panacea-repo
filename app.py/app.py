import requests
from requests_aws4auth import AWS4Auth
import boto3



sts = boto3.client("sts")
print(sts.get_caller_identity())

session = boto3.Session(profile_name="default")  # or your profile name
credentials = session.get_credentials()
# 🔹 CONFIG
region = "ap-southeast-1"
service = "aoss"

endpoint = "https://utfmphi507qpd0hnuhf8.ap-southeast-1.aoss.amazonaws.com"

# 🔹 AWS AUTH (auto uses your aws configure credentials)
credentials = boto3.Session().get_credentials()

auth = AWS4Auth(
    credentials.access_key,
    credentials.secret_key,
    region,
    service,
    session_token=credentials.token
)

# 🔹 WRITE TEST (send log)
# WRITE
# CREATE INDEX
requests.put(f"{endpoint}/logs", auth=auth)

# WRITE
write_response = requests.post(
    f"{endpoint}/logs/_doc",
    auth=auth,
    json={
        "message": "hello from dev 🚀",
        "level": "info"
    }
)

print("Write Status:", write_response.status_code)
print(write_response.text)

# READ
read_response = requests.get(
    f"{endpoint}/logs/_search",
    auth=auth
)