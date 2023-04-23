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
echo "Отключаем защиту от записи в SteamOS..."
sudo steamos-readonly disable
echo "Инициализация ключей Pacman..."
sudo pacman-key --init
echo "Заполнение ключей Arch Linux..."
sudo pacman-key --populate archlinux

echo "Установка lutris+proton qt менеджера"

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


}


function action_two() {







}


function action_three() {
    echo "Установка русской локали + lutris+proton qt менеджера"

    action_one
    action_two

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
        action_one
        ;;
    2)
        action_two
        ;;
    3)
        action_three
        ;;
    0)
        echo "Выход..."
        ;;
    *)
        echo "Неверный ввод, попробуйте еще раз."
        ;;
esac

echo "Скрипт успешно выполнен!"