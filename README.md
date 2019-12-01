# Lösungschecker
Lösungschecker ist eine kleine Webanwendung mit der bspw. Lehrende kleine Webanwendungen zur Überprüfung von Lösungswörtern erstellen und an Schüler_innen* weiter geben können.
Alle Daten sind in der URL der individuellen Checker kodiert und außer Verkehrsdaten werden keinerlei Daten an einen Server übertragen und/oder dort gespeichert.

## Anwendung
Lehrende erstellen mit der Webanwendung eine Checkerseite und geben die auf der Folgeseite angezeigte URL (zB. als QR-Code zum scannen) an Schüler_innen* weiter. Rufen Schüler_innen* die Seite mit dieser URL auf, können sie durch Eingabe des Lösungswortes die eigene Lösung überprüfen. Die richtige Lösung wird visuell zurück gemeldet.

## Installation
### Vorbereitungen:
Die Anwendung ist in der Programmiersprache Elm geschrieben. Bei der Erstellung des Skripts wird `uglifyjs` zur Minifikation und Optimerung eingesetzt. Beides muss auf dem System verfügbar sein.
Außerdem muss eine Kopie der neuesten Version der Anwendung herunter geladen werden.
```sh
# Installation von elm:
npm install -g elm

# Installation von uglifyjs:
npm install -g uglify-js

# Kopie der aktuellsten Version herunterladen:
git clone https://github.com/bubens/L-sungschecker.git
```

### Erstellung der Anwendung
Der heruntergeladene Code enthält ein Skript, dass die Erstellung der Anwendung übernimmt. 

```sh
# In den Code-Ordner wechseln
cd L-sungschecker

# Anwendungsskript ausführen:
./make.sh
```
Die Anwendung ist nach Ausführung des Skripts im Release-Ordner (`rel/`) zu finden. Sie enthält die HTML-Seite (`index.html`) und eine minifizierte Javascript-Datei (`l-sungscheker.js`).

Todo
----
* __IMPORTANT__ make URL flexible (eg. do not hardcode)
* improve feedback for correct solutions
* give case-sensitive option in creator
* make QR-Code downloadable
* give language option
* ~~offer make-script~~
* include reward/continue here link/embed
* make it look even nicerer
