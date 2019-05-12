---
title: "Mapa de Áreas Prioritárias para o Manejo de Gatos"
author: "Tati Micheletti / Instituto Brasileiro para Medicina da Conservação"
date: "10 May 2019"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, eval = TRUE)
```

### Introdução

Conforme o Plano de Manejo de Gatos de Fernando de Noronha, aprovado por meio da PORTARIA Nº 58, DE 4 DE FEVEREIRO DE 2019, o presente trabalho descreve o método utilizado para a criação do Mapa de Áreas Prioritárias para o Manejo de Gatos no Parque Nacional Marinho de Fernando e áreas do entorno (Objetivo Específico 1.2).

### Método

O presente utiliza dois dados principais para a criação do mapa: elevação e densidade de gatos encontrada. A elevação funciona como proxy ou indicador da probabilidade de ninhais de aves marinhas (em especial rabo-de-junco e atobas, ameaçados de extinção). Racionalizou-se que quanto maior a elevação, maior a probabilidade de ninhos (ja que a ilha vulcânica abriga ninhos dessas espécies em seus costões), e maior a necessidade de proteção dos mesmos. Em relação à densidade, quanto maior a densidade, maior a necessidade de se controlar gatos na área.
O modelo utilizado, portanto pode ser definido como:

`prioridade ~ elevação * densidade`

Esse mapa é um mapa relativo; as áreas mais escuras tem maior prioridade de trabalho que as áreas mais escuras, mas os números em si não representam nada. Os dados utilizados nesse trabalho vieram de uma publição em revista científica (Dias, R.A., Abrahão, C.R., Micheletti, T. et al. Prospects for domestic and feral cat management on an inhabited tropical island. Biol Invasions (2017) 19: 2339. https://doi.org/10.1007/s10530-017-1446-9), com valores de densidade atualizados para a região do Capim-Açu e Sueste por Sobral et al. 2019, *in prep*.

### Resultados

O Mapa foi criado com a utilização do software aberto R (R Development Team, 2019). Para tal, for construído um pacote com a função `makePriorityMap`. É necessário, portanto, instalar o pacote e rodar a função. Esta função irá criar um objeto em R com o raster gerado, assim como um arquivo em `.tif` (raster) do mapa.

```{r instalar}
mapa <- makePriorityMap()
```
