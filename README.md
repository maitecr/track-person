# Track

Projeto desenvolvido como atividade avaliativa no curso de Análise e Desenvolvimento de sistemas. Consiste em um aplicativo mobile que permite monitorar em tempo real as pessoas que forem cadastradas nele, além de enviar notificações para o usuário quando a pessoa monitorada se encontrar fora das localidades delimitadas a ela como seguras.

## A aplicação permite:
* Cadastro do usuário
* Logout
* Inserir pessoa monitorada
* Adicionar mais de uma área de segurança para a mesma pessoa
* Monitorar no mapa o deslocamento em tempo real
* Notificar quando o monitorado está fora da área de segurança

A aplicação foi desenvolvida usando Flutter, Dart, Firebase e a API do Google Cloud para utilização do Maps. 

Para exibir rastreio em tempo real, foi desenvolvida uma segunda aplicação que é executada em segundo plano no dispositivo da pessoa monitorada, enviando sua posição geográfica para o Firebase, tornando possível a funcionalidade de monitoramento do presente projeto. Esta segunda aplicação poode ser encontrada [neste repositório](https://github.com/maitecr/tracked-patient).

## Como executar

* Adição do google-services.json para autenticação e serviços Firebase 
* Habilitação de serviços do Firebase (Firebase Auth, Firestore)
* Inserir sua Google API Key nos arquivos:
```
android\app\src\main\AndroidManifest.xml
```
```
lib\util\location_util.dart
```
* Instalar dependências: `flutter pub get`
* Executar código: `flutter run`

## Demonstração
Você pode conferir um vídeo demonstrativo da aplicação em execução [neste link](https://www.youtube.com/shorts/V-rgGpLCWGs)
