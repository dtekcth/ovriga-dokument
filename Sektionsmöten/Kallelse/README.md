# Sektionsmöteskallelse how-to

Sektionsmötesmallen är uppbyggd med hjälp av sektionens LaTeX-klass dtekkallelse.cls (mer information på http://github.com/dtekcth/dtek-tex).
För att kunna använda det medföljande skriptet (kudos till Johan Sjöblom, [github.com/sjoblomj](https://github.com/sjoblomj)) krävs lite setup:

## Setup för makescript.
1. Kallelserna måste ligga i var sin mapp med namn "sektionsmotes_xx" där xx är en siffra mellan 1 och 256 och betecknar vilket möte i ordningen det är.
2. Möteskallelsen ska heta mote.tex.
3. dtekkallelse.cls och Datalogo.pdf måste finnas i texlive's path (exempelvis i texmf/ mappen i användarens hem-mapp)

## Hur skriptet fungerar.
Skriptet kommer leta upp den senaste möteskallelsen (mappen med den högsta siffran)och sen typsätta dess mote.tex fil med `xelatex`. Skriptet kommer då att skapa tre olika pdf-dokument: agenda.pdf; dagordning.pdf och kallelse.pdf från mote.tex.
Innehållet i de olika dokumenten beror på vad som är skrivet i de olika kommandon givna av dtekkallelse (läs mer på repots README).

Om skriptet inte hittar rätt mapp (om den inte hittar en mapp med namnet sektionsmote_xx) kommer den fråga om vilken mapp den ska leta i.
