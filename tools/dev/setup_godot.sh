#!/usr/bin/env bash
# Prepares Godot 4.7.2 in a cloud session (D-161, D-162): reuses a binary that
# is already built, otherwise clones the official source and builds it in the
# background (about 25 min). Called by the SessionStart hook in
# .claude/settings.json; prints one short status line.
set -u
VERSION="4.7.2"
ROOT="${GODOT_BUILD_DIR:-$HOME/.cache/godot-$VERSION}"
BIN="$ROOT/src/bin/godot.linuxbsd.editor.x86_64"
LOG="$ROOT/build.log"
mkdir -p "$ROOT" "$HOME/.local/bin"

if command -v godot >/dev/null 2>&1 && godot --version 2>/dev/null | grep -q "^$VERSION"; then
  echo "Godot: $(godot --version) pronto."
  exit 0
fi
if [ -x "$BIN" ]; then
  ln -sf "$BIN" "$HOME/.local/bin/godot"
  echo "Godot: binário já compilado ligado em ~/.local/bin/godot."
  exit 0
fi
if [ -f "$ROOT/building" ]; then
  echo "Godot: compilação em andamento (log: $LOG)."
  exit 0
fi

touch "$ROOT/building"
(
  {
    [ -d "$ROOT/src" ] || git clone --depth 1 --branch "$VERSION-stable" https://github.com/godotengine/godot.git "$ROOT/src"
    # pip may be blocked in the session (pypi unreachable) while git clone works:
    # then run SCons straight from its source (pure Python, D-365).
    command -v scons >/dev/null 2>&1 || pip install -q scons || {
      [ -d "$HOME/.cache/tools/scons" ] || git clone -q --depth 1 https://github.com/SCons/scons.git "$HOME/.cache/tools/scons"
      printf '#!/usr/bin/env bash\nexec python3 %s/.cache/tools/scons/scripts/scons.py "$@"\n' "$HOME" > "$HOME/.local/bin/scons"
      chmod +x "$HOME/.local/bin/scons"
      export PATH="$HOME/.local/bin:$PATH"
    }
    cd "$ROOT/src" && scons platform=linuxbsd target=editor x11=no wayland=no vulkan=no opengl3=no \
      alsa=no pulseaudio=no dbus=no speechd=no fontconfig=no udev=no sdl=no accesskit=no -j"$(nproc)"
    status=$?
    if [ $status -eq 0 ] && [ -x "$BIN" ]; then
      ln -sf "$BIN" "$HOME/.local/bin/godot"
      echo "PRONTO"
    else
      echo "FALHOU ($status)"
    fi
  } > "$LOG" 2>&1
  rm -f "$ROOT/building"
) </dev/null >/dev/null 2>&1 &
disown
echo "Godot: compilação iniciada em segundo plano, cerca de 25 min (log: $LOG). Antes de testar, confira 'tail -1 $LOG' = PRONTO; depois rode git lfs pull e godot --headless --path game --import."
