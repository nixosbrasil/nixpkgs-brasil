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

def requisitar_json(url: str, **kwargs):
    with requisicao(url, **kwargs) as resposta:
        # é esperado que se der algum problema um erro vai rolar então passar status code seria redundante
        return load(resposta)

def requisitar_texto(url: str, **kwargs):
    with requisicao(url, **kwargs) as resposta:
        # é esperado que se der algum problema um erro vai rolar então passar status code seria redundante
        return resposta.read().decode('utf8')

def obter_url_final_de(url: str, **kwargs):
    with requisicao(url, **kwargs) as resposta:
        # é esperado que se der algum problema um erro vai rolar então passar status code seria redundante
        return resposta.url

ultima_release = requisitar_json("https://api.github.com/repos/Jarred-Sumner/bun-releases-for-updater/releases/latest")

versao_antiga = DADOS.get("version")
versao_nova = ultima_release.get("tag_name").replace("bun-v", "")

print("Checando se existe novidades")

if versao_antiga != versao_nova:
    print(f"Existe novidades: versão {versao_antiga} -> {versao_nova}")
    variations = {}
    for asset in ultima_release["assets"]:
        variation = asset["name"].replace(".zip", "")
        url = asset["browser_download_url"]
        print(f"Carregando variação {variation}")

        res = requisicao(url)
        hasher = hashlib.sha256()
        while True:
            buf = res.read(16*1024)
            if not buf:
                break
            hasher.update(buf)
        variations[variation] = dict(
            url=url,
            sha256=f"sha256:{hasher.hexdigest()}"
        )
    DADOS["version"] = versao_nova
    DADOS["variacoes"] = variations

with open(str(ESTADO_JSON), 'w') as f:
    dump(DADOS, f, indent=2)
