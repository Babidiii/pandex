FROM docker.io/pandoc/latex

RUN apk update && apk add --no-cache entr
RUN tlmgr update --all --self
RUN tlmgr install tcolorbox pgf xcolor environ trimspaces mathpazo parskip adjustbox collectbox eurosym enumitem ulem collection-fontsrecommended
# RUN sudo tlmgr install collection-fontsrecommended 

