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

def pegar_versao_da_url(url: str):
    return ".".join(url.split(".")[3:6])

url_final = obter_url_final_de("https://telegram.org/dl/desktop/linux")
versao_antiga = DADOS.get('version') or "???"
versao_atual = pegar_versao_da_url(url_final)

if versao_antiga != versao_atual:
    print(f"telegram: {versao_antiga} -> {versao_atual}")
    hasher = hashlib.sha256()
    arquivo = requisicao(url_final)
    while True:
        buf = arquivo.read(16*1024)
        if not buf:
            break
        hasher.update(buf)
    DADOS = dict(
        version=versao_atual,
        sha256=f"sha256:{hasher.hexdigest()}",
        url=url_final
    )

# for arch in PROVEDORES.keys():
#     for variacao in PROVEDORES[arch].keys():
#         download_url = obter_url_final_de(PROVEDORES[arch][variacao], headers = {"user-agent": "curl/7.83.1"})
#         print(f"Buscando informações de discord: arquitetura={arch} variacao={variacao}")
#         versao_anterior=None
#         if DADOS.get(arch) is not None:
#             if DADOS.get(arch).get(variacao) is not None:
#                 versao_anterior = DADOS[arch][variacao]["version"]
#             else:
#                 DADOS[arch][variacao] = dict()
#         else:
#             DADOS[arch] = dict()
#             DADOS[arch][variacao] = dict()
#         versao_atual = pegar_versao_da_url(download_url)
#         if versao_anterior != versao_atual:
#             hasher = hashlib.sha256()
#             req_arquivo = requisicao(PROVEDORES[arch][variacao], headers = {"user-agent": "curl/7.83.1"})
#             print(f"Encontrada atualização arquitetura={arch} variacao={variacao} versão={versao_anterior} -> {versao_atual}")
#             while True:
#                 buf = req_arquivo.read(16*1024)
#                 if not buf:
#                     break
#                 hasher.update(buf)
#             hash_arquivo = f"sha256:{hasher.hexdigest()}"
#             DADOS[arch][variacao]['version'] = versao_atual
#             DADOS[arch][variacao]['url'] = download_url
#             DADOS[arch][variacao]['sha256'] = hash_arquivo

with open(str(ESTADO_JSON), 'w') as f:
    dump(DADOS, f, indent=2)
