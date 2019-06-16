#!/bin/sh

##
 # Mozilla Firefox
 # Este script executa o navegador firefox no batocera-linux
 # Testado no batocera-linux 5.19 (pode funcionar em outras)
 # Funciona com PC x86_64
 #
 # Autor:  Alexandre Freire dos Santos
 # E-Mail: alexxandre.freire@gmail.com
 # Data:   07/jan/2019
 # Local:  São Paulo, SP, Brasil
 ##

################################################################################

##
 # Define o local para salvar o perfil (save).
 ##
SAVE_DIR=$HOME/../saves/internet/firefox

##
 # Pasta de downloads para os arquivos baixados da internet.
 ##
DOWNLOADS_DIR=$HOME/../downloads

##
 # Diretório de roms (links)
 ##
ROM_DIR=$HOME/../roms/internet

##
 # Local dos arquivos que fazem o firefox ser executado no Batocera.PLUS.
 ##
APP_DIR=/opt/Firefox

##
 # Define o tipo de conteúdo que será executado pelo navegador.
 # Ex. flash, internet
 ##
SYSTEM="$1"

##
 # Nome e local do conteúdo a ser executado pelo navegador.
 ##
ROM="$2"

##
 # Local dos arquivos do firefox, ideal para usar o navegar em outros idiomas
 # e para atualizar o navegador.
 ##
if [ -f "$ROM_DIR/firefox/firefox" ]; then
    FIREFOX_DIR="$ROM_DIR/firefox"
else
    FIREFOX_DIR="$APP_DIR/firefox-esr"
fi

################################################################################

##
 # Bibliotecas extras.
 ##
#ln -s -f $APP_DIR/extra-libs/libgtk-3-original.so.0    $APP_DIR/extra-libs/libgtk-3.so.0
ln -s -f $APP_DIR/extra-libs/libgtk-3-alternative.so.0 $APP_DIR/extra-libs/libgtk-3.so.0

export LD_LIBRARY_PATH="$APP_DIR/extra-libs"
export XDG_DATA_DIRS="/usr/share:$APP_DIR/extra-libs"


################################################################################

##
 # Instala fonts padrões do Windows no Firefox para evitar incompatibilidades de sites.
 ##
rm -r -f $FIREFOX_DIR/fonts
ln -s -f $APP_DIR/fonts-windows $FIREFOX_DIR/fonts

################################################################################

##
 # Cria o perfil padrao (save) e a pasta de downloads.
 ##
if ! [ -e $SAVE_DIR ]; then
    mkdir -p $SAVE_DIR
    7zr x $APP_DIR/default-profile/default-profile.7z -o$SAVE_DIR

    mkdir -p $DOWNLOADS_DIR
    ln -s -f $DOWNLOADS_DIR $SAVE_DIR/Downloads
fi

################################################################################

##
 # Instala o flash plugin.
 ##
mkdir -p /usr/lib/mozilla/plugins
ln -s -f $APP_DIR/flash-plugin/libflashplayer.so /usr/lib/mozilla/plugins

################################################################################

##
 # Resolve o problema com o som.
 # Usa a mesma saída de som padrão do Batocera no Firefox.
 # Agradescimentos: Adriano de Souza
 #                  Membro do grupo "Batocera linux (recalbox x86)" no facebook
 ##
if [ -e $HOME/asound.state ]; then
    if ! [ -e $SAVE_DIR/asound.state ]; then
        ln -s $HOME/asound.state $SAVE_DIR
    fi
elif [ -e $SAVE_DIR/asound.state ]; then
    rm $SAVE_DIR/asound.state
fi

if [ -e $HOME/.asoundrc ]; then
    if ! [ -e $SAVE_DIR/.asoundrc ]; then
        ln -s $HOME/.asoundrc $SAVE_DIR
    fi
elif [ -e $SAVE_DIR/.asoundrc ]; then
    rm $SAVE_DIR/.asoundrc
fi

################################################################################
##
 # Ativa o ponteiro do mouse.
 ##
mouse-pointer on

################################################################################

##
 #  Executa o navegador normalmente.
 #  Quando não é passado nenhum parâmetro.
 ##
if ! [ -f "$ROM" ]; then
    LD_LIBRARY_PATH="$APP_DIR/apulse${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
    HOME="$SAVE_DIR" "$FIREFOX_DIR/firefox" --profile "$SAVE_DIR"
    exit 0
fi
if [ "$SYSTEM" == 'internet' ]; then
    if ! [ "$(head -n 1 "$ROM")" ]; then
        LD_LIBRARY_PATH="$APP_DIR/apulse${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
        HOME="$SAVE_DIR" "$FIREFOX_DIR/firefox" --profile "$SAVE_DIR"
        exit 0
    fi
fi

################################################################################

##
 # Configura o navegador para abrir com todas orelhas fechadas.
 ##
### Faz backup do arquivo de configuração do navegaor antes de fazer alterações.
cp "$SAVE_DIR/sessionstore.jsonlz4" "$SAVE_DIR/sessionstore.jsonlz4.original"
cp "$SAVE_DIR/prefs.js"             "$SAVE_DIR/prefs.js.original"
### Fecha todas orelhas.
sed -i s/'^user_pref("browser.startup.page", .*/user_pref("browser.startup.page", 1);/' "$SAVE_DIR/prefs.js"

################################################################################

##
 # Abre o navegador na página escolhida.
 ##
if [ "$SYSTEM" == 'internet' ]; then
    ### Abre o navegador com todas as orelhas fechadas
    LD_LIBRARY_PATH="$APP_DIR/apulse${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
    HOME="$SAVE_DIR" "$FIREFOX_DIR/firefox" --profile "$SAVE_DIR" "$(head -n 1 "$ROM")"
fi

################################################################################

##
 # Executa o navegador com o conteúdo em flash.
 ##
if [ "$SYSTEM" == 'flash' ]; then
    ### Força o navegar a executar animações em flash offline.
    if [ "$(cat $SAVE_DIR/prefs.js | grep plugins.http_https_only)" ]; then
        sed -i s/'^user_pref("plugins.http_https_only", .*/user_pref("plugins.http_https_only", false);/' "$SAVE_DIR/prefs.js"
    else
        echo 'user_pref("plugins.http_https_only", false);' >> "$SAVE_DIR/prefs.js"
    fi

    ### Abre o navegador com o conteúdo em flash.
    LD_LIBRARY_PATH="$APP_DIR/apulse${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
    HOME="$SAVE_DIR" "$FIREFOX_DIR/firefox" --profile "$SAVE_DIR" "$ROM"
fi

################################################################################

##
 # Restaura as configurações do navegador.
 ##
mv -f "$SAVE_DIR/prefs.js.original"             "$SAVE_DIR/prefs.js"
mv -f "$SAVE_DIR/sessionstore.jsonlz4.original" "$SAVE_DIR/sessionstore.jsonlz4"
mouse-pointer off  # Desativa o ponteiro do mouse.

exit 0
