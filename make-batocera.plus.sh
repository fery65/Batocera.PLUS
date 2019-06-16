#!/bin/sh
################################################################################

# Versão do Batocera.PLUS.
VERSION='4.01'

# Pasta temporária em uma partição Linux.
TEMP_DIR='tmp'
#TEMP_DIR='/media/NO_LABEL/tmp'
#TEMP_DIR='/media/NO_LABEL_1/tmp'

# Imagem oficial do batocera.linux.
IMG_OFICIAL='img/batocera-5.22-x86_64-20190609.img.gz'
IMG_ZERO='img/BatoceraZero3GB.7z'

# Arquivos extras do Batocera.PLUS.
PLUS_DIR='plus'
BOOT_DIR='boot'

################################################################################

echo 'Descompactando Batocera oficial...'
mkdir -p "$TEMP_DIR"

if ! [ -f "$IMG_OFICIAL" ]; then
    echo "A imagem $IMG_OFICIAL não foi encontrada!"
    exit $?
fi

gunzip -k "$IMG_OFICIAL" -c > "$TEMP_DIR/Batocera.PLUS.img" || exit $?

echo 'Adicionando imagem oficial do batocera.linux ao disposivo loop...'
losetup -f
losetup /dev/loop7 -o $((512 * 1263)) "$TEMP_DIR/Batocera.PLUS.img" || exit $?

echo 'Montando imagem oficial do batcera.linux...'
mkdir "$TEMP_DIR/BATOCERA"
mount -o rw /dev/loop7 "$TEMP_DIR/BATOCERA" || exit $?

echo 'Descompactando arquivo squashfs...'
unsquashfs -d "$TEMP_DIR/squashfs-root" "$TEMP_DIR/BATOCERA/boot/batocera" || exit $?

echo 'Removendo arquivos desnecessários...'
rm -r "$TEMP_DIR/squashfs-root/usr/share/icons/Adwaita" || exit $?

rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/c64/super_mario_bros_64_-_zeropaige.zip"  || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/c64/The_Great_Giana_Sisters.d64" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/gba/SpaceTwins.gba" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/nes/2048 (tsone).nes" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/pcengine/Reflectron (aetherbyte).pce" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/pcengine/Reflectron (aetherbyte).readme.txt" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/pcengine/Santatlantean (aetherbyte).pce" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/pcengine/Santatlantean (aetherbyte).readme.txt" || exit $?
rm -r "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/prboom/game-musics" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/prboom/doom1_shareware.wad" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/prboom/doom1_shareware_license.txt" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/prboom/prboom.wad" || exit $?
rm    "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/roms/snes/DonkeyKongClassic (Shiru).smc" || exit $?

#echo 'Mudando o nome executável do retroarch'
#mv   "$TEMP_DIR/squashfs-root/usr/bin/retroarch' 'squashfs-root/usr/bin/retroarch.sh' || exit $?

echo Desativando servicos...
mv    "$TEMP_DIR/squashfs-root/etc/init.d/S49ntp"          "$TEMP_DIR/squashfs-root/etc/init.d/K49ntp"          || exit $?
mv    "$TEMP_DIR/squashfs-root/etc/init.d/S10triggerhappy" "$TEMP_DIR/squashfs-root/etc/init.d/K10triggerhappy" || exit $?

echo 'Desativando atualizações automáticas...'
sed -i s/'https:\/\/batocera-linux.xorhub.com\/upgrades//' "$TEMP_DIR/squashfs-root/recalbox/scripts/recalbox-config.sh"                       || exit $?
sed -i s/'https:\/\/batocera-linux.xorhub.com\/upgrades//' "$TEMP_DIR/squashfs-root/recalbox/scripts/recalbox-upgrade.sh"                      || exit $?
sed -i s/'^updates.enabled=1/updates.enabled=0/'           "$TEMP_DIR/squashfs-root/usr/share/batocera/datainit/system/batocera.conf"          || exit $?

echo 'Aumentando o tamanho do arquivo overlay...'
sed -i s/'^OVERLAYSIZE=.*/OVERLAYSIZE=128 # M/'            "$TEMP_DIR/squashfs-root/recalbox/scripts/recalbox-save-overlay.sh" || exit $?

echo 'Resolvendo o bug do PC não desligar / reiniciar...'
sed -i s/'^shd2:06:wait:\/bin\/umount -a -r -f/shd2:06:wait:\/bin\/umount -a -r/' "$TEMP_DIR/squashfs-root/etc/inittab"  || exit $?

echo 'Fazendo backup do arquivo es_systems.cfg...'
mv    "$TEMP_DIR/squashfs-root/usr/share/emulationstation/es_systems.cfg" \
      "$TEMP_DIR/squashfs-root/usr/share/emulationstation/es_systems.cfg.original" || exit $?

