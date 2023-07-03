#!/usr/bin/env python3

from pathlib import Path
from json import load, dump
import re
import traceback

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
    from urllib import request
    with request.urlopen(url, **kwargs) as resposta:
        # é esperado que se der algum problema um erro vai rolar então passar status code seria redundante
        return load(resposta)

def requisitar_extensao(slug: str):
    json = requisitar_json(f"https://addons.mozilla.org/api/v5/addons/addon/{slug}/")
    return dict(
        nome=json['name'][json['default_locale']],
        description=json['summary'][json['default_locale']],
        version=json['current_version']['version'],

        download_url=json['current_version']['file']['url'],
        download_hash=json['current_version']['file']['hash'],

        homepage=json['url'],
    )

def handle_extensao(slug: str, name = None):
    try:
        print(f"Buscando dados da extensão '{slug}'")
        import re
        if name is None:
            name = slug
        assert re.match("[a-zA-Z_-]*", name)
        info_extensao = requisitar_extensao(slug)
        info_extensao['name'] = name
        DADOS[name] = info_extensao
    except Exception as e:
        print(e)
        traceback.print_exc()

# coloque cada uma das extensões a serem buscadas aqui
handle_extensao("bitwarden-password-manager")
handle_extensao("facebook-container")
handle_extensao("darkreader")
handle_extensao("i-dont-care-about-cookies")
handle_extensao("languagetool")
handle_extensao("sponsorblock")
handle_extensao("tampermonkey")
handle_extensao("tweak-new-twitter")
handle_extensao("ublock-origin")
handle_extensao("floccus")
handle_extensao("video-downloadhelper")

with open(str(ESTADO_JSON), 'w') as f:
    dump(DADOS, f, indent=2)
