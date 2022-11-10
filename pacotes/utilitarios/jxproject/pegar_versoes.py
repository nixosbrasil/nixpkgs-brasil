#!/usr/bin/env python3

from pathlib import Path
from json import load, dump
import re
import traceback
import hashlib

ESTA_PASTA=Path(__file__).parent
print("Pasta onde estão os dados: ", ESTA_PASTA)

ESTADO_JSON = ESTA_PASTA / "dados.json"

# se o arquivo não existe, criar um dicionário vazio
if not ESTADO_JSON.exists(): 
    with open(str(ESTADO_JSON), "w") as f:
        dump(dict(), f)

with open(str(ESTADO_JSON), "r") as f:
    DADOS = load(f)

def requisicao(url: str, **kwargs):
    from urllib import request
    return request.urlopen(request.Request(url, **kwargs))

hasher = hashlib.sha256()
resposta = requisicao("http://www.jxproject.com/installation/jxProject.tar")
while True:
    buf = resposta.read(16*1024)
    if not buf:
        break
    hasher.update(buf)
DADOS['sha256'] = f"sha256:{hasher.hexdigest()}"

with open(str(ESTADO_JSON), 'w') as f:
    dump(DADOS, f, indent=2)
