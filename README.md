---
title: "Mapa de Áreas Prioritárias para o Manejo de Gatos"
author: "Tati Micheletti / Instituto Brasileiro para Medicina da Conservação"
date: "10 May 2019"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, eval = TRUE)
```

### Introdução

Conforme o Plano de Manejo de Gatos de Fernando de Noronha, aprovado por meio da PORTARIA Nº 58, DE 4 DE FEVEREIRO DE 2019, o presente trabalho descreve o método utilizado para a criação do Mapa de Áreas Prioritárias para o Manejo de Gatos no Parque Nacional Marinho de Fernando e áreas do entorno (Objetivo Específico 1.2).

### Método

Duas versões estão disponíveis:  

*VERSÃO 1:*  

O presente utiliza dois dados principais para a criação do mapa: elevação e densidade de gatos encontrada. A elevação funciona como proxy ou indicador da probabilidade de ninhais de aves marinhas (em especial rabo-de-junco e atobas, ameaçados de extinção). Racionalizou-se que quanto maior a elevação, maior a probabilidade de ninhos (ja que a ilha vulcânica abriga ninhos dessas espécies em seus costões), e maior a necessidade de proteção dos mesmos. Em relação à densidade, quanto maior a densidade, maior a necessidade de se controlar gatos na área.
O modelo utilizado, portanto pode ser definido como:

`prioridade ~ elevação * densidade de gatos`

*VERSÃO 2:*  

O presente utiliza três dados principais para a criação do mapa: localização real de ninhos de aves marinhas, um ranking de importância das espécies (aves ameaçadas e que nidificam no solo tem maior importância), e densidade de gatos encontrada. É 
importante ressaltar que ambas covariáveis foram normalizadas, e os resultados foram interpoldos para diluir of efeitos nas 
bordas das áreas.  
O modelo utilizado, portanto pode ser definido como:

`prioridade ~ presença de ninho/ninhal * ranking de prioridade de espécies + densidade de gatos`


Esse mapa é um mapa relativo; as áreas mais escuras tem maior prioridade de trabalho que as áreas mais claras, mas os números em si não representam nada. Os dados utilizados nesse trabalho vieram de uma publição em revista científica (Dias, R.A., Abrahão, C.R., Micheletti, T. et al. Prospects for domestic and feral cat management on an inhabited tropical island. Biol Invasions (2017) 19: 2339. https://doi.org/10.1007/s10530-017-1446-9), com valores de densidade atualizados para a região do Capim-Açu e Sueste por Sobral et al. 2019, *in prep*.

### Resultados

O Mapa foi criado com a utilização do software aberto R (R Development Team, 2019). Para tal, for construído um pacote com a função `makePriorityMap`. É necessário, portanto, instalar o pacote e rodar a função. Esta função irá criar um objeto em R com o raster gerado, assim como um arquivo em `.tif` (raster) do mapa. Primeiramente você deverá instalar o pacote `devtools`, seguido da instalação do presente pacote, e por último, a função para a geração do mapa: 

```{r instalar}
install.packages("devtools", repos = "http://cran.us.r-project.org")
devtools::install_github("tati-micheletti/makePriorityMapFN")
library(makePriorityMapFN)
mapa <- makePriorityMapFN::makePriorityMap()
```
### Explorando o mapa

Caso seja de interesse explorar outros parâmetros para a geração do mapa, pode-se utilizar primeiramente a função `rankSpecies`. 
Essa função permite a criação de uma tabela de espécies prioritárias. O default é uma tabela gerada com informações cedidas pelo CEMAVE/ICMBio (Patricia Serafini pers. comm.). O ranking é relativo, e o valor `1` deve ser atribuído à(s) espécies com menor prioridade.

```{r rank}
spRank <- rankSpecies(species = c("Phaethon lepturus", "Phaethon aethereus", "Sula dactylatra",
                      "Sula sula", "Sula leucogaster", "Arenaria interpres", "Onychoprion fuscatus",
                      "Anous minutus", "Gygis alba", "Anous stolidus",
                      "Bubulcus ibis"),
                      ranking = seq(11:1))
```

Também é possível customizar o mapa em si. A definição de cada argumento segue abaixo:  

- `useNewerData`:          O default é TRUE. Esse argumento atualiza os dados de Dias et. al 2017 em relação à densidade de gatos no 
                           PARNAMAR/FN baseado em un trabalho mais recente e aprofundado desenvolvido por Sobral et al. 2019 *in prep*.  
                           
- `version`:               O default é `"2"`. Esse é o argumento utilizado para escolher a versão de construção do mapa (ver seção                                  `Método` acima)  

- `bufferNests`:           O default é 400m. Essa é a distância ao redor do ponto do ninho/ninhal em que se considera como prioritária.                            É criada em forma de buffer ao redor do ponto.  

- `speciesOrder`:          O default é `NULL`. Pode ser deixado vazio ou passado o objeto criado com a função `rankSpecies()`.  

- `interpolationDistance`: O default é `250`. Indica o quanto o efeito dos ninhos é homogenizado na paisagem. Quanto maior o valor, mais                            menos concentrado o efeito do ninho/ninhal na área em que ele se encontra.  

- `wholeIsland`:           O default é `FALSE`. Se FALSE, faz o mapa somente para o PARNAMAR. Se for `TRUE`, faz para PARNAMAR e APA.  