echo 'Criando arquivo de versão...'
mv   "$TEMP_DIR/squashfs-root/usr/share/batocera/batocera.version" "$TEMP_DIR/squashfs-root/usr/share/batocera/recalbox.version" || exit $?
echo "$VERSION $(date +'%Y/%m/%d %H:%M')" > "$TEMP_DIR/squashfs-root/usr/share/batocera/batocera.version"  || exit $?

echo 'Definindo emuladores padrões...'
sed -i s'/core:     mame078/core:     mame0200/' "$TEMP_DIR/squashfs-root/recalbox/system/configgen/configgen-defaults.yml" || exit $?

echo 'Ativando permissão de execução para arquivos copiados por rede...'
sed -i s'/create mask = 0644/create mask = 0744/'  "$TEMP_DIR/squashfs-root/etc/samba/smb.conf"        || exit $?
sed -i s'/^create mask = 0600/create mask = 0700/' "$TEMP_DIR/squashfs-root/etc/samba/smb-secure.conf" || exit $?

echo 'Copiando arquivos do batocera.plus...'
cp -r -f "$PLUS_DIR/"* "$TEMP_DIR/squashfs-root"  || exit $?

echo 'Descompactando Libretro mame0200...'
###7zr x "$TEMP_DIR/squashfs-root/usr/lib/libretro/mame0200_libretro.so.7z.001" -o"$TEMP_DIR/squashfs-root/usr/lib/libretro" || exit $?
###rm -f "$TEMP_DIR/squashfs-root/usr/lib/libretro/mame0200_libretro.so.7z."*

echo 'Descompactando Firefox libxul.so...'
7zr x "$TEMP_DIR/squashfs-root/opt/Firefox/firefox-esr/libxul.so.7z" -o"$TEMP_DIR/squashfs-root/opt/Firefox/firefox-esr" || exit $?
rm -f "$TEMP_DIR/squashfs-root/opt/Firefox/firefox-esr/libxul.so.7z"

echo 'Compactando arquivo squashfs...'
mksquashfs "$TEMP_DIR/squashfs-root/"* "$TEMP_DIR/batocera" || exit $?

echo 'Descompactando imagem do BatoceraZero...'
7zr x "$IMG_ZERO" -o"$TEMP_DIR" || exit $?

echo 'Adicionando imagem BatoceraZero ao dispositivo loop...'
losetup -o $((512 * 1263)) /dev/loop6 "$TEMP_DIR/BatoceraZero.img" || exit $?

echo 'Montando imagem do BatoceraZero...'
mkdir "$TEMP_DIR/BatoceraZero"
mount /dev/loop6 "$TEMP_DIR/BatoceraZero" || exit $?

echo 'Movendo arquivos de boot para o Batocera.PLUS...'
rm "$TEMP_DIR/BATOCERA/boot/batocera"              || exit $?
mv "$TEMP_DIR/BATOCERA/"* "$TEMP_DIR/BatoceraZero" || exit $?

echo 'Movendo arquivo squashfs para o Batocera.PLUS...'
mv "$TEMP_DIR/batocera" "$TEMP_DIR/BatoceraZero/boot/batocera" || exit $?

echo 'Copiando arquivos extras para o Batocera.PLUS...'
cp -r -f "$BOOT_DIR/"* "$TEMP_DIR/BatoceraZero" || exit $?

echo 'Adicionando opção de resolução em recalbox-boot.conf'
echo ''                                                                          >> "$TEMP_DIR/BatoceraZero/batocera-boot.conf" || exit $?
echo '#Open a terminal (Win + F2) type xrandr to see all supported resolutions.' >> "$TEMP_DIR/BatoceraZero/batocera-boot.conf" || exit $?
echo '#resolution=1280x720x60'                                                   >> "$TEMP_DIR/BatoceraZero/batocera-boot.conf" || exit $?

echo 'Desmontando imagens...'
umount /dev/loop7 || exit $?
umount /dev/loop6 || exit $?

echo 'Removendo imagens dos disposivos loop...'
losetup -d /dev/loop7 || exit $?
losetup -d /dev/loop6 || exit $?

echo 'Removendo arquivos temporários...'
rmdir "$TEMP_DIR/BATOCERA"          || exit $?
rmdir "$TEMP_DIR/BatoceraZero"      || exit $?
rm -r "$TEMP_DIR/squashfs-root"     || exit $?
rm    "$TEMP_DIR/Batocera.PLUS.img" || exit $?

mv    "$TEMP_DIR/BatoceraZero.img" "$TEMP_DIR/Batocera.PLUS.img" || exit $?

sync

echo 'Imagem criada! Pressione qualquer tecla para concluir'
read -n 1

exit 0
