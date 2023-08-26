#!/usr/bin/env python3

from urllib.request import urlopen, Request
from hashlib import sha256
from pathlib import Path
from json import load, dump

SOURCES_FILE = Path(__file__).parent / "sources.json"

DATA = {}
try:
    if SOURCES_FILE.exists():
        with open(str(SOURCES_FILE), 'r') as f:
            DATA = load(f)
except Exception as e:
    print(e)

def request_json(url: str, **kwargs):
    """
    Request url and parse response as json
    """
    with urlopen(Request(url, **kwargs)) as res:
        return load(res)

def hash_url(url: str, **kwargs):
    """
    Request url and hash response as sha256
    """
    print(f"Downloading and hashing '{url}'...")
    hasher = sha256()
    with urlopen(Request(url, **kwargs)) as res:
        while True:
            buf = res.read(16*1024)
            if not buf:
                break
            hasher.update(buf)
    return f"sha256:{hasher.hexdigest()}"

github_data = request_json("https://api.github.com/repos/39aldo39/libdecsync/releases/latest")  # get release data from github
latest_version = github_data['tag_name'][1:]  # get tag name in vx.y.z form and cut out the v

# print(f"'{DATA['version']}', '{latest_version}'")
if DATA.get('version') == latest_version:
    print("This is the latest version")
    exit(0)

DATA = dict(version=latest_version)

for asset in github_data['assets']:
    file_name = asset['name']
    file_hash = hash_url(asset['browser_download_url'])
    DATA[file_name] = dict(
        url=asset['browser_download_url'],
        hash=file_hash
    )

DATA["source.tar.gz"] = dict(
    url=github_data['tarball_url'],
    hash=hash_url(github_data['tarball_url'])
)

with open(str(SOURCES_FILE), 'w') as f:
    dump(DATA, f, indent=2, sort_keys=True)
