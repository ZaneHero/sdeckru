#!/bin/bash

echo "░██████╗████████╗███████╗░█████╗░███╗░░░███╗"
echo "██╔════╝╚══██╔══╝██╔════╝██╔══██╗████╗░████║"
echo "╚█████╗░░░░██║░░░█████╗░░███████║██╔████╔██║"
echo "░╚═══██╗░░░██║░░░██╔══╝░░██╔══██║██║╚██╔╝██║"
echo "██████╔╝░░░██║░░░███████╗██║░░██║██║░╚═╝░██║"
echo "╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝"
echo ""
echo "██████╗░███████╗░█████╗░██╗░░██╗"
echo "██╔══██╗██╔════╝██╔══██╗██║░██╔╝"
echo "██║░░██║█████╗░░██║░░╚═╝█████═╝░"
echo "██║░░██║██╔══╝░░██║░░██╗██╔═██╗░"
echo "██████╔╝███████╗╚█████╔╝██║░╚██╗"
echo "╚═════╝░╚══════╝░╚════╝░╚═╝░░╚═╝"
echo "█▀█ █░█   █░░ █▀█ █▀▀ ▄▀█ █░░ █▀▀ ▄█▄ █░░ █░█ ▀█▀ █▀█ █ █▀"
echo "█▀▄ █▄█   █▄▄ █▄█ █▄▄ █▀█ █▄▄ ██▄ ░▀░ █▄▄ █▄█ ░█░ █▀▄ █ ▄█"


function action_one() {
echo "Установка русской локали"
temp_file=$(mktemp)

# Проверяем наличие файла /etc/locale.gen
if [ -f /etc/locale.gen ]; then
    # Читаем файл /etc/locale.gen и удаляем символ "#" перед строками "ru_RU.UTF-8" и "en_US.UTF-8", сохраняем результат во временном файле
    sed -e 's/^#\(.*ru_RU\.UTF-8\)/\1/' -e 's/^#\(.*en_US\.UTF-8\)/\1/' /etc/locale.gen > "$temp_file"

    # Заменяем оригинальный файл /etc/locale.gen на измененный файл
    sudo mv "$temp_file" /etc/locale.gen
else
    echo "Файл /etc/locale.gen не найден."
fi

echo "Обновляем glbic..."
sudo pacman -Syu glibc
sudo locale-gen

temp_file1=$(mktemp)

# Проверяем наличие файла /etc/locale.conf
if [ -f /etc/locale.conf ]; then
    # Заменяем "LANG=en_US.UTF-8" на "LANG=ru_RU.UTF-8" и сохраняем результат во временном файле
    sed 's/LANG=en_US\.UTF-8/LANG=ru_RU.UTF-8/' /etc/locale.conf > "$temp_file1"

    # Заменяем оригинальный файл /etc/locale.conf на измененный файл
    sudo mv "$temp_file1" /etc/locale.conf
else
    echo "Файл /etc/locale.conf не найден."
fi

sudo localectl set-locale ru_RU.UTF-8
sudo rm ~/.config/plasma-localerc
echo "Скрипт смены локали успешно выполнен!"
}


function action_two() {
echo "Установка Lutris"
flatpak remote-add flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak update --appstream
flatpak install flathub org.gnome.Platform.Compat.i386//44 
flatpak install org.freedesktop.Platform.GL32.default//21.08
flatpak install org.freedesktop.Platform.GL.default//21.08
flatpak install flathub-beta net.lutris.Lutris

echo "Установка Protonupqt"
flatpak install flathub net.davidotek.pupgui2
echo "Запуск Protonupqt"
flatpak run net.davidotek.pupgui2
echo "Установите последнюю версию Protonupqt"
echo "Скрипт установки lutris + protonupqtуспешно выполнен!"
}

function action_remove() {
echo "Отключаем защиту от записи в SteamOS..."
sudo steamos-readonly disable
echo "Инициализация ключей Pacman..."
sudo pacman-key --init
echo "Заполнение ключей Arch Linux..."
sudo pacman-key --populate archlinux
}
function action_make() {
sudo steamos-readonly enable
}
# Отображаем меню выбора
echo "Выберите действие:"
echo "1) Установка русской локали"
echo "2) Установка lutris+proton qt менеджера"
echo "3) Установка русской локали + lutris+proton qt менеджера"
echo "0) Выход"

# Получаем ввод пользователя
read -p "Введите номер действия: " choice

# Выполняем соответствующее действие или выходим
case $choice in
    1)
        action_remove
        action_one
        action_make
        ;;
    2)
        action_remove
        action_two
        action_make
        ;;
    3)
        echo "Установка русской локали + lutris+proton qt менеджера"
        action_remove
        action_one
        action_two
        action_make
        ;;
    0)
        echo "Выход..."
        ;;
    *)
        echo "Неверный ввод, попробуйте еще раз."
        ;;
esac

