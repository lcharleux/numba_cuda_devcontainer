import os
import pwd
from string import Template
import json
import shutil
import hashlib

# MY VOLUMES
if not os.path.isfile("my_volumes.json"):
    shutil.copy("my_volumes_template.json", "my_volumes.json")
my_volumes = json.load(open("my_volumes.json"))

data = {
    "USER_NAME": os.environ.get("USER"),
    "UID": str(pwd.getpwnam(os.environ.get("USER")).pw_uid),
    "GID": str(pwd.getpwnam(os.environ.get("USER")).pw_gid),
    "TAG": "0.0",
    "CONTAINER_REPO_PATH": os.path.relpath("../", "../target_volume/") + "/",
}

# TEMPLATE
dct = Template(open("docker-compose_template.yml").read().strip()).substitute(data)


if len(my_volumes) != 0:
    dct += "\n" + 4 * " " + "volumes:" + "\n" + 6 * " "
for volume in my_volumes:
    dct += "- {0}:{1}".format(volume["host"], volume["target"])
    if "read_only" in volume.keys() and volume["read_only"]:
        dct += ":ro"
    dct += "\n" + 6 * " "

dct = dct.strip()

open("docker-compose.yml", "w").write(dct)

# ENV FILE CREATION
current_dir = os.getcwd()
hash_value = hashlib.sha256(str.encode(current_dir)).hexdigest()
user_name = data["USER_NAME"]
open("../.env", "w").write(f"COMPOSE_PROJECT_NAME={user_name}_{hash_value}")
