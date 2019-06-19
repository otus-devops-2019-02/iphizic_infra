# iphizic_infra
iphizic Infra repository

# How To

## Ansible
   + Создан простой плейбук
   + Создан inventory файл для описания информации
   инфраструктуры
   + Создан скрипт для автоматического инвентори
   
### Как работает скрипт
   Скрипт формирует JSON ответы в консоль согласно спецификации,
   использует tfstate файл для получения ip адресов хостов.
   
   Запуск в текущей конфигурации происходит по следующему алгоритму:
   + запустить terraform из папки прод сформировав файл переменных
   + запустить пинг для проверки при помощи комманды
     ```bash
      ansible all -m ping
     ```

## GCP

 ### Подготовка
 
  + Cоздать хранилище с инвентарем, для этого нам понадобится ~~ведро с 
  гвоздями~~ bucket со скриптами для быстрого старта, создаем коммандой:  
       ```bash
       gsutil mb gs://startup-infra
       ```
  + Создать скрипт для билда при запуске, здесь он представлен как 
  startup_script.sh и закинуть его в инвентарь коммандой:
      ```bash
      gsutil cp startup_script.sh  gs://startup-infra
      ```
 ### Разворот поворот
 
  + Тут все просто, для создания магии кастуем заклинание
    ```bash
    gcloud compute instances create reddit-app \
           --boot-disk-size=10GB \
           --image-family ubuntu-1604-lts \
           --image-project=ubuntu-os-cloud \
           --machine-type=g1-small 
           --tags puma-server \
           --restart-on-failure \
           --metadata startup-script-url=gs://startup-infra/startup_script.sh
    ```
  Обратите внимание на последний параметр, он заправляет магией разворачивания 
  приложения автоматически.
  
  ### Путешествие взад назад
   
  + На этом этапе хочется пойти и подчивать себя чаем ~~с подозрительно 
  сладким запахом~~ в связи с успехом, но внезапно ничего не работает, после 
  неопределенного времени поиска проблем ~~и пары сожженых стульев~~,
  мы обнаружим ~~пепел на своей голове~~ фаервол, и примемся за настройку:
      ```bash
      gcloud compute firewall-rules create puma-input \
            --action allow \
            --target-tags puma-server \
            --source-ranges 0.0.0.0/0 \
            --rules tcp:'port'
      ```
  Главное не забыть, что тег сервера и теги в фаерволе должны совпадать.
  В настройке вместо 'port' указать порт приложения, tcp это сетевой протокол.
  После чего можно со спокойной душой отправляться успокаивать нервы.

## SSH
 + Чтобы приконнектится к хосту через бастион одной коммандой необходимо использовать 
 комманду следующего вида:
 
    ```bash
    ssh -A bastion ssh iphizic@10.166.0.2 
    ```
      
     Во первых мы можем увидеть алиас бастиона, который может быть записан 
     В конфигурационный файл ~/.ssh/config добавлением следующего кода:
     
     ```bash
     Host bastion                     # Здесь описывается алиас по которому можно обращаться
          HostName 35.207.87.ХХХ      # Здесь описывается ip адрес хоста или его DNS имя
          User iphizic                # Здесь описывается логин для аутентификации
          IdentityFile ~/.ssh/id_rsa  # Здесь описывается путь к файлу закрытого ключа
     ```
     
     Однако при попытке подключения мы увидим ошибку:
     
     ```bash
     $ ssh -A bastion ssh iphizic@10.166.0.2
     Pseudo-terminal will not be allocated because stdin is not a terminal.
     ```
     Это связано с тем что консоль пытается открыть две интерактивные сессии сразу и 
     они тут-же падают, поэтому используем параметр который логинится без открытия 
     интерактивной консоли, и комманда будет выглядить так:
     ```bash
     ssh -A -t bastion ssh iphizic@10.166.0.2 
     ```
 + Второй способ более предпочтителен, но не всегда может быть использован
 это добавление позволяет экономить время, как вы уже догадались, это
 применение конфигурационного файла:
   ```bash
   Host somehost
     HostName 10.166.0.2
     User iphizic
     ProxyCommand ssh -W %h:%p iphizic@35.207.87.209
   ```
   Здесь используется перенаправление stdin и stdout которое позволяет
   использовать данный способ даже на недоверенных бастионах. Но в случаях 
   часто изменяющегося ip не очень удобно.
   
# For bot

   ```bash
   bastion_IP = 35.207.87.209
   someinternalhost_IP = 10.166.0.2   
   ```   
   
   ```bash
   testapp_IP = 35.204.66.177
   testapp_port = 9292  
   ``` 
