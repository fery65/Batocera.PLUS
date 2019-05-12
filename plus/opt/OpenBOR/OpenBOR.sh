#!/bin/sh
################################################################################
#
# OpenBOR
# Este script executa a engine de jogos OpenBOR no Batocera.PLUS
# Autor:  Alexandre Freire dos Santos
# E-Mail: alexxandre.freire@gmail.com
# Local:  Sao Paulo, SP, Brasil
#
################################################################################

### Local dos arquivos do OpenBOR.
OPENBOR_DIR='/opt/OpenBOR'

### Local para salvar o progresso nos jogos (save).
SAVE_DIR="$HOME/../saves/openbor"

### Local para os Paks (roms) para o OpenBOR.
ROMS_DIR="$HOME/../roms/openbor"

## Local para os arquivos temporários.
TMP_DIR="/tmp/OpenBOR"

################################################################################

### Pasta temporária para arquivos usados pelo OpenBOR
if [ -e "$TMP_DIR" ]; then
    rm -r "$TMP_DIR"
else
    mkdir -p "$TMP_DIR"
fi

### Local para salvar o progrresso no jogo.
mkdir -p "$SAVE_DIR"
ln -s "$SAVE_DIR" "$TMP_DIR/Saves"

### Local para gravar os arquivos de log do OpenBOR.
mkdir -p "$HOME/logs"
ln -s "$HOME/logs" "$TMP_DIR/Logs"

### Local para salvar prints de tela do OpenBOR.
mkdir -p "$HOME/../screenshots"
ln -s "$HOME/../screenshots" "$TMP_DIR/ScreenShots"

### Configura o jogo que será executado pelo OpenBOR.
mkdir -p "$ROMS_DIR"
if [ -e "$1" ]; then
    # Executa o jogo pelo menu do Emulationstation.
    mkdir -p "$TMP_DIR/Paks"
    ln -s "$1" "$TMP_DIR/Paks"
else
    # Executa o jogo pela interface do OpenBOR.
    ln -s "$ROMS_DIR" "$TMP_DIR/Paks"
fi

################################################################################

### Instala Bibliotecas extras.
ln -s -f "$OPENBOR_DIR/lib/libSDL2_gfx-1.0.so.0" '/lib'
ln -s -f "$OPENBOR_DIR/lib/libvpx.so.5"          '/lib'	

### Arquivo de configuração que ativa tela cheia.
if ! [ -e "$SAVE_DIR/default.cfg" ]; then
    cp "$OPENBOR_DIR/lib/default.cfg" "$SAVE_DIR"
fi

################################################################################

### Executa o OpenBOR.
cd "$TMP_DIR"
"$OPENBOR_DIR/OpenBOR"

################################################################################

### Remove arquivos temporários.
rm -r "$TMP_DIR"

exit 0
