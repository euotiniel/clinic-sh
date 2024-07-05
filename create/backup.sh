#!/bin/bash

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root." > /dev/null 2>&1
    exit 1
fi

# Variáveis de configuração
DISPOSITIVO="/dev/sda"
TAMANHO_PARTICAO="100M"
PONTO_DE_MONTAGEM="/mnt/backup"
USUARIO_PROPRIETARIO="root"
GRUPO_PROPRIETARIO="root"

# Criar nova partição com fdisk
echo -e "n\np\n\n\n+${TAMANHO_PARTICAO}\nw" | fdisk "$DISPOSITIVO" > /dev/null 2>&1

# Formatar a nova partição como ext4
NOVA_PARTICAO="${DISPOSITIVO}1"
echo "y" | mkfs.ext4 "$NOVA_PARTICAO" > /dev/null 2>&1

# Criar diretório de ponto de montagem, se não existir
mkdir -p "$PONTO_DE_MONTAGEM" > /dev/null 2>&1

# Montar a nova partição
mount "$NOVA_PARTICAO" "$PONTO_DE_MONTAGEM" > /dev/null 2>&1

# Ajustar permissões de propriedade, se definido
if [ -n "$USUARIO_PROPRIETARIO" ] && [ -n "$GRUPO_PROPRIETARIO" ]; then
    chown -R "$USUARIO_PROPRIETARIO:$GRUPO_PROPRIETARIO" "$PONTO_DE_MONTAGEM" > /dev/null 2>&1
fi

# Obter UUID da nova partição
UUID=$(blkid -s UUID -o value "$NOVA_PARTICAO" 2>/dev/null)

# Adicionar entrada ao /etc/fstab para montagem automática
echo "UUID=$UUID   $PONTO_DE_MONTAGEM   ext4   defaults   0   2" >> /etc/fstab > /dev/null 2>&1

# Finalizar o script
exit 0

exit 0


