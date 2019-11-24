Lösungschecker
==============
Lösungschecker ist eine kleine Webanwendung mit der bspw. Lehrende kleine Webanwendungen zur Überprüfung von Lösungswörtern erstellen und an Schüler_innen* weiter geben können.
Alle Daten sind in der URL der individuellen Checker kodiert und außer Verkehrsdaten werden keinerlei Daten an einen Server übertragen und/oder dort gespeichert.

Anwendung
---------
Lehrende erstellen mit der Webanwendung eine Checkerseite und geben die auf der Folgeseite angezeigte URL (zB. als QR-Code zum scannen) an Schüler_innen* weiter. Rufen Schüler_innen* die Seite mit dieser URL auf, können sie durch Eingabe des Lösungswortes die eigene Lösung überprüfen. Die richtige Lösung wird visuell zurück gemeldet.

Installation
------------
Die Anwendung ist in Elm geschrieben, zur Kompilierung muss `elm` auf dem System verfügbar sein.
Installation von `elm`:
```sh
npm install -g elm
```
Repository clonen und Anwendung kompilieren:
```sh
git clone https://github.com/bubens/L-sungschecker.git
cd L-sungschecker
elm make --optimize src/Main.elm
```
Im Verzeichnis erscheint eine `index.html`-Datei. Diese kann unter Beachtung der Lizenzbedingungen auf dem eigenen Webspace/Server angeboten werden.

Todo
----
* __IMPORTANT__ make URL flexible (eg. do not hardcode)
* improve feedback for correct solutions
* give case-sensitive option in creator
* make QR-Code downloadable
* give language option
* offer make-script
* include reward/continue here link/embed
* make it look even nicerer
