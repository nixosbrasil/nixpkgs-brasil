#!/usr/bin/env python3

from pathlib import Path
from json import load, dump, dumps
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

def requisitar_json(url: str, **kwargs):
    from urllib.request import urlopen, Request
    req = Request(url, **kwargs)
    with urlopen(req) as resposta:
        # é esperado que se der algum problema um erro vai rolar então passar status code seria redundante
        return load(resposta)

def urlhash(url, **kwargs):
    from urllib.request import urlopen, Request
    import hashlib
    hasher = hashlib.sha256()
    req = Request(url, **kwargs)
    with urlopen(req) as resposta:
        # é esperado que se der algum problema um erro vai rolar então passar status code seria redundante
        while True:
            buf = resposta.read(16*1024)
            if not buf:
                break
            hasher.update(buf)
        return f"sha256:{hasher.hexdigest()}"



def requisitar_extensao_marketplace(autor: str, extensao: str):
    metadado_extensao = requisitar_json(
        'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery',
        method="POST",
        headers={
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0',
            'Content-Type': 'application/json',
            'Accept': 'application/json;api-version=7.1-preview.1;excludeUrls=true'
        },
        data=dumps({
            "assetTypes": None,
            "filters":[
                {
                    "criteria": [
                        {
                            "filterType": 7,
                            "value": f"{autor}.{extensao}"
                        }
                    ],
                    "direction":2,
                    "pageSize":100,
                    "pageNumber":1,
                    "sortBy":0,
                    "sortOrder":0,
                    "pagingToken": None
                }
            ],
            "flags":2151
        }).encode('ascii')
    )
    metadado_extensao = metadado_extensao['results'][0]['extensions'][0]
    return dict(
        publisher=metadado_extensao['publisher']['publisherName'],
        name=metadado_extensao['extensionName'],
        description=metadado_extensao['shortDescription'],
        versions=list(map(lambda item: item['version'], metadado_extensao['versions']))
    )

def handle_extensao(autor: str, extensao: str, ultimo_apenas=True):
    try:
        chave = f"{autor}.{extensao}"
        print(f"Buscando dados da extensão '{chave}'")
        metadados = requisitar_extensao_marketplace(autor, extensao)
        if DADOS.get(chave) is None:
            DADOS[chave] = dict(
                description=metadados['description'],
                author=autor,
                extension=extensao,
                versions=dict()
            )
        if ultimo_apenas:
            metadados['versions'] = [ metadados['versions'][0] ]
        for version in metadados['versions']:
            print(f"Buscando versão {version} da extensão '{chave}'")
            if DADOS[chave]['versions'].get(version) is None:
                url=f"https://{metadados['publisher']}.gallery.vsassets.io/_apis/public/gallery/publisher/{metadados['publisher']}/extension/{metadados['name']}/{version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
                DADOS[chave]['versions'][version] = dict(
                    url=url,
                    sha256=urlhash(url)
                )
    except Exception as e:
        print(e)
        traceback.print_exc()

with (ESTA_PASTA / "extensoes_para_buscar.txt").open('r') as f:
    for ext in f:
        splitted = ext.strip().split(".")
        assert len(splitted) == 2, f"A extensão {ext} está no formato errado, deve estar no formato autor.nome"
        owner, name = splitted
        handle_extensao(owner, name)

# coloque cada uma das extensões a serem buscadas aqui

with open(str(ESTADO_JSON), 'w') as f:
    dump(DADOS, f, indent=2)
