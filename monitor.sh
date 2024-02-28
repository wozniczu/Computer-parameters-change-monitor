#!/bin/bash
#Projekt skryptu "Informacja o zmianie parametrów komputera"

#funkcja wypisująca parametry
print_param() {
    echo -e "Adres IP: $(hostname -I)\nIlość RAM:\n$(free -h)\nIlość procesorów: $(grep -c processor /proc/cpuinfo)"
}

#funkcja wysyłająca e-mail
send_email() {
    print_param | mail -s "Informacje o komputerze" $TO_EMAIL
    echo Wysłano wiadomość na: $TO_EMAIL
}

#sprawdzanie, czy ssmtp jest zainstalowane
if ! command -v ssmtp >/dev/null 2>&1
then
    echo "Nie znaleziono programu 'ssmtp'."
    exit 1
fi

#sprawdzanie, czy mailutils jest zainstalowane
if ! command -v mail >/dev/null 2>&1
then
    echo "Nie znaleziono programu 'mail' (paczka 'mailutils')."
    exit 1
fi

#sprawdzanie, czy istnieje plik konfiguracyjny ssmtp
if [ ! -f /etc/ssmtp/ssmtp.conf ]
then
    echo "Brak pliku konfiguracyjnego ssmtp '/etc/ssmtp/ssmtp.conf'."
    exit 1
fi

#sprawdzanie, czy istnieje plik konfiguracyjny
if [ ! -f config.txt ]
then
    echo "Brak pliku konfiguracyjnego."
    exit 1
fi

# wczytanie pliku konfiguracyjnego
source config.txt

# sprawdzenie, czy plik z informacjami istnieje, jeśli nie istnieje, to oznacza, że program jest uruchomiony po raz pierwszy
# więc wysyłamy mail z informacjami i zapisujemy informacje do pliku
# jeżeli plik istnieje, to odczytujemy z niego informacje i porównujemy z nowo odczytanymi informacjami
# jeżeli jakaś informacja się zmieniła, to wysyłamy e-mail i aktualizujemy plik
if [ ! -f monitor_info.txt ]
then
    send_email
    print_param > monitor_info.txt

else
    old_info=$(cat monitor_info.txt)
    new_info="Adres IP: $(hostname -I)\nIlość RAM:\n$(free -h)\nIlość procesorów: $(grep -c processor /proc/cpuinfo)"
    if [ "$old_info" != "$new_info" ]
    then
        send_email
        echo -e "$new_info" > monitor_info.txt
    fi
fi
