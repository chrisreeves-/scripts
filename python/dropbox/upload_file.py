import pathlib
import dropbox
from dropbox.exceptions import AuthError

sltoken = ""
local_path = ""
local_file = ""
dropbox_file_path = ""

def dropbox_connect():
    try:
        dbx = dropbox.Dropbox(sltoken)
    except AuthError as e:
        print('Error connecting to Dropbox with access token: ' + str(e))
    return dbx


def dropbox_upload_file(local_path, local_file, dropbox_file_path):
    try:
        dbx = dropbox_connect()

        local_file_path = pathlib.Path(local_path) / local_file

        with local_file_path.open("rb") as f:
            meta = dbx.files_upload(f.read(), dropbox_file_path, mode=dropbox.files.WriteMode("overwrite"))

            return meta
        print('Uploaded to Dropbox successfully')
    except Exception as e:
        print('Error uploading file to Dropbox: ' + str(e))


try:
    dropbox_upload_file(local_path, local_file, dropbox_file_path)
    print("Successfully uploaded file to Dropbox")
except:
    print("Failed to upload file to Dropbox")