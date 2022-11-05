{ stdenv
, lib
, wineWowPackages
, writeShellScript
, winetricks
, cabextract
, gnused
, fuse-overlayfs
, xvfb-run
, default-prefix-dir ? "~/.nix-wine"
}:
let
  _wine = wineWowPackages.full;
in
{ wine ? _wine
, is32bits ? true
, prefix-dir ? default-prefix-dir
, pname ? "wine-launcher"
, version ? null
, name ? "${attrs.pname}${lib.optionalString (attrs.version != null) "-${attrs.version}"}"
, key
, appInstall ? ""
, appRun ? ""
, prelude ? ""
, extraPackages ? []
}@attrs:
let
  binPath = [ wine winetricks cabextract gnused fuse-overlayfs ] ++ extraPackages;
in writeShellScript "wine-launcher" ''
export PATH="$PATH:${lib.makeBinPath binPath}"

export WINEARCH=${if is32bits then "win32" else "win64"}

export PREFIX_ROOT=${prefix-dir}/${key}

${prelude}

mkdir -p "$PREFIX_ROOT/_var"

function appInstall {
  export WINEPREFIX="$PREFIX_ROOT/_var/install"
  wineboot -i
  ${appInstall}
  wineserver -w
  fusermount -u $WINEPREFIX
}

function appRun {
  export WINEPREFIX="$PREFIX_ROOT/run"
  ${appRun}
  wineserver -w
  fusermount -u $WINEPREFIX
}

if test -v REPL; then
  bash
fi

mkdir -p $PREFIX_ROOT{/_var,}/{install,run}

if [ ! -f "$PREFIX_ROOT/_var/install/.done" ]; then
  # fuse-overlayfs -o auto_unmount -o lowerdir=$PREFIX_ROOT/_var/install,upperdir=$PREFIX_ROOT/_var/install,workdir=$(mktemp -d) "$PREFIX_ROOT/install" || exit 1
  appInstall
  touch "$PREFIX_ROOT/_var/install/.done"
else
  ln -sf "$PREFIX_ROOT/_var/install" "$PREFIX_ROOT/_var/run/super"
  fusermount -u "$PREFIX_ROOT/run" || true
  fuse-overlayfs -o auto_unmount -o lowerdir=$PREFIX_ROOT/_var/install,upperdir=$PREFIX_ROOT/_var/run,workdir=$(mktemp -d) "$PREFIX_ROOT/run"
  if [ -f "$PREFIX_ROOT/run/.done" ]; then
    appRun "$@"
  fi
fi

rm ~/.local/share/applications/wine* -rf
''
